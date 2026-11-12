import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class AuctionBrandDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final ValueChanged<String?> onChanged;

  const AuctionBrandDropdownField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.value,
  });

  Future<void> _openBrandPicker(BuildContext context) async {
    final brandController = Provider.of<BrandController>(context, listen: false);
    if (brandController.auctionBrandList.isEmpty) {
      await brandController.getAuctionBrandList(offset: 1);
    }

    if (!context.mounted) return;

    final String? selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      builder: (_) => _BrandPickerSheet(selectedValue: value),
    );

    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openBrandPicker(context),
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall + Dimensions.paddingSizeExtraExtraSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: .25), width: .75),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hintText,
                style: titilliumRegular.copyWith(
                  color: value == null ? Theme.of(context).hintColor : Theme.of(context).textTheme.bodyLarge?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined, color: Theme.of(context).hintColor),
          ],
        ),
      ),
    );
  }
}

class _BrandPickerSheet extends StatelessWidget {
  final String? selectedValue;

  const _BrandPickerSheet({this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, sheetScrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              child: Text(
                getTranslated('brand', context) ?? '',
                style: titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Divider(height: 1, color: Theme.of(context).hintColor.withValues(alpha: .15)),

            Expanded(
              child: Consumer<BrandController>(
                builder: (context, brandController, _) {
                  final brands = brandController.auctionBrandList;
                  final model = brandController.auctionBrandModel;

                  if (brands.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PaginatedListView(
                    scrollController: sheetScrollController,
                    totalSize: model?.totalSize,
                    offset: model?.offset,
                    limit: model?.limit ?? 24,
                    onPaginate: (offset) => brandController.getAuctionBrandList(offset: offset ?? 1),
                    itemView: Expanded(
                      child: ListView.builder(
                        controller: sheetScrollController,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          final bool isSelected = selectedValue == brand.name;

                          return ListTile(
                            title: Text(brand.name ?? '', style: titilliumRegular),
                            trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                            onTap: () => Navigator.pop(context, brand.name),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
