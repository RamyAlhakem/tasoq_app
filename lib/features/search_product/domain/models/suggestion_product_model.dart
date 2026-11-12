import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class SuggestionModel {
  List<Products>? products;

  SuggestionModel({this.products});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['products']);
    if (envelope.data != null) {
      products = <Products>[
        for (final Map row in envelope.data!.whereType<Map>())
          Products.fromJson(Map<String, dynamic>.from(row)),
      ];
    }
  }

}

class Products {
  int? id;
  String? name;
  String? slug;

  Products({this.id, this.name, this.slug});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
   slug = json['slug'];
  }

}
