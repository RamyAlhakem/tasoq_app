import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/di_container.dart' as di;
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/domain/models/wholesale_coupon_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wholesale/wholesale_coupon/widgets/wholesale_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await di.init();
  });

  final coupon = WholesaleCoupon.fromJson({
    'id': 17, 'title': 'TestSHa', 'code': '2WGFBYBIHU', 'coupon_type': 'discount_on_purchase',
    'discount': 2, 'discount_type': 'percentage', 'min_purchase': 100, 'max_discount': 50,
    'start_date': '2026-01-01', 'expire_date': '2027-01-01', 'seller_id': 15,
  });

  Widget host(Widget child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => di.sl<ThemeController>()),
          ChangeNotifierProvider(create: (_) => di.sl<SplashController>()),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      );

  testWidgets('OLD layout: fixed 110px strip overflows', (tester) async {
    await tester.pumpWidget(host(
      SizedBox(height: 110, child: ListView(scrollDirection: Axis.horizontal, children: [
        SizedBox(width: 320, child: WholesaleCouponItemWidget(coupon: coupon)),
      ])),
    ));
    await tester.pump();

    final bool overflowed = tester.takeException().toString().contains('overflowed');
    print('old fixed-height layout overflowed: $overflowed');
    expect(overflowed, isTrue, reason: 'reproduces the reported RenderFlex overflow');
  });

  testWidgets('NEW layout: card sizes itself in a column — no overflow', (tester) async {
    await tester.pumpWidget(host(
      SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        WholesaleCouponItemWidget(coupon: coupon),
      ])),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull, reason: 'no overflow with intrinsic height');
    final Size size = tester.getSize(find.byType(WholesaleCouponItemWidget));
    print('intrinsic coupon card height: ${size.height}');
  });

  testWidgets('NEW layout survives a large text scale', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: SingleChildScrollView(child: Column(children: [WholesaleCouponItemWidget(coupon: coupon)])),
      ),
    ));
    await tester.pump();

    expect(tester.takeException(), isNull, reason: 'a fixed height would break here');
    print('large-text height: ${tester.getSize(find.byType(WholesaleCouponItemWidget)).height}');
  });
}
