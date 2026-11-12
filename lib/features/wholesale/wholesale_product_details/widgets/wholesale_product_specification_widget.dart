import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WholesaleProductSpecificationWidget extends StatelessWidget {
  final String specification;

  const WholesaleProductSpecificationWidget({super.key, required this.specification});

  @override
  Widget build(BuildContext context) {
    final bool isLong = specification.length > 400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Stack(children: [
        Container(
          width: double.infinity,
          height: isLong ? 150 : null,
          padding: const EdgeInsets.only(bottom: 0),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: HtmlWidget(
              specification,
              onTapUrl: (String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
              textStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall),
            ),
          ),
        ),

        if (isLong) Positioned.fill(child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: InkWell(
            onTap: () => RouterHelper.getSpecificationRoute(specification),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              color: Theme.of(context).cardColor,
              child: Text(getTranslated('see_more...', context) ?? '', style: titleRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Provider.of<ThemeController>(context, listen: false).darkTheme ? Colors.white : Theme.of(context).primaryColor,
              )),
            ),
          ),
        )),
      ]),
    );
  }
}
