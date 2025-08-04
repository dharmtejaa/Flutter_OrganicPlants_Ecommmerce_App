import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/core/services/my_custom_cache_manager.dart';
import 'package:organicplants/features/product/logic/carousel_provider.dart';
import 'package:organicplants/models/all_plants_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImageGallery extends StatelessWidget {
  final String plantId;

  const ProductImageGallery({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final AllPlantsModel? plant = AllPlantsGlobalData.getById(plantId);
    final carouselProvider = Provider.of<CarouselProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    // Remove local CarouselController, use provider's controller

    return Column(
      children: [
        // Image Gallery
        CarouselSlider.builder(
          carouselController: carouselProvider.carouselController,
          itemCount: plant!.images?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = plant.images?[index].url ?? '';
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: InteractiveViewer(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            cacheManager: MyCustomCacheManager.instance,
                          ),
                        ),
                      ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 300.h,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            );
          },
          options: CarouselOptions(
            height: 300.h,
            viewportFraction: 1,
            initialPage: carouselProvider.activeIndex,
            onPageChanged: (index, reason) {
              carouselProvider.setIndex(index);
            },
          ),
        ),
        SizedBox(height: 10.h),
        // Thumbnails
        if ((plant.images?.length ?? 0) > 1)
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: SizedBox(
              height: 54.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: plant.images!.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final thumbUrl = plant.images![index].url ?? '';
                  return GestureDetector(
                    onTap: () {
                      carouselProvider.animateToPage(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              carouselProvider.activeIndex == index
                                  ? colorScheme.primary
                                  : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        child: CachedNetworkImage(
                          imageUrl: thumbUrl,
                          height: 54.h,
                          width: 54.w,
                          fit: BoxFit.cover,
                          cacheManager: MyCustomCacheManager.instance,
                          errorWidget:
                              (
                                context,
                                error,
                                stackTrace,
                              ) => CachedNetworkImage(
                                imageUrl:
                                    "https://res.cloudinary.com/daqvdhmw8/image/upload/v1753080574/No_Plant_Found_dmdjsy.png",
                                fit: BoxFit.cover,
                                errorWidget:
                                    (context, url, error) =>
                                        Icon(Icons.image_rounded),
                                cacheManager: MyCustomCacheManager.instance,
                                placeholder:
                                    (context, url) =>
                                        CircularProgressIndicator(),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        SizedBox(height: 12.h),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: carouselProvider.activeIndex,
            count: plant.images?.length ?? 0,
            effect: ExpandingDotsEffect(
              activeDotColor: colorScheme.primary,
              dotHeight: 8.h,
              dotWidth: 8.w,
            ),
          ),
        ),
      ],
    );
  }
}
