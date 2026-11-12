class TaxVatSetupModel {
  bool isProductWise;
  bool isCategoryWise;
  bool isIncluded;

  TaxVatSetupModel({
    this.isProductWise = false,
    this.isCategoryWise = false,
    this.isIncluded = false,
  });

  TaxVatSetupModel.fromJson(Map<String, dynamic> json)
      : isProductWise = json['is_product_wise'] == true || json['is_product_wise'] == 1,
        isCategoryWise = json['is_category_wise'] == true || json['is_category_wise'] == 1,
        isIncluded = json['is_included'] == true || json['is_included'] == 1;
}
