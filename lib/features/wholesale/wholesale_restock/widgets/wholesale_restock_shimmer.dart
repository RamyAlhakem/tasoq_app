import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WholesaleRestockShimmer extends StatelessWidget {
  const WholesaleRestockShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeController>(context, listen: false).darkTheme;
    final Color blockColor = isDark ? Theme.of(context).primaryColor.withValues(alpha: .05) : Theme.of(context).colorScheme.secondaryContainer;

    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: isDark ? Theme.of(context).cardColor : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          enabled: true,
          child: ListTile(
            leading: Container(height: 50, width: 50, color: blockColor),
            title: Container(height: 20, color: blockColor),
            subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(height: 10, width: 70, color: blockColor),
              Container(height: 10, width: 20, color: blockColor),
              Container(height: 10, width: 50, color: blockColor),
            ]),
            trailing: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(height: 15, width: 15, decoration: BoxDecoration(shape: BoxShape.circle, color: blockColor)),
              const SizedBox(height: 10),
              Container(height: 10, width: 50, color: blockColor),
            ]),
          ),
        );
      },
    );
  }
}
