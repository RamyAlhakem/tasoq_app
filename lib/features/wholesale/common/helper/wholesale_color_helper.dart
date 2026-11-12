import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';

class WholesaleColorHelper {
  const WholesaleColorHelper._();

  static ColorsModel? findByName(List<ColorsModel>? catalogue, String? name) {
    if (catalogue == null || name == null) return null;

    final String target = name.trim().toLowerCase();
    if (target.isEmpty) return null;

    for (final ColorsModel colour in catalogue) {
      if ((colour.name ?? '').trim().toLowerCase() == target) return colour;
    }
    return null;
  }

  static String? codeForName(List<ColorsModel>? catalogue, String? name) {
    final String? code = findByName(catalogue, name)?.code;
    if (code != null && code.trim().isNotEmpty) return code;

    final String value = name?.trim() ?? '';
    return value.startsWith('#') ? value : null;
  }

  static Color? swatchForName(List<ColorsModel>? catalogue, String? name) {
    return ColorHelper.hexCodeToColor(codeForName(catalogue, name));
  }

  static String? nameForCode(List<ColorsModel>? catalogue, String? code) {
    if (catalogue == null || code == null) return null;

    final String target = code.trim().toLowerCase();
    if (target.isEmpty) return null;

    for (final ColorsModel colour in catalogue) {
      if ((colour.code ?? '').trim().toLowerCase() == target) return colour.name;
    }
    return null;
  }
}
