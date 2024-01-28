import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static StorageUtils? _storageUtil;
  static SharedPreferences? _preferences;

  static Future<StorageUtils?> getInstance() async {
    if (_storageUtil == null) {
      var secureStorage = StorageUtils._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtils._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // put string
  static Future<bool>? putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key) ?? defValue;
  }

  // clear string
  static Future<void>? clrString() async {
    SharedPreferences prefs = _preferences!;
    prefs.clear();
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static void clearWithParameter(String name) {
    SharedPreferences prefs = _preferences!;
    prefs.remove(name);
  }
}
