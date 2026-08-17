import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'storage_keys.dart';

class LocalStorage {
  LocalStorage._();

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(StorageKeys.goalsBox)) {
      await Hive.openBox(StorageKeys.goalsBox);
    }

    if (!Hive.isBoxOpen(StorageKeys.actionsBox)) {
      await Hive.openBox(StorageKeys.actionsBox);
    }

    if (!Hive.isBoxOpen(StorageKeys.profileBox)) {
      await Hive.openBox(StorageKeys.profileBox);
    }
  }

  static Box<dynamic> get goalsBox {
    if (!Hive.isBoxOpen(StorageKeys.goalsBox)) {
      throw StateError('Goals storage has not been initialized.');
    }

    return Hive.box<dynamic>(StorageKeys.goalsBox);
  }

  static Box<dynamic> get actionsBox {
    if (!Hive.isBoxOpen(StorageKeys.actionsBox)) {
      throw StateError('Actions storage has not been initialized.');
    }

    return Hive.box<dynamic>(StorageKeys.actionsBox);
  }

  static Box<dynamic> get profileBox {
    if (!Hive.isBoxOpen(StorageKeys.profileBox)) {
      throw StateError('Profile storage has not been initialized.');
    }

    return Hive.box<dynamic>(StorageKeys.profileBox);
  }
}
