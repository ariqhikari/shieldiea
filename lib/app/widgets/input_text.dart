part of 'widgets.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final bool isEnabled;
  final bool isNumber;

  const InputText({
    Key? key,
    required this.controller,
    required this.hint,
    this.validator,
    this.onChanged,
    this.isEnabled = true,
    this.isNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: mediumNunitoFontStyle.copyWith(
          fontSize: 16,
          color: '424242'.toColor(),
        ),
        validator: validator,
        keyboardType: isNumber != false ? TextInputType.number : null,
        decoration: defaultInputStyle.copyWith(
          hintText: hint,
          enabled: isEnabled,
          fillColor: isEnabled ? null : lightGrayColor.withOpacity(.5),
        ),
      ),
    );
  }
}
