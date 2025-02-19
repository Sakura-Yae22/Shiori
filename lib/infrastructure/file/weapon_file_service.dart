import 'package:shiori/domain/enums/stat_type.dart';
import 'package:shiori/domain/models/models.dart';
import 'package:shiori/domain/services/file/file_infrastructure.dart';
import 'package:shiori/domain/services/resources_service.dart';

class WeaponFileServiceImpl extends WeaponFileService {
  final ResourceService _resourceService;
  final MaterialFileService _materials;
  final TranslationFileService _translations;

  late WeaponsFile _weaponsFile;

  @override
  ResourceService get resources => _resourceService;

  @override
  TranslationFileService get translations => _translations;

  @override
  MaterialFileService get materials => _materials;

  WeaponFileServiceImpl(this._resourceService, this._materials, this._translations);

  @override
  Future<void> init(String assetPath) async {
    final json = await readJson(assetPath);
    _weaponsFile = WeaponsFile.fromJson(json);
  }

  @override
  List<WeaponCardModel> getWeaponsForCard() {
    return _weaponsFile.weapons.map((e) => _toWeaponForCard(e)).toList();
  }

  @override
  WeaponFileModel getWeapon(String key) {
    return _weaponsFile.weapons.firstWhere((element) => element.key == key);
  }

  @override
  WeaponCardModel getWeaponForCard(String key) {
    final weapon = _weaponsFile.weapons.firstWhere((el) => el.key == key);
    return _toWeaponForCard(weapon);
  }

  @override
  List<String> getUpcomingWeaponsKeys() => _weaponsFile.weapons.where((el) => el.isComingSoon).map((e) => e.key).toList();

  @override
  List<ItemCommon> getWeaponForItemsUsingMaterial(String key) {
    final items = <ItemCommon>[];

    for (final weapon in _weaponsFile.weapons) {
      final materials = weapon.craftingMaterials + weapon.ascensionMaterials.expand((e) => e.materials).toList();
      final allMaterials = _materials.getMaterialsFromAscensionMaterials(materials);
      if (allMaterials.any((m) => m.key == key)) {
        items.add(ItemCommon(weapon.key, _resourceService.getWeaponImagePath(weapon.image, weapon.type)));
      }
    }

    return items;
  }

  @override
  List<TodayWeaponAscensionMaterialModel> getWeaponAscensionMaterials(int day) {
    return _materials.getWeaponAscensionMaterials(day).map((e) {
      final translation = _translations.getMaterialTranslation(e.key);

      final weapons = <ItemCommon>[];
      for (final weapon in _weaponsFile.weapons) {
        final materialIsBeingUsed = weapon.ascensionMaterials.expand((m) => m.materials).where((m) => m.key == e.key).isNotEmpty;
        if (materialIsBeingUsed) {
          weapons.add(ItemCommon(weapon.key, _resourceService.getWeaponImagePath(weapon.image, weapon.type)));
        }
      }
      return TodayWeaponAscensionMaterialModel(
        key: e.key,
        days: e.days,
        name: translation.name,
        image: _resourceService.getMaterialImagePath(e.image, e.type),
        weapons: weapons,
      );
    }).toList();
  }

  @override
  int countByStatType(StatType statType) {
    return _weaponsFile.weapons.where((el) => !el.isComingSoon && el.secondaryStat == statType).length;
  }

  @override
  List<ItemCommonWithName> getItemCommonWithNameByRarity(int rarity) {
    return getWeaponsForCard().where((el) => el.rarity == rarity).map((e) => ItemCommonWithName(e.key, e.image, e.name)).toList();
  }

  @override
  List<ItemCommonWithName> getItemCommonWithNameByStatType(StatType statType) {
    return _weaponsFile.weapons.where((el) => el.secondaryStat == statType && !el.isComingSoon).map((e) {
      final translation = _translations.getWeaponTranslation(e.key);
      return ItemCommonWithName(e.key, _resourceService.getWeaponImagePath(e.image, e.type), translation.name);
    }).toList();
  }

  WeaponCardModel _toWeaponForCard(WeaponFileModel weapon) {
    final translation = _translations.getWeaponTranslation(weapon.key);
    return WeaponCardModel(
      key: weapon.key,
      baseAtk: weapon.atk,
      image: _resourceService.getWeaponImagePath(weapon.image, weapon.type),
      name: translation.name,
      rarity: weapon.rarity,
      type: weapon.type,
      subStatType: weapon.secondaryStat,
      subStatValue: weapon.secondaryStatValue,
      isComingSoon: weapon.isComingSoon,
      locationType: weapon.location,
    );
  }
}
