import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';

class AddressListModel {
  final List<AddressModel> addresses;
  final int? totalSize;
  final int? offset;
  final int? lastPage;

  AddressListModel({this.addresses = const [], this.totalSize, this.offset, this.lastPage});

  factory AddressListModel.fromResponse(dynamic data) {
    if (data is List) {
      final List<AddressModel> addresses = _parse(data);
      return AddressListModel(addresses: addresses, totalSize: addresses.length, offset: 1, lastPage: 1);
    }

    if (data is Map) {
      final ApiListEnvelope envelope = ApiListEnvelope.fromJson(Map<String, dynamic>.from(data));
      final List<AddressModel> addresses = _parse(envelope.data);
      return AddressListModel(
        addresses: addresses,
        totalSize: envelope.totalSize ?? addresses.length,
        offset: envelope.offset ?? 1,
        lastPage: envelope.lastPage,
      );
    }

    return AddressListModel();
  }

  bool hasMoreAfter(int loadedCount) => lastPage != null ? (offset ?? 1) < lastPage! : loadedCount < (totalSize ?? loadedCount);

  static List<AddressModel> _parse(List? addresses) => addresses?.map<AddressModel>((address) =>
      AddressModel.fromJson(Map<String, dynamic>.from(address))).toList() ?? [];
}
