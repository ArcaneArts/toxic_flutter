import 'package:flutter/widgets.dart';

extension TFFuture<T> on Future<T> {
  FutureBuilder<Widget> buildNullable(Widget Function(T?) builder) =>
      build(builder, loading: builder(null));

  FutureBuilder<Widget> build(Widget Function(T) builder, {Widget? loading}) =>
      FutureBuilder<Widget>(
        future: then(builder),
        builder: (context, snap) =>
            snap.hasData ? snap.data! : loading ?? const SizedBox.shrink(),
      );
}
