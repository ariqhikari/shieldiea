part of 'widgets.dart';

class Button extends StatelessWidget {
  final String text;
  final ButtonStyle? buttonStyle;
  final Function onTap;
  final bool isDisabled;
  final double? width;
  final double? height;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonStyle,
    this.width,
    this.height = 60,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
        style: buttonStyle ?? defaultButtonStyle,
        onPressed: (!isDisabled)
            ? () {
                onTap();
              }
            : null,
        child: Text(
          text,
          style: boldNunitoFontStyle.copyWith(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
