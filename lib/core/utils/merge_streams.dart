import 'dart:async';

/// Forwards events from all [streams]; completes when every one is done.
/// Cancelling the result cancels every source subscription.
Stream<T> mergeStreams<T>(Iterable<Stream<T>> streams) {
  final sources = streams.toList();
  final subs = <StreamSubscription<T>>[];
  late final StreamController<T> controller;
  controller = StreamController<T>(
    onListen: () {
      var active = sources.length;
      if (active == 0) {
        controller.close();
        return;
      }
      for (final stream in sources) {
        subs.add(stream.listen(
          controller.add,
          onError: controller.addError,
          onDone: () {
            if (--active == 0) controller.close();
          },
        ));
      }
    },
    onPause: () {
      for (final sub in subs) {
        sub.pause();
      }
    },
    onResume: () {
      for (final sub in subs) {
        sub.resume();
      }
    },
    onCancel: () => Future.wait(subs.map((sub) => sub.cancel())),
  );
  return controller.stream;
}
