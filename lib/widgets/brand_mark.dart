import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';

/// Centred brand mark of the redesigned auth screens (`forgot-password.png`,
/// `verification.png`): the app logo above a hero title.
///
/// Shared so the two screens cannot drift on the mark's height, and so the asset
/// path is named once. A missing or unreadable file degrades to a glyph rather
/// than an error box, since it must never block a form the user has to complete.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.height = 104});

  /// Height of the mark, read off the reference images.
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/logo.png',
        height: height,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.account_balance,
          size: height,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
