import 'package:hive_ce_flutter/hive_flutter.dart';

import 'storage_keys.dart';

class LocalStorage {
  LocalStorage._();

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(StorageKeys.goalsBox)) {
      await Hive.openBox(StorageKeys.goalsBox);
    }
  }

  static Box<dynamic> get goalsBox {
    if (!Hive.isBoxOpen(StorageKeys.goalsBox)) {
      throw StateError('Goals storage has not been initialized.');
    }

    return Hive.box<dynamic>(StorageKeys.goalsBox);
  }
}
