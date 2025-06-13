part of 'widgets.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: '00000080'.toColor(),
      child: Center(
        child: makeLoadingIndicator(color: whiteColor),
      ),
    );
  }
}
