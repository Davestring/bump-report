import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String userIdKey = 'UserID';

  static StorageService _instance;
  static SharedPreferences _preferences;

  /// Initialize the SharedPreference instance and returns a [StorageService]
  /// instance.
  static Future<StorageService> get instance async {
    _instance ??= StorageService();
    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  /// Loads a persisted data from the platform's disk.
  dynamic _load(String key) => _preferences.get(key);

  /// Persists data to the platform disk.
  void _store<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    }
  }

  /// Get the user's document ID in the Firestore `user` collection.
  String get userId => _load(userIdKey) as String;

  /// Stores the user's document ID from the Firebase `user` collection.
  set userId(String token) => _store(userIdKey, token);
}
