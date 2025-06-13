part of 'widgets.dart';

class InputTextWhite extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final bool isEnabled;
  final bool isNumber;

  const InputTextWhite({
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
        style: semiBoldNunitoFontStyle.copyWith(fontSize: 16),
        validator: validator,
        keyboardType: isNumber != false ? TextInputType.number : null,
        decoration: whiteInputStyle.copyWith(
          hintText: hint,
          enabled: isEnabled,
          fillColor: isEnabled ? null : lightGrayColor.withOpacity(.5),
        ),
      ),
    );
  }
}
