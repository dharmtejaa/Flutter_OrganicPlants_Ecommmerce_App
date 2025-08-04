// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/data/address_model.dart';
import 'package:organicplants/features/profile/logic/address_provider.dart';
import 'package:organicplants/features/profile/presentation/screens/add_edit_address_screen.dart';
import 'package:provider/provider.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Addresses', style: textTheme.headlineSmall),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          final addressData = addressProvider.address;
          return Padding(
            padding: EdgeInsets.all(AppSizes.paddingMd),
            child:
                addressData.isEmpty
                    ? Center(
                      child: Text(
                        'No addresses found.\nAdd a new address!',
                        style: textTheme.bodyLarge,
                      ),
                    )
                    : ListView.separated(
                      itemCount: addressData.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final AddressModel addr = addressData[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusLg,
                            ),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.paddingMd),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  addr.addressType == 'Home'
                                      ? Icons.home
                                      : Icons.work,
                                  color: colorScheme.primary,
                                  size: 28.w,
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        addr.fullName,
                                        style: textTheme.titleLarge,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${addr.house},  ${addr.street}, ${addr.city}, ${addr.state}, ',
                                        style: textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        addr.phoneNumber,
                                        style: textTheme.bodyMedium,
                                      ),
                                      SizedBox(height: 6.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          addr.addressType,
                                          style: textTheme.labelMedium
                                              ?.copyWith(
                                                color: colorScheme.primary,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: colorScheme.primary,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    AddEditAddressScreen(
                                                      address: addressData,
                                                      index: index,
                                                    ),
                                          ),
                                        );
                                      },
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: colorScheme.error,
                                      ),
                                      onPressed: () {
                                        _showDeleteConfirmation(
                                          context,
                                          addr.addressId,
                                        );
                                      },
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditAddressScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Add Address'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DateTime addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Provider.of<AddressProvider>(
                  context,
                  listen: false,
                ).removeFromAddress(addressId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
