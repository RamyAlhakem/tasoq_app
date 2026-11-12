import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/models/contact_us_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/services/contact_us_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class ContactUsController extends ChangeNotifier{
  ContactUsServiceInterface contactUsServiceInterface;
  ContactUsController({required this.contactUsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> contactUs(ContactUsBody contactUsBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponseModel apiResponse = await contactUsServiceInterface.add(contactUsBody);

    final int? statusCode = apiResponse.response?.statusCode;
    final bool isSuccess = statusCode != null && (statusCode == 200 || statusCode == 201);

    _isLoading = false;
    if (isSuccess) {
      showCustomSnackBarWidget(getTranslated('message_sent_successfully', Get.context!), Get.context!, snackBarType: SnackBarType.success);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();

    return isSuccess;
  }

}