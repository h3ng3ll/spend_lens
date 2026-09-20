part of 'product_detail_bloc.dart';

extension ProductDetailStateExt on ProductDetailState {
  bool get isInitial => status == EProductDetailStatus.initial;

  bool get isLoading => status == EProductDetailStatus.loading;

  bool get isReady => status == EProductDetailStatus.ready;

  /// The product row itself is gone — distinct from having no prices, which
  /// is an ordinary `ready` state with an empty list.
  bool get isNotFound => status == EProductDetailStatus.notFound;

  bool get isFailed => status == EProductDetailStatus.failed;

  bool get isWriteFailed => lastWriteFailed;
}
