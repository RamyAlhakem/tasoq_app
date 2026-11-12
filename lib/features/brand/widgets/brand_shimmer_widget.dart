import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BrandShimmerWidget extends StatelessWidget {
  final bool isHomePage;
  const BrandShimmerWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    if (isHomePage) {
      // Sits in an unbounded-height Column (SliverToBoxAdapter), so a fixed
      // 2x4 Row/Column layout is used instead of a shrink-wrapped GridView.
      return Column(children: [
        Row(children: List.generate(4, (_) => const Expanded(child: _BrandShimmerItem()))),
        const SizedBox(height: 10),
        Row(children: List.generate(4, (_) => const Expanded(child: _BrandShimmerItem()))),
      ]);
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1/1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,),
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) => const _BrandShimmerItem(),
    );
  }
}

class _BrandShimmerItem extends StatelessWidget {
  const _BrandShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: AspectRatio(
        aspectRatio: 1/1.3,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).cardColor,
          highlightColor: Colors.grey[100]!,
          enabled: true,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, shape: BoxShape.circle))),
            Container(height: 10, color: Theme.of(context).colorScheme.secondaryContainer, margin: const EdgeInsets.only(left: 25, right: 25)),
          ]),
        ),
      ),
    );
  }
}
