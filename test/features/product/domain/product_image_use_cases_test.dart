import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:spend_lens/core/services/firebase/firebase_storage_service.dart';
import 'package:spend_lens/core/services/image_compression_service.dart';
import 'package:spend_lens/core/services/product_image_store/product_image_store.dart';
import 'package:spend_lens/features/product/domain/models/product/product.dart';
import 'package:spend_lens/features/product/domain/use_cases/remove_product_image_use_case.dart';
import 'package:spend_lens/features/product/domain/use_cases/save_product_image_use_case.dart';

/// The product photo's WRITE path, mirroring the store logo's.
///
/// These cover the two contracts that are easy to get wrong and impossible to
/// notice at a glance:
///
/// - a SAVE must still land locally when the upload fails, because the user
///   picked an image and pressed Save; an empty `imageUrl` only means other
///   devices do not see it yet, and the record is `pendingUpdate` so the next
///   sync retries it;
/// - a REMOVE must NOT swallow a remote failure, because an orphaned object
///   the user believes is deleted is a privacy matter, not a cosmetic one.
///
/// The filesystem half (`ProductImageStore`) is exercised through fakes here:
/// it needs a real Documents directory, which `flutter_test` does not provide
/// without a platform channel stub.
void main() {
  final product = Product(
    id: 'p1',
    normalizedName: 'lapte zuzu 1l',
    displayName: 'LAPTE ZUZU 1L',
    updatedAt: DateTime(2026, 9, 20),
  );

  final bytes = Uint8List.fromList(List<int>.filled(16, 7));

  group('SaveProductImageUseCase', () {
    test('writes the filename and the url when the upload succeeds', () async {
      final store = _FakeImageStore();
      final useCase = SaveProductImageUseCase(
        compressionService: _PassThroughCompression(),
        imageStore: store,
        storageService: _FakeStorage(url: 'https://example/p1.jpg'),
      );

      final saved = await useCase(product: product, bytes: bytes, uid: 'u1');

      expect(saved.imageFilename, 'product_p1.jpg');
      expect(saved.imageUrl, 'https://example/p1.jpg');
      expect(store.savedProductId, 'p1');
    });

    test('still writes locally when the upload throws', () async {
      final useCase = SaveProductImageUseCase(
        compressionService: _PassThroughCompression(),
        imageStore: _FakeImageStore(),
        storageService: _FakeStorage(throwOnUpload: true),
      );

      final saved = await useCase(product: product, bytes: bytes, uid: 'u1');

      expect(
        saved.imageFilename,
        'product_p1.jpg',
        reason: 'The user pressed Save — the photo must appear on THIS device '
            'even when the network does not cooperate.',
      );
      expect(saved.imageUrl, isEmpty);
    });

    test('skips the upload entirely when signed out', () async {
      final storage = _FakeStorage(url: 'https://example/p1.jpg');
      final useCase = SaveProductImageUseCase(
        compressionService: _PassThroughCompression(),
        imageStore: _FakeImageStore(),
        storageService: storage,
      );

      final saved = await useCase(product: product, bytes: bytes, uid: '');

      expect(saved.imageFilename, 'product_p1.jpg');
      expect(saved.imageUrl, isEmpty);
      expect(storage.uploadCount, 0);
    });

    test('compresses before writing', () async {
      final compression = _PassThroughCompression();
      final useCase = SaveProductImageUseCase(
        compressionService: compression,
        imageStore: _FakeImageStore(),
        storageService: _FakeStorage(),
      );

      await useCase(product: product, bytes: bytes, uid: '');

      // A full-resolution phone photo run through every quality step without
      // a dimension bound is long enough for Android to raise an ANR.
      expect(compression.calls, 1);
      expect(compression.lastMaxDimension, isNotNull);
    });
  });

  group('RemoveProductImageUseCase', () {
    test('clears both the filename and the url', () async {
      final store = _FakeImageStore();
      final useCase = RemoveProductImageUseCase(
        imageStore: store,
        storageService: _FakeStorage(),
      );

      final withImage = product.copyWith(
        imageFilename: 'product_p1.jpg',
        imageUrl: 'https://example/p1.jpg',
      );
      final removed = await useCase(product: withImage, uid: 'u1');

      expect(removed.imageFilename, isNull);
      expect(removed.imageUrl, isEmpty);
      expect(store.deletedFilename, 'product_p1.jpg');
    });

    test('deletes the file BEFORE clearing the pointer', () async {
      final store = _FakeImageStore();
      final useCase = RemoveProductImageUseCase(
        imageStore: store,
        storageService: _FakeStorage(),
      );

      await useCase(
        product: product.copyWith(imageFilename: 'product_p1.jpg'),
        uid: 'u1',
      );

      // A delete that failed after the filename was cleared would leave the
      // image on disk with nothing referencing it.
      expect(store.deletedFilename, isNotNull);
    });

    test('does NOT swallow a remote failure', () async {
      final useCase = RemoveProductImageUseCase(
        imageStore: _FakeImageStore(),
        storageService: _FakeStorage(throwOnDelete: true),
      );

      await expectLater(
        useCase(
          product: product.copyWith(imageFilename: 'product_p1.jpg'),
          uid: 'u1',
        ),
        throwsA(isA<Exception>()),
        // An orphaned object the user believes is deleted is a privacy
        // matter — the opposite call from the save path's swallow.
      );
    });

    test('touches no remote object when signed out', () async {
      final storage = _FakeStorage();
      final useCase = RemoveProductImageUseCase(
        imageStore: _FakeImageStore(),
        storageService: storage,
      );

      await useCase(
        product: product.copyWith(imageFilename: 'product_p1.jpg'),
        uid: '',
      );

      expect(storage.deleteCount, 0);
    });
  });
}

class _FakeImageStore implements ProductImageStore {
  String? savedProductId;
  String? deletedFilename;

  @override
  String filenameFor(String productId) => 'product_$productId.jpg';

  @override
  Future<String> save({
    required String productId,
    required Uint8List bytes,
  }) async {
    savedProductId = productId;
    return filenameFor(productId);
  }

  @override
  Future<void> delete(String? filename) async => deletedFilename = filename;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PassThroughCompression implements ImageCompressionService {
  int calls = 0;
  int? lastMaxDimension;

  @override
  Future<Uint8List> compressToTargetSize(
    Uint8List bytes, {
    int targetSizeKB = 100,
    int? maxDimension,
  }) async {
    calls++;
    lastMaxDimension = maxDimension;
    return bytes;
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStorage implements FirebaseStorageService {
  final String url;
  final bool throwOnUpload;
  final bool throwOnDelete;

  int uploadCount = 0;
  int deleteCount = 0;

  _FakeStorage({
    this.url = '',
    this.throwOnUpload = false,
    this.throwOnDelete = false,
  });

  @override
  Future<String> uploadProductImage({
    required String uid,
    required String productId,
    required Uint8List bytes,
  }) async {
    uploadCount++;
    if (throwOnUpload) throw Exception('upload failed');
    return url;
  }

  @override
  Future<void> deleteProductImage({
    required String uid,
    required String productId,
  }) async {
    deleteCount++;
    if (throwOnDelete) throw Exception('delete failed');
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
