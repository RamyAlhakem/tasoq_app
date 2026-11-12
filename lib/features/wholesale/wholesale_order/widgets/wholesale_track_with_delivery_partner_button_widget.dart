import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class WholesaleTrackWithDeliveryPartnerButtonWidget extends StatelessWidget {
  final String trackingUrl;
  const WholesaleTrackWithDeliveryPartnerButtonWidget({super.key, required this.trackingUrl});

  Future<void> _launchTrackingUrl() async {
    final Uri url = Uri.parse(trackingUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _launchTrackingUrl,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
        ),
        icon: Icon(Icons.local_shipping_outlined, size: 18, color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor),
        label: Text(getTranslated('track_with_delivery_partner', context) ?? '',
          style: titilliumBold.copyWith(color: isDark ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).primaryColor)),
      ),
    );
  }
}
