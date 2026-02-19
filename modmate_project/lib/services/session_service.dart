import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _kUsernameDocId = 'usernameDocId';

  static Future<void> saveUsernameDocId(String usernameDocId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsernameDocId, usernameDocId);
  }

  static Future<String?> getUsernameDocId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUsernameDocId);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUsernameDocId);
  }
}
