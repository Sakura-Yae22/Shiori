import 'dart:async';

import 'package:shiori/domain/enums/enums.dart';
import 'package:shiori/domain/models/models.dart';
import 'package:shiori/domain/services/persistence/base_data_service.dart';

typedef RedistributeInventoryMaterial = Future<void> Function(String, int);
typedef RedistributeAllInventoryMaterials = Future<void> Function();

abstract class InventoryDataService implements BaseDataService {
  StreamController<ItemType> get itemAddedToInventory;

  StreamController<ItemType> get itemUpdatedInInventory;

  StreamController<ItemType> get itemDeletedFromInventory;

  List<CharacterCardModel> getAllCharactersInInventory();

  List<WeaponCardModel> getAllWeaponsInInventory();

  List<MaterialCardModel> getAllMaterialsInInventory();

  MaterialCardModel getMaterialFromInventory(String image);

  Future<void> addCharacterToInventory(String key, {bool raiseEvent = true});

  Future<void> deleteCharacterFromInventory(String key, {bool raiseEvent = true});

  Future<void> addWeaponToInventory(String key, {bool raiseEvent = true});

  Future<void> deleteWeaponFromInventory(String key, {bool raiseEvent = true});

  Future<void> addItemToInventory(String key, ItemType type, int quantity, {bool raiseEvent = true});

  Future<void> updateItemInInventory(String key, ItemType type, int quantity, RedistributeInventoryMaterial redistribute, {bool raiseEvent = true});

  Future<void> deleteItemFromInventory(String key, ItemType type, {bool raiseEvent = true});

  Future<void> deleteItemsFromInventory(ItemType type, {bool raiseEvent = true});

  Future<void> deleteAllItemsInInventoryExceptMaterials(ItemType? type);

  Future<void> deleteAllUsedMaterialItems();

  Future<void> deleteAllUsedInventoryItems();

  bool isItemInInventory(String key, ItemType type);

  int getNumberOfItemsUsed(String itemKey, ItemType type);

  Future<int> redistributeMaterial(int calItemKey, ItemAscensionMaterials item, String itemKey, int currentQuantity);

  Future<void> useItemFromInventory(int calculatorItemKey, String itemKey, ItemType type, int quantityToUse);

  Future<void> clearUsedInventoryItems(
    int calculatorItemKey,
    RedistributeAllInventoryMaterials redistributeAll, {
    String? onlyItemKey,
    bool redistribute = false,
  });

  int getNumberOfItemsUsedByCalcKeyItemKeyAndType(int calculatorItemKey, String itemKey, ItemType type);

  int getRemainingQuantity(int calculatorItemKey, String itemKey, int current, ItemType type);

  List<ItemCommonWithQuantity> getItemsForRedistribution(ItemType type);

  List<BackupInventoryModel> getDataForBackup();

  Future<void> restoreFromBackup(List<BackupInventoryModel> data);
}
