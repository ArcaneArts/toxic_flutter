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

class FutureOnce<T> extends StatefulWidget {
  final Future<T> Function() futureFactory;
  final Widget Function(T) builder;
  final Widget? loading;

  const FutureOnce({
    super.key,
    required this.futureFactory,
    required this.builder,
    this.loading,
  });

  @override
  FutureOnceState<T> createState() => FutureOnceState<T>();
}

class FutureOnceState<T> extends State<FutureOnce<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.futureFactory();
  }

  @override
  Widget build(BuildContext context) {
    return _future.build(widget.builder, loading: widget.loading);
  }
}
