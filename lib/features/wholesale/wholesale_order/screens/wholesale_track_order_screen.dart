import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/controllers/wholesale_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WholesaleTrackOrderScreen extends StatefulWidget {
  const WholesaleTrackOrderScreen({super.key});

  @override
  State<WholesaleTrackOrderScreen> createState() => _WholesaleTrackOrderScreenState();
}

class _WholesaleTrackOrderScreenState extends State<WholesaleTrackOrderScreen> {
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    final ConfigModel configModel = Provider.of<SplashController>(context, listen: false).configModel!;
    _countryCode = CountryCode.fromCountryCode(configModel.countryCode!).dialCode;
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _submit(WholesaleOrderController controller) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final int orderId = int.parse(_orderIdController.text.trim());
    final String phoneNumber = _countryCode! + _phoneNumberController.text.trim();

    final ApiResponseModel apiResponse = await controller.trackOrder(orderId: orderId, phoneNumber: phoneNumber);
    if (apiResponse.response?.statusCode == 200 && mounted) {
      RouterHelper.getWholesaleTrackingResultScreenRoute(action: RouteAction.push, orderId: orderId, phoneNumber: phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('TRACK_ORDER', context)),
      body: Consumer<WholesaleOrderController>(
        builder: (context, controller, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
            child: Form(
              key: _formKey,
              child: ListView(physics: const ClampingScrollPhysics(), children: [
                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CustomAssetImageWidget(Images.truckImage, height: widthSize * 0.17),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Text(
                      getTranslated('track_your_order_from_here', context)!,
                      style: textRegular.copyWith(color: Theme.of(context).hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeThirtyFive),

                CustomTextFieldWidget(
                  controller: _orderIdController,
                  prefixIcon: Images.orderIdIcon,
                  prefixColor: Theme.of(context).primaryColor,
                  isAmount: true,
                  inputType: TextInputType.number,
                  hintText: getTranslated('enter_order_id', context),
                  labelText: getTranslated('order_id', context),
                  labelTextStyle: textRegular.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  fontSize: 14,
                  required: true,
                  showLabelText: false,
                  validator: (value) {
                    final String? emptyError = ValidateCheck.validateEmptyText(value, 'order_id_is_required');
                    if (emptyError != null) return emptyError;
                    if (int.tryParse(value!.trim()) == null) return getTranslated('order_id_is_required', context);
                    return null;
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                CustomTextFieldWidget(
                  countryDialCode: _countryCode,
                  showCodePicker: true,
                  inputType: TextInputType.phone,
                  prefixColor: Theme.of(context).primaryColor,
                  controller: _phoneNumberController,
                  inputAction: TextInputAction.done,
                  hintText: getTranslated('enter_phone_number', context),
                  required: true,
                  labelText: getTranslated('phone_number', context),
                  labelTextStyle: textRegular.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  fontSize: 14,
                  showLabelText: false,
                  validator: (value) => ValidateCheck.validateEmptyText(value, 'phone_number_is_required'),
                  onCountryChanged: (CountryCode value) => _countryCode = value.dialCode,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

                CustomButton(
                  isLoading: controller.isTracking,
                  buttonText: getTranslated('track_order', context),
                  fontSize: 14,
                  onTap: () => _submit(controller),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
