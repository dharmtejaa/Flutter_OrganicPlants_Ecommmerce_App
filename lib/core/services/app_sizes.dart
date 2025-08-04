// lib/constants/app_sizes.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  // ============================================================================
  // FONT SIZES
  // ============================================================================
  static double fontUxs = 10.sp;
  static double fontXs = 12.sp;
  static double fontSm = 14.sp;
  static double fontMd = 16.sp;
  static double fontLg = 18.sp;
  static double fontXl = 20.sp;
  static double fontXxl = 24.sp;
  static double fontDisplay = 32.sp;

  // ============================================================================
  // ICON SIZES
  // ============================================================================
  static double iconsUxs = 14.sp;
  static double iconXs = 16.sp;
  static double iconSm = 20.sp;
  static double iconMd = 24.sp;
  static double iconLg = 32.sp;
  static double iconXl = 48.sp;

  // ============================================================================
  // PADDING SIZES
  // ============================================================================
  // Horizontal Padding
  static double paddingXs = 8.w;
  static double paddingSm = 12.w;
  static double paddingMd = 16.w;
  static double paddingLg = 20.w;
  static double paddingXl = 24.w;
  static double paddingXxl = 32.w;

  // Vertical Padding
  static double vPaddingXs = 8.h;
  static double vPaddingSm = 12.h;
  static double vPaddingMd = 16.h;
  static double vPaddingLg = 20.h;
  static double vPaddingXl = 24.h;
  static double vPaddingXxl = 32.h;

  // ============================================================================
  // MARGIN SIZES
  // ============================================================================
  // Horizontal Margin
  static double marginXs = 8.w;
  static double marginSm = 12.w;
  static double marginMd = 16.w;
  static double marginLg = 20.w;
  static double marginXl = 24.w;
  static double marginXxl = 32.w;

  // Vertical Margin
  static double vMarginXs = 8.h;
  static double vMarginSm = 12.h;
  static double vMarginMd = 16.h;
  static double vMarginLg = 20.h;
  static double vMarginXl = 24.h;
  static double vMarginXxl = 32.h;

  // ============================================================================
  // BORDER RADIUS SIZES
  // ============================================================================
  static double radiusXs = 4.r;
  static double radiusSm = 8.r;
  static double radiusMd = 12.r;
  static double radiusLg = 16.r;
  static double radiusXl = 20.r;
  static double radiusXxl = 24.r;
  static double radiusXxxl = 28.r;
  static double radiusCircular = 50.r;

  // ============================================================================
  // SPACING SIZES
  // ============================================================================
  static double spaceXs = 4.w;
  static double spaceSm = 8.w;
  static double spaceMd = 16.w;
  static double spaceLg = 24.w;
  static double spaceXl = 32.w;
  static double spaceXxl = 48.w;

  // Vertical Spacing
  static double spaceHeightXs = 4.h;
  static double spaceHeightSm = 8.h;
  static double spaceHeightMd = 16.h;
  static double spaceHeightLg = 24.h;
  static double spaceHeightXl = 32.h;
  static double spaceHeightXxl = 48.h;

  // ============================================================================
  // PADDING - EDGEINSETS CONSTANTS
  // ============================================================================
  static EdgeInsets paddingAllXs = EdgeInsets.all(paddingXs);
  static EdgeInsets paddingAllSm = EdgeInsets.all(paddingSm);
  static EdgeInsets paddingAllMd = EdgeInsets.all(paddingMd);
  static EdgeInsets paddingAllLg = EdgeInsets.all(paddingLg);
  static EdgeInsets paddingAllXl = EdgeInsets.all(paddingXl);
  static EdgeInsets paddingAllXxl = EdgeInsets.all(paddingXxl);

  static EdgeInsets paddingSymmetricXs = EdgeInsets.symmetric(
    horizontal: paddingXs,
    vertical: vPaddingXs,
  );
  static EdgeInsets paddingSymmetricSm = EdgeInsets.symmetric(
    horizontal: paddingSm,
    vertical: vPaddingSm,
  );
  static EdgeInsets paddingSymmetricMd = EdgeInsets.symmetric(
    horizontal: paddingMd,
    vertical: vPaddingMd,
  );
  static EdgeInsets paddingSymmetricLg = EdgeInsets.symmetric(
    horizontal: paddingLg,
    vertical: vPaddingLg,
  );
  static EdgeInsets paddingSymmetricXl = EdgeInsets.symmetric(
    horizontal: paddingXl,
    vertical: vPaddingXl,
  );
  static EdgeInsets paddingSymmetricXxl = EdgeInsets.symmetric(
    horizontal: paddingXxl,
    vertical: vPaddingXxl,
  );

  // ============================================================================
  // MARGIN - EDGEINSETS CONSTANTS
  // ============================================================================
  static EdgeInsets marginAllXs = EdgeInsets.all(marginXs);
  static EdgeInsets marginAllSm = EdgeInsets.all(marginSm);
  static EdgeInsets marginAllMd = EdgeInsets.all(marginMd);
  static EdgeInsets marginAllLg = EdgeInsets.all(marginLg);
  static EdgeInsets marginAllXl = EdgeInsets.all(marginXl);
  static EdgeInsets marginAllXxl = EdgeInsets.all(marginXxl);

  static EdgeInsets marginSymmetricXs = EdgeInsets.symmetric(
    horizontal: marginXs,
    vertical: vMarginXs,
  );
  static EdgeInsets marginSymmetricSm = EdgeInsets.symmetric(
    horizontal: marginSm,
    vertical: vMarginSm,
  );
  static EdgeInsets marginSymmetricMd = EdgeInsets.symmetric(
    horizontal: marginMd,
    vertical: vMarginMd,
  );
  static EdgeInsets marginSymmetricLg = EdgeInsets.symmetric(
    horizontal: marginLg,
    vertical: vMarginLg,
  );
  static EdgeInsets marginSymmetricXl = EdgeInsets.symmetric(
    horizontal: marginXl,
    vertical: vMarginXl,
  );
  static EdgeInsets marginSymmetricXxl = EdgeInsets.symmetric(
    horizontal: marginXxl,
    vertical: vMarginXxl,
  );

  // ============================================================================
  // CARD DIMENSIONS
  // ============================================================================
  static double cardWidth = 160.w;
  static double cardHeight = 240.h;
  static double cardImageHeight = 120.h;

  // ============================================================================
  // BUTTON DIMENSIONS
  // ============================================================================
  static double buttonHeight = 56.h;
  static double buttonRadius = 16.r;
  static double iconButtonSize = 48.w;

  // ============================================================================
  // APP BAR DIMENSIONS
  // ============================================================================
  static double appBarHeight = 64.h;
  static double appBarElevation = 0;

  // ============================================================================
  // BOTTOM NAVIGATION DIMENSIONS
  // ============================================================================
  static double bottomNavHeight = 65.h;
  static double bottomNavRadius = 16.r;

  // ============================================================================
  // SEARCH BAR DIMENSIONS
  // ============================================================================
  static double searchBarHeight = 48.h;
  static double searchBarRadius = 12.r;

  // ============================================================================
  // BANNER DIMENSIONS
  // ============================================================================
  static double bannerHeight = 180.h;
  static double bannerRadius = 16.r;

  // ============================================================================
  // CATEGORY CARD DIMENSIONS
  // ============================================================================
  static double categoryCardSize = 80.w;
  static double categoryCardRadius = 12.r;

  // ============================================================================
  // PROFILE SPECIFIC DIMENSIONS
  // ============================================================================
  static double profileAvatarSize = 80.w;
  static double profileHeaderPadding = 20.w;
  static double profileStatIconSize = 48.w;
  static double profileStatIconPadding = 12.w;
  static double profileMenuIconSize = 48.w;
  static double profileMenuIconPadding = 12.w;

  // ============================================================================
  // AUTH SPECIFIC DIMENSIONS
  // ============================================================================
  static double authContainerRadius = 20.r;
  static double authFieldHeight = 56.h;
  static double authFieldRadius = 16.r;
  static double authButtonHeight = 56.h;
  static double authButtonRadius = 16.r;

  // ============================================================================
  // PRODUCT SPECIFIC DIMENSIONS
  // ============================================================================
  static double productImageHeight = 120.h;
  static double productCardRadius = 16.r;
  static double productPriceSize = 18.sp;
  static double productTitleSize = 16.sp;
  static double productDescriptionSize = 14.sp;

  // ============================================================================
  // CART SPECIFIC DIMENSIONS
  // ============================================================================
  static double cartItemHeight = 120.h;
  static double cartItemRadius = 12.r;
  static double cartQuantityButtonSize = 32.w;
  static double cartBottomSheetRadius = 20.r;

  // ============================================================================
  // WISHLIST SPECIFIC DIMENSIONS
  // ============================================================================
  static double wishlistItemHeight = 160.h;
  static double wishlistItemRadius = 16.r;
  static double wishlistIconSize = 24.w;

  // ============================================================================
  // ONBOARDING SPECIFIC DIMENSIONS
  // ============================================================================
  static double onboardingImageHeight = 240.h;
  static double onboardingIamgeWidth = 1.sw;
  static double onboardingTitleSize = 28.sp;
  static double onboardingSubtitleSize = 16.sp;
  static double onboardingDotHeight = 8.h;
  static double onboardingDotwidth = 8.w;
  static double onboardingDotSpacing = 8.w;

  // ============================================================================
  // SPLASH SPECIFIC DIMENSIONS
  // ============================================================================
  static double splashLogoHeight = 300.h;
  static double splashLogoWidth = 300.w;
  static double splashAnimationSize = 200.w;
  static double splashTitleSize = 32.sp;

  // ============================================================================
  // SEARCH SPECIFIC DIMENSIONS
  // ============================================================================
  static double searchFieldHeight = 48.h;
  static double searchFieldRadius = 24.r;
  static double searchResultItemHeight = 80.h;
  static double searchResultItemRadius = 12.r;

  // ============================================================================
  // HOME SPECIFIC DIMENSIONS
  // ============================================================================
  static double homeBannerHeight = 170.h;
  static double homeCategorySize = 80.w;
  static double homeProductCardWidth = 160.w;
  static double homeProductCardHeight = 240.h;
  static double homeSectionSpacing = 24.h;

  // ============================================================================
  // COMMON UI DIMENSIONS
  // ============================================================================
  static double dividerHeight = 1.h;
  static double shadowBlurRadius = 8.r;
  static double shadowOffset = 2.r;
  static double elevation = 3.r;
  static double borderWidth = 1.w;
  static double borderWidthThick = 2.w;
}
