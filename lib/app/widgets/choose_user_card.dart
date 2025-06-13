part of 'widgets.dart';

class ChooseUserCard extends StatelessWidget {
  final String icon;
  final String title;
  final Function onTap;

  const ChooseUserCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: lightGreenColor, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: semiBoldNunitoFontStyle.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
