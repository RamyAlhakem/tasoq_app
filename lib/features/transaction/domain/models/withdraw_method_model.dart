import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';

class WithdrawMethodList {
  final List<WithdrawMethodModel> methods;

  const WithdrawMethodList({this.methods = const []});

  factory WithdrawMethodList.fromJson(dynamic json) {
    final List raw;
    if (json is List) {
      raw = json;
    } else if (json is Map) {
      raw = ApiListEnvelope.fromJson(Map<String, dynamic>.from(json),
              legacyKeys: const ['withdraw_methods', 'methods'])
          .data ?? const [];
    } else {
      raw = const [];
    }

    return WithdrawMethodList(
      methods: raw
          .whereType<Map>()
          .map((e) => WithdrawMethodModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class WithdrawMethodModel {
  final int id;
  final String methodName;
  final List<MethodField> methodFields;
  final bool isDefault;
  final bool isActive;

  WithdrawMethodModel({
    required this.id,
    required this.methodName,
    required this.methodFields,
    required this.isDefault,
    required this.isActive,
  });

  factory WithdrawMethodModel.fromJson(Map<String, dynamic> json) {
    return WithdrawMethodModel(
      id: asInt(json['id']) ?? 0,
      methodName: json['method_name']?.toString() ?? '',
      methodFields: (json['method_fields'] is List ? json['method_fields'] as List : const [])
          .whereType<Map>()
          .map((e) => MethodField.fromJson(Map<String, dynamic>.from(e)))
          .toList(),

      isDefault: asBool(json['is_default']),

      isActive: json.containsKey('is_active') ? asBool(json['is_active']) : true,
    );
  }
}

class MethodField {
  final String inputType;
  final String inputName;
  final String placeholder;
  final bool isRequired;

  MethodField({
    required this.inputType,
    required this.inputName,
    required this.placeholder,
    required this.isRequired,
  });

  factory MethodField.fromJson(Map<String, dynamic> json) {
    return MethodField(
      inputType: json['input_type']?.toString() ?? '',
      inputName: json['input_name']?.toString() ?? '',
      placeholder: json['placeholder']?.toString() ?? '',
      isRequired: asBool(json['is_required']),
    );
  }
}

bool asBool(dynamic value) =>
    value == true || value == 1 || value == '1' || value == 'true';

int? asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse('$value');
}
