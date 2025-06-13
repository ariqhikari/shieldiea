part of 'widgets.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int index)? onTap;

  const CustomBottomNavigation({
    Key? key,
    this.selectedIndex = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: '000000'.toColor().withOpacity(.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // * Home
            GestureDetector(
              onTap: () {
                if (onTap != null) onTap!(0);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 18,
                ),
                child: Column(
                  children: [
                    // * Icon
                    SvgPicture.asset(
                      (selectedIndex == 0)
                          ? 'assets/icons/ic_home.svg'
                          : 'assets/icons/ic_home_normal.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(height: 4),
                    // * Title
                    Text(
                      'Beranda',
                      style: mediumNunitoFontStyle.copyWith(
                        color:
                            ((selectedIndex == 0) ? successColor : grayColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // * Manage
            GestureDetector(
              onTap: () {
                if (onTap != null) onTap!(1);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 18,
                ),
                child: Column(
                  children: [
                    // * Icon
                    SvgPicture.asset(
                      (selectedIndex == 1)
                          ? 'assets/icons/ic_kelola.svg'
                          : 'assets/icons/ic_kelola_normal.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(height: 4),
                    // * Title
                    Text(
                      'Data Anak',
                      style: mediumNunitoFontStyle.copyWith(
                        color:
                            ((selectedIndex == 1) ? successColor : grayColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // * Profile
            GestureDetector(
              onTap: () {
                if (onTap != null) onTap!(2);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 18,
                ),
                child: Column(
                  children: [
                    // * Icon
                    SvgPicture.asset(
                      (selectedIndex == 2)
                          ? 'assets/icons/ic_profile.svg'
                          : 'assets/icons/ic_profile_normal.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(height: 4),
                    // * Title
                    Text(
                      'Profil',
                      style: mediumNunitoFontStyle.copyWith(
                        color:
                            ((selectedIndex == 2) ? successColor : grayColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
