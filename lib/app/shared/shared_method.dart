part of 'shared.dart';

void setTimeOut(Function onDone,
    {Duration duration = const Duration(seconds: 1)}) {
  Timer.periodic(duration, (timer) {
    timer.cancel();
    onDone();
  });
}
