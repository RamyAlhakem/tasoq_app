import 'package:flutter_sixvalley_ecommerce/data/model/api_envelope.dart';

class CommissionPayResponseModel {
  final String? message;
  final String? redirectLink;

  CommissionPayResponseModel({this.message, this.redirectLink});

  factory CommissionPayResponseModel.fromJson(Map<String, dynamic> json) {
    final Map content = ApiEnvelope.content(json);
    final dynamic rawRedirect = content['redirect_link'];
    return CommissionPayResponseModel(
      message: ApiEnvelope.message(json),

      redirectLink: rawRedirect is String && rawRedirect.isNotEmpty ? rawRedirect : null,
    );
  }
}
