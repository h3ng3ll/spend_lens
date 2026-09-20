part of 'products_bloc.dart';

extension ProductsStateExt on ProductsState {
  bool get isInitial => status == EProductsStatus.initial;

  bool get isLoading => status == EProductsStatus.loading;

  bool get isReady => status == EProductsStatus.loaded;

  bool get isFailed => status == EProductsStatus.failed;

  bool get isWriteFailed => lastWriteFailed;
}
