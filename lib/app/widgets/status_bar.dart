part of 'widgets.dart';

class StatusBar extends StatelessWidget {
  final Brightness brightness;
  final Widget child;

  const StatusBar({
    Key? key,
    this.brightness = Brightness.light,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
