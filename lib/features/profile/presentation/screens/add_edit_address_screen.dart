import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/data/address_model.dart';
import 'package:organicplants/features/profile/logic/address_provider.dart';
import 'package:organicplants/shared/widgets/custom_textfield.dart';
import 'package:organicplants/shared/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class AddEditAddressScreen extends StatefulWidget {
  final List<AddressModel>? address;
  final int? index;
  const AddEditAddressScreen({super.key, this.address, this.index});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _houseNumberController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late ValueNotifier<String> _typeNotifier;
  bool _isEditing = false;
  DateTime? _editingAddressId;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.address != null && widget.index != null;

    if (_isEditing) {
      final editingAddress = widget.address![widget.index!];
      _editingAddressId = editingAddress.addressId;
      _nameController = TextEditingController(text: editingAddress.fullName);
      _phoneController = TextEditingController(
        text: editingAddress.phoneNumber,
      );
      _houseNumberController = TextEditingController(
        text: editingAddress.house,
      );
      _streetController = TextEditingController(text: editingAddress.street);
      _cityController = TextEditingController(text: editingAddress.city);
      _stateController = TextEditingController(text: editingAddress.state);
      _typeNotifier = ValueNotifier<String>(editingAddress.addressType);
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _houseNumberController = TextEditingController();
      _streetController = TextEditingController();
      _cityController = TextEditingController();
      _stateController = TextEditingController();
      _typeNotifier = ValueNotifier<String>('Home');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseNumberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _typeNotifier.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );

      if (_isEditing && _editingAddressId != null) {
        // Update existing address
        addressProvider.updateAddress(
          _editingAddressId!,
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _houseNumberController.text.trim(),
          _streetController.text.trim(),
          _cityController.text.trim(),
          _stateController.text.trim(),
          _typeNotifier.value,
        );
        CustomSnackBar.showSuccess(context, 'Address updated successfully!');
      } else {
        // Add new address
        addressProvider.addAddress(
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _houseNumberController.text.trim(),
          _streetController.text.trim(),
          _cityController.text.trim(),
          _stateController.text.trim(),
          _typeNotifier.value,
        );
        CustomSnackBar.showSuccess(context, 'Address saved successfully!');
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Address' : 'Add Address',
          style: textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: AppSizes.paddingAllSm,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom text field for name
                CustomTextField(
                  hintText: "Name",
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  fillColor: colorScheme.surface,
                  width: 350.w,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: "Number",
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  fillColor: colorScheme.surface,
                  maxLength: 10,
                  width: 350.w,
                ),
                SizedBox(height: 12.h),
                // Custom text field for address
                Row(
                  children: [
                    CustomTextField(
                      hintText: "House Number",
                      prefixIcon: Icons.home_outlined,
                      controller: _houseNumberController,
                      keyboardType: TextInputType.streetAddress,
                      fillColor: colorScheme.surface,
                      width: 150.w,
                    ),
                    SizedBox(width: 10.w),
                    CustomTextField(
                      hintText: "Street",
                      controller: _streetController,
                      keyboardType: TextInputType.streetAddress,
                      fillColor: colorScheme.surface,
                      width: 190.w,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: "City",
                  controller: _cityController,
                  keyboardType: TextInputType.streetAddress,
                  fillColor: colorScheme.surface,
                  width: 350.w,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: "State",
                  controller: _stateController,
                  keyboardType: TextInputType.streetAddress,
                  fillColor: colorScheme.surface,
                  width: 350.w,
                ),
                SizedBox(height: 12.h),
                // Custom text field for phone number
                ValueListenableBuilder<String>(
                  valueListenable: _typeNotifier,
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      value: value,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        fillColor: colorScheme.surface,
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['Home', 'Work', 'Other']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) _typeNotifier.value = value;
                      },
                    );
                  },
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          textStyle: textTheme.labelLarge,
                        ),
                        child: Text(_isEditing ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
