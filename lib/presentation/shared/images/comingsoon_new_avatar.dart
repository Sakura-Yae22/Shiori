import 'package:flutter/material.dart';
import 'package:shiori/generated/l10n.dart';

class ComingSoonNewAvatar extends StatelessWidget {
  final bool isNew;
  final bool isComingSoon;

  const ComingSoonNewAvatar({
    super.key,
    required this.isNew,
    required this.isComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final newOrComingSoon = isNew || isComingSoon;
    final icon = isNew ? Icons.fiber_new_outlined : Icons.av_timer;
    final newOrComingSoonAvatar = Container(
      margin: const EdgeInsets.only(top: 10, left: 5),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: newOrComingSoon ? theme.colorScheme.secondary : Colors.transparent,
        child: newOrComingSoon ? Icon(icon, color: Colors.white) : null,
      ),
    );
    if (newOrComingSoon) {
      return Tooltip(
        message: isComingSoon ? s.comingSoon : s.recent,
        child: newOrComingSoonAvatar,
      );
    }

    return newOrComingSoonAvatar;
  }
}
