import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_filter_tabs.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_order/widgets/wholesale_order_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class WholesaleOrderScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const WholesaleOrderScreen({super.key, this.isBackButtonExist = true});

  @override
  State<WholesaleOrderScreen> createState() => _WholesaleOrderScreenState();
}

class _WholesaleOrderScreenState extends State<WholesaleOrderScreen> {
  late bool _isGuestMode;

  @override
  void initState() {
    super.initState();
    _isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('order', context), isBackButtonExist: widget.isBackButtonExist,
        boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 4)],
      ),
      body: _isGuestMode
          ? NotLoggedInWidget(
              message: getTranslated('to_view_the_order_history', context),
              fromPage: widget.isBackButtonExist ? RouterHelper.wholesaleOrderScreen : '${RouterHelper.dashboardScreen}?page=orders',
              onLoginSuccess: () {
                if (mounted) setState(() => _isGuestMode = false);
              },
            )
          : const Column(children: [
              WholesaleOrderFilterTabs(),

              Expanded(child: WholesaleOrderListView()),
            ]),
    );
  }
}
