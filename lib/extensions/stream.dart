import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

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

class StreamOnce<T> extends StatefulWidget {
  final Stream<T> Function() streamFactory;
  final Widget Function(T) builder;
  final Widget? loading;

  const StreamOnce({
    super.key,
    required this.streamFactory,
    required this.builder,
    this.loading,
  });

  @override
  StreamOnceState<T> createState() => StreamOnceState<T>();
}

class StreamOnceState<T> extends State<StreamOnce<T>> {
  late BehaviorSubject<T> _subject;
  late Stream<T> _stream;
  late StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();
    _stream = widget.streamFactory();
    _subject = BehaviorSubject<T>();
    _subscription = _stream.listen((event) => _subject.add(event));
  }

  @override
  void dispose() {
    _subscription.cancel();
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _subject.build(widget.builder, loading: widget.loading);
}
