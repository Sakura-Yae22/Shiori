import 'package:flutter/widgets.dart';

class ArtifactCardModel {
  final String name;
  final String image;
  final int rarity;
  final List<String> bonus;

  ArtifactCardModel({
    @required this.name,
    @required this.image,
    @required this.rarity,
    @required this.bonus,
  });
}
