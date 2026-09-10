import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class DashDivider extends StatelessWidget {
  const DashDivider({
    super.key,
    required this.activeIndex,
  });

  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dash(color: activeIndex == 0 ? AppColors.lightBlue : AppColors.divider),
          const SizedBox(width: 10),
          _dash(color: activeIndex == 1 ? AppColors.lightBlue : AppColors.divider),
          const SizedBox(width: 10),
          _dash(color: activeIndex == 2 ? AppColors.lightBlue : AppColors.divider),
        ],
      ),
    );
  }

  Widget _dash({required Color color}) {
    return Container(
      width: AppDimens.dashWidth,
      height: AppDimens.dashHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
