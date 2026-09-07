import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

extension BlocExt on Bloc {
  EventTransformer<E> debounceTransformer<E>(
    Duration duration,
  ) =>
      (
        events,
        mapper,
      ) =>
          events
              .debounceTime(
                duration,
              )
              .flatMap(
                mapper,
              );
}
