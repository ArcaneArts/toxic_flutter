import 'package:flutter/widgets.dart';

extension XSStream<T> on Stream<T> {
  StreamBuilder<T> build(Widget Function(T) builder, {Widget? loading}) =>
      StreamBuilder<T>(
        stream: this,
        builder: (context, snap) => snap.hasData
            ? builder(snap.data!)
            : loading ?? const SizedBox.shrink(),
      );

  StreamBuilder<T?> buildNullable(Widget Function(T?) builder) =>
      build(builder, loading: builder(null));
}
