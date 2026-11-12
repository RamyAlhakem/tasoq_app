import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class RestrictedCountryList {
  bool isRestricted;
  int? totalSize;
  List<RestrictedCountryModel> countries;

  RestrictedCountryList({this.isRestricted = false, this.totalSize, List<RestrictedCountryModel>? countries})
      : countries = countries ?? <RestrictedCountryModel>[];

  RestrictedCountryList.fromJson(Map<String, dynamic> json)
      : isRestricted = false,
        countries = <RestrictedCountryModel>[] {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: const ['countries']);
    final dynamic restricted = envelope.read('is_restricted');
    isRestricted = restricted == true || restricted == 1 || restricted == '1';
    totalSize = envelope.totalSize;
    for (final dynamic country in envelope.data ?? const []) {
      countries.add(RestrictedCountryModel.fromJson(country));
    }
  }

  List<String> get names => countries
      .map((RestrictedCountryModel country) => country.name)
      .whereType<String>()
      .where((String name) => name.isNotEmpty)
      .toList();
}

class RestrictedCountryModel {
  String? code;
  String? name;

  RestrictedCountryModel({this.code, this.name});

  RestrictedCountryModel.fromJson(dynamic json) {
    if (json is Map) {
      code = json['code']?.toString();
      name = json['name']?.toString();
    } else {
      name = json?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}
