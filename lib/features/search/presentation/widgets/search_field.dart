import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/core/theme/app_shadows.dart';
// Import the BottomNavProvider to listen for tab changes
import 'package:organicplants/features/entry/logic/bottom_nav_provider.dart';
import 'package:organicplants/features/search/logic/hint_text_provider.dart';
import 'package:organicplants/features/search/logic/search_screen_provider.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';
import 'package:organicplants/features/product/presentation/screens/product_screen.dart';
import 'package:provider/provider.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final ValueNotifier<String> _searchTextNotifier = ValueNotifier('');

  // Reference to the BottomNavProvider
  BottomNavProvider? _bottomNavProvider;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChange);

    // Listen to the BottomNavProvider to know when the user switches tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bottomNavProvider = Provider.of<BottomNavProvider>(
        context,
        listen: false,
      );
      _bottomNavProvider?.addListener(_onBottomNavChange);
    });
  }

  /// This new method is called whenever the bottom navigation tab changes.
  void _onBottomNavChange() {
    // The search screen is at index 2. If we are no longer on the search screen,
    // remove focus from the search field, which will trigger the overlay to close.
    if (_bottomNavProvider?.currentIndex != 2) {
      _focusNode.unfocus();
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onSearchChanged() {
    _searchTextNotifier.value = _searchController.text;
    if (_searchController.text.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _removeOverlay();
      final overlay = Overlay.of(context);
      _overlayEntry = _buildOverlayEntry();
      overlay.insert(_overlayEntry!);
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChange);
    // Clean up the listener when the widget is disposed
    _bottomNavProvider?.removeListener(_onBottomNavChange);
    _removeOverlay();
    _searchController.dispose();
    // Properly dispose the FocusNode
    _focusNode.dispose();
    super.dispose();
  }

  OverlayEntry _buildOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final searchProvider = Provider.of<SearchScreenProvider>(
      context,
      listen: false,
    );
    final results = searchProvider.getSuggestions(_searchController.text);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: Material(
              color: Colors.transparent,
              child:
                  results.isEmpty
                      ? const SizedBox.shrink()
                      : Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                          boxShadow: AppShadows.searchFieldShadow(context),
                        ),
                        constraints: BoxConstraints(maxHeight: 350.h),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          padding: EdgeInsets.all(8.w),
                          itemBuilder: (context, idx) {
                            final plant = results[idx];
                            return InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLg,
                              ),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                _removeOverlay();

                                _searchController.text = plant.commonName ?? '';
                                searchProvider.addRecentSearchHistory(
                                  plant.commonName ?? '',
                                );
                                searchProvider.addRecentlyViewedPlant(
                                  plant.id ?? '',
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ProductScreen(
                                          plantId: plant.id ?? '',
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 16.w,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            plant.images?.firstOrNull?.url ??
                                            '',
                                        width: 40.w,
                                        height: 40.h,
                                        fit: BoxFit.cover,
                                        cacheManager:
                                            MyCustomCacheManager.instance,
                                        placeholder:
                                            (context, url) => Container(
                                              width: 40.w,
                                              height: 40.h,
                                              color:
                                                  colorScheme
                                                      .surfaceContainerHighest,
                                              child: Icon(
                                                Icons.image,
                                                color:
                                                    colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              width: 40.w,
                                              height: 40.h,
                                              color:
                                                  colorScheme
                                                      .surfaceContainerHighest,
                                              child: Icon(
                                                Icons.error,
                                                color:
                                                    colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plant.commonName ?? 'Unknown Plant',
                                            style: textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (plant.scientificName != null)
                                            Text(
                                              plant.scientificName!,
                                              style: textTheme.bodySmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme
                                                            .onSurfaceVariant,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hintProvider = Provider.of<HintTextProvider>(context, listen: false);

    return Consumer<SearchScreenProvider>(
      builder: (context, searchProvider, child) {
        final textTheme = Theme.of(context).textTheme;
        return SizedBox(
          height: 50.h,
          width: 0.9.sw,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Text Field
              TextFormField(
                controller: _searchController,
                focusNode: _focusNode,
                style: textTheme.bodyLarge,
                cursorColor: colorScheme.onSurface,
                onChanged: searchProvider.updateSearchText,
                onFieldSubmitted: (query) async {
                  final trimmedQuery = query.trim();
                  if (trimmedQuery.isEmpty) {
                    CustomSnackBar.showError(
                      context,
                      'Start typing to search for your favorite plants',
                    );
                    return;
                  }

                  searchProvider.search(trimmedQuery);
                  searchProvider.addRecentSearchHistory(trimmedQuery);

                  if (searchProvider.searchResult.isNotEmpty) {
                    searchProvider.setNoResultsFound(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => PlantCategory(
                              plant: searchProvider.searchResult,
                              category: trimmedQuery,
                            ),
                      ),
                    );
                  } else {
                    searchProvider.setNoResultsFound(true);
                    searchProvider.removeSearchHistory(trimmedQuery);
                  }
                },
                decoration: InputDecoration(
                  contentPadding: AppSizes.paddingAllSm,
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurface,
                    size: AppSizes.iconMd,
                  ),
                  suffixIcon:
                      _searchController.text.isEmpty
                          ? null
                          : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colorScheme.onSurface,
                            ),
                            iconSize: AppSizes.iconMd,
                            onPressed: () {
                              _searchController.clear();
                              searchProvider.updateSearchText('');
                            },
                          ),
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSizes.radiusXxl),
                    ),
                    borderSide: BorderSide(color: colorScheme.surface),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSizes.radiusXxl),
                    ),
                    borderSide: BorderSide(color: colorScheme.surface),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSizes.radiusXxl),
                    ),
                    borderSide: BorderSide(color: colorScheme.surface),
                  ),
                ),
              ),

              // AnimatedTextKit overlay — only when input is empty
              if (_searchController.text.isEmpty)
                Positioned(
                  left: 53.w,
                  top: 14.h,
                  child: IgnorePointer(
                    child: SizedBox(
                      height: 24.h,
                      width: 0.65.sw,
                      child: AnimatedTextKit(
                        animatedTexts:
                            (List<String>.from(hintProvider.hints)..shuffle())
                                .map(
                                  (hint) => TyperAnimatedText(
                                    hint,
                                    textStyle: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                )
                                .toList(),
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        pause: const Duration(seconds: 1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
