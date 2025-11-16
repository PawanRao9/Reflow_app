import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeliveryInformationCard extends StatefulWidget {
  final List<Map<String, dynamic>> savedAddresses;
  final Map<String, dynamic>? selectedAddress;
  final Function(Map<String, dynamic>) onAddressSelected;
  final VoidCallback onAddNewAddress;

  const DeliveryInformationCard({
    super.key,
    required this.savedAddresses,
    this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
  });

  @override
  State<DeliveryInformationCard> createState() =>
      _DeliveryInformationCardState();
}

class _DeliveryInformationCardState extends State<DeliveryInformationCard> {
  bool _showAddressForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Delivery Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (!_showAddressForm) ...[
              ...widget.savedAddresses
                  .map((address) => _buildAddressOption(context, address)),
              SizedBox(height: 2.h),
              OutlinedButton.icon(
                onPressed: () => setState(() => _showAddressForm = true),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                label: Text('Add New Address'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                ),
              ),
            ] else
              _buildAddressForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressOption(
      BuildContext context, Map<String, dynamic> address) {
    final theme = Theme.of(context);
    final isSelected = widget.selectedAddress?["id"] == address["id"];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => widget.onAddressSelected(address),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Radio<int>(
                value: address["id"] as int,
                groupValue: widget.selectedAddress?["id"] as int?,
                onChanged: (value) => widget.onAddressSelected(address),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address["name"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            address["type"] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      address["phone"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${address["address"]}, ${address["city"]} - ${address["pincode"]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressForm(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Name is required' : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: CustomIconWidget(
                      iconName: 'phone',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Phone is required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Address',
              prefixIcon: CustomIconWidget(
                iconName: 'location_on',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              suffixIcon: IconButton(
                onPressed: _detectLocation,
                icon: CustomIconWidget(
                  iconName: 'my_location',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'Detect Location',
              ),
            ),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty == true ? 'Address is required' : null,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    prefixIcon: CustomIconWidget(
                      iconName: 'location_city',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'City is required' : null,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _pincodeController,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    prefixIcon: CustomIconWidget(
                      iconName: 'pin_drop',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Pincode is required' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _showAddressForm = false),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text('Save Address'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _detectLocation() {
    // GPS auto-detect functionality
    _addressController.text = "123 Main Street, Near City Hospital";
    _cityController.text = "Mumbai";
    _pincodeController.text = "400001";
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() == true) {
      final newAddress = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "pincode": _pincodeController.text,
        "type": "Other",
      };

      widget.onAddressSelected(newAddress);
      setState(() => _showAddressForm = false);

      // Clear form
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _cityController.clear();
      _pincodeController.clear();
    }
  }
}
