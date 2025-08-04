import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/features/entry/logic/bottom_nav_provider.dart';
import 'package:organicplants/features/home/presentation/screens/home_screen.dart';
import 'package:organicplants/features/profile/presentation/screens/profile_screen.dart';
import 'package:organicplants/features/search/presentation/screens/search_screen.dart';
import 'package:organicplants/features/store/presentation/screen/store_screen.dart';
import 'package:organicplants/shared/buttons/cart_icon_with_batdge.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    const StoreScreen(),
    const SearchScreen(),
    const ProfileScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = context.select<BottomNavProvider, int>(
      (p) => p.currentIndex,
    );

    // Ensure no focus is active when switching screens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex != 2) {
        // Not search screen
      }
    });

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: EntryScreen._screens),

      /// Only BottomNavigationBar listens for changes
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder:
            (context, provider, _) => Container(
              height: AppSizes.bottomNavHeight,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.bottomNavRadius),
                  topRight: Radius.circular(AppSizes.bottomNavRadius),
                ),
                boxShadow: AppShadows.bottomNavShadow(context),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                enableFeedback: true,
                currentIndex: provider.currentIndex,
                iconSize: 20.sp,
                selectedFontSize: 11.sp,
                unselectedFontSize: 11.sp,
                selectedItemColor: colorScheme.primary,
                unselectedItemColor: colorScheme.onSurfaceVariant,
                backgroundColor: Colors.transparent,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: provider.updateIndex,

                //splashFactory: NoSplash.splashFactory,
                items: [
                  BottomNavigationBarItem(
                    icon: _NavBarIcon(
                      icon: Icons.home_rounded,
                      selected: provider.currentIndex == 0,
                      colorScheme: colorScheme,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: _NavBarIcon(
                      icon: Icons.storefront_rounded,
                      selected: provider.currentIndex == 1,
                      colorScheme: colorScheme,
                    ),
                    label: "Store",
                  ),
                  BottomNavigationBarItem(
                    icon: _NavBarIcon(
                      icon: Icons.search_rounded,
                      selected: provider.currentIndex == 2,
                      colorScheme: colorScheme,
                    ),
                    label: "Search",
                  ),
                  BottomNavigationBarItem(
                    icon: _NavBarIcon(
                      icon: Icons.person_rounded,
                      selected: provider.currentIndex == 3,
                      colorScheme: colorScheme,
                    ),
                    label: "Profile",
                  ),
                  BottomNavigationBarItem(
                    icon: _NavBarIcon(
                      iconWidget: CartIconWithBadge(
                        iconColor: colorScheme.onSurfaceVariant,
                      ),
                      selected: provider.currentIndex == 4,
                      colorScheme: colorScheme,
                      activeIconWidget: CartIconWithBadge(
                        iconColor: colorScheme.primary,
                      ),
                    ),
                    label: "Cart",
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? activeIconWidget;
  final bool selected;
  final ColorScheme colorScheme;
  const _NavBarIcon({
    this.icon,
    this.iconWidget,
    this.activeIconWidget,
    required this.selected,
    required this.colorScheme,
  });
  @override
  Widget build(BuildContext context) {
    final Widget child =
        iconWidget != null
            ? (selected && activeIconWidget != null
                ? activeIconWidget!
                : iconWidget!)
            : Icon(
              icon,
              size: selected ? 24.sp : 20.sp,
              color:
                  selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            );
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: selected ? 8.w : 0,
        vertical: 4.h,
      ),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration:
          selected
              ? BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              )
              : null,
      child: child,
    );
  }
}
