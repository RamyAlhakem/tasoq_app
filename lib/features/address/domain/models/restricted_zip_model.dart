import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class RestrictedZipList {
  bool isRestricted;
  int? totalSize;
  List<RestrictedZipModel> zipCodes;

  RestrictedZipList({this.isRestricted = false, this.totalSize, List<RestrictedZipModel>? zipCodes})
      : zipCodes = zipCodes ?? <RestrictedZipModel>[];

  RestrictedZipList.fromJson(Map<String, dynamic> json)
      : isRestricted = false,
        zipCodes = <RestrictedZipModel>[] {
    final ApiListEnvelope envelope = ApiListEnvelope.fromJson(json, legacyKeys: const ['zip_codes']);
    final dynamic restricted = envelope.read('is_restricted');
    isRestricted = restricted == true || restricted == 1 || restricted == '1';
    totalSize = envelope.totalSize;
    for (final dynamic zip in envelope.data ?? const []) {
      final RestrictedZipModel model = RestrictedZipModel.fromJson(zip);
      if ((model.zipcode ?? '').isNotEmpty) {
        zipCodes.add(model);
      }
    }
  }
}

class RestrictedZipModel {
  int? id;
  String? zipcode;
  RestrictedZipModel({this.id, this.zipcode});

  RestrictedZipModel.fromJson(dynamic json) {
    if (json is Map) {
      id = json['id'];
      zipcode = (json['zip_code'] ?? json['zipcode'])?.toString();
    } else {
      zipcode = json?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['zip_code'] = zipcode;
    return data;
  }
}
