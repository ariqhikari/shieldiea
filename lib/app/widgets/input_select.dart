part of 'widgets.dart';

class InputSelect extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool isChevron;

  const InputSelect(
    this.title, {
    Key? key,
    required this.onTap,
    this.isChevron = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: whiteColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: semiBoldNunitoFontStyle,
                ),
                SvgPicture.asset('assets/icons/ic_chevron_down.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
