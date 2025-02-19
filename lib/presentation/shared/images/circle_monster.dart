import 'package:flutter/material.dart';
import 'package:shiori/generated/l10n.dart';
import 'package:shiori/presentation/shared/images/circle_item.dart';
import 'package:shiori/presentation/shared/utils/toast_utils.dart';

class CircleMonster extends StatelessWidget {
  final String itemKey;
  final String image;
  final double radius;
  final Function(String)? onTap;

  const CircleMonster({
    super.key,
    required this.itemKey,
    required this.image,
    this.radius = 35,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final fToast = ToastUtils.of(context);
    return CircleItem(
      image: image,
      radius: radius,
      onTap: (_) => onTap != null ? onTap!(image) : ToastUtils.showWarningToast(fToast, s.comingSoon),
    );
  }
}
