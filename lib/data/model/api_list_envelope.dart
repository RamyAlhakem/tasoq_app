import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class ApiListEnvelope {
  late final Map content;

  List? data;
  int? totalSize;
  int? limit;
  int? offset;
  int? lastPage;

  late final Map<String, dynamic> _json;

  ApiListEnvelope.fromJson(Map<String, dynamic> json, {List<String> legacyKeys = const []}) {
    _json = json;
    content = ApiEnvelope.content(json);
    final Map? pagination = content['pagination'] is Map ? content['pagination'] : null;

    data = _asList(content['data']);
    for (final String key in legacyKeys) {
      data ??= _asList(read(key));
    }

    totalSize = _asInt(pagination?['total'] ?? read('total_size'));
    limit = _asInt(pagination?['per_page'] ?? read('limit'));
    offset = _asInt(pagination?['current_page'] ?? read('offset'));
    lastPage = _asInt(pagination?['last_page']);
  }

  dynamic read(String key) => content[key] ?? _json[key];

  static List? _asList(dynamic value) => value is List ? value : null;

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value');
  }
}
