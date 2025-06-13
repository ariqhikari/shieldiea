part of 'widgets.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> titles;
  final Function(int index) onTap;

  const CustomTabBar({
    super.key,
    required this.titles,
    required this.onTap,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            margin: const EdgeInsets.only(top: 48),
            color: 'E1E3E5'.toColor(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: titles
                .map(
                  (title) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: GestureDetector(
                      onTap: () {
                        onTap(titles.indexOf(title));
                      },
                      child: Column(
                        children: [
                          // * Title
                          Text(
                            title,
                            style: (titles.indexOf(title) == selectedIndex)
                                ? boldNunitoFontStyle.copyWith(
                                    color: yellowColor,
                                  )
                                : semiBoldNunitoFontStyle.copyWith(
                                    color: grayColor),
                          ),
                          // * Border
                          AnimatedContainer(
                            width: MediaQuery.of(context).size.width / 3.15,
                            height: 3,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.5),
                              color: (titles.indexOf(title) == selectedIndex)
                                  ? yellowColor
                                  : Colors.transparent,
                            ),
                            duration: animationDuration,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
