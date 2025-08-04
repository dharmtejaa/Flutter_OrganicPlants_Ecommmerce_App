import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/cart/presentation/screens/cart_screen.dart';
import 'package:organicplants/features/search/logic/search_screen_provider.dart';
import 'package:organicplants/features/search/presentation/widgets/empty_message.dart';
import 'package:organicplants/features/search/presentation/widgets/search_field.dart';
import 'package:organicplants/features/search/presentation/widgets/section_header.dart';
import 'package:organicplants/shared/buttons/cart_icon_with_batdge.dart';
import 'package:organicplants/shared/buttons/wishlist_icon_with_badge.dart';
import 'package:organicplants/shared/widgets/no_result_found.dart';
import 'package:organicplants/shared/widgets/plant_card_grid.dart';
import 'package:organicplants/shared/widgets/plantcategory.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Form(child: SearchField()),
        actions: [
          WishlistIconWithBadge(),
          SizedBox(width: 10.w),
          CartIconWithBadge(
            iconColor: colorScheme.onSurface,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Consumer<SearchScreenProvider>(
        builder: (context, searchProvider, child) {
          final hasSearches = searchProvider.recentSearchHistory.isNotEmpty;
          final hasViewed = searchProvider.recentViewedPlants.isNotEmpty;

          return ListView(
            padding: AppSizes.paddingSymmetricMd,
            children: [
              if (searchProvider.noResultsFound)
                NoResultsFound(
                  imagePath:
                      "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
                  title: 'No Plants Found',
                  message:
                      "Try searching by name, type, or benefit — like 'Peace Lily', 'Indoor', or 'Pet Friendly'.",
                )
              else if (!hasSearches && !hasViewed)
                NoResultsFound(
                  imagePath:
                      "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
                  title: "Search a plant",
                  message:
                      "Try searching by name, type, or benefit — like 'Peace Lily', 'Indoor', or 'Pet Friendly'.",
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    SectionHeader(
                      title: "Recent Searches",
                      showClear: hasSearches,
                      onClear: () => searchProvider.clearSearchHistory(),
                    ),
                    SizedBox(height: 8.h),
                    hasSearches
                        ? _buildRecentSearches(context, searchProvider)
                        : EmptyMessage("No recent searches."),
                    SizedBox(height: 30.h),
                    SectionHeader(
                      title: "Recently Viewed Plants",
                      showClear: hasViewed,
                      onClear: () => searchProvider.clearRecentlyViewed(),
                    ),
                    SizedBox(height: 8.h),
                    hasViewed
                        ? _buildRecentViewed(searchProvider)
                        : EmptyMessage("No recently viewed plants."),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecentSearches(
    BuildContext context,
    SearchScreenProvider searchProvider,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: 8,
      children:
          searchProvider.recentSearchHistory
              .map(
                (query) => GestureDetector(
                  onTap: () {
                    searchProvider.updateSearchText(query);
                    searchProvider.search(query);
                    searchProvider.addRecentSearchHistory(query);

                    if (searchProvider.searchResult.isNotEmpty) {
                      searchProvider.setNoResultsFound(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PlantCategory(
                                plant: searchProvider.searchResult,
                                category: query,
                              ),
                        ),
                      );
                    } else {
                      searchProvider.setNoResultsFound(true);
                      searchProvider.removeSearchHistory(query);
                    }
                  },
                  child: Chip(
                    label: Text(query, style: textTheme.labelMedium),
                    deleteIcon: Icon(Icons.close, color: colorScheme.onSurface),
                    backgroundColor: colorScheme.surface,
                    shape: const StadiumBorder(),
                    shadowColor: colorScheme.shadow,
                    elevation: 2,
                    side: BorderSide(color: colorScheme.surface),
                    onDeleted: () => searchProvider.removeSearchHistory(query),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildRecentViewed(SearchScreenProvider searchProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        childAspectRatio: 0.735,
      ),
      itemCount: searchProvider.recentViewedPlants.length,
      itemBuilder:
          (context, index) => ProductCardGrid(
            plantId: searchProvider.recentViewedPlants[index],
          ),
    );
  }
}
