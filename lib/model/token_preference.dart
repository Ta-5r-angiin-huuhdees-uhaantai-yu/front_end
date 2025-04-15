import 'package:shared_preferences/shared_preferences.dart';

class CookiePreference {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // ----------------- Cookies -----------------

  Future<void> saveCookies(List<String> cookies) async {
    final prefs = await _getPreferences();
    await prefs.setStringList('cookies', cookies);
    print('Cookies saved successfully.');
  }

  Future<List<String>> getCookies() async {
    final prefs = await _getPreferences();
    return prefs.getStringList('cookies') ?? [];
  }

  Future<void> clearCookies() async {
    final prefs = await _getPreferences();
    await prefs.remove('cookies');
    print('Cookies cleared successfully.');
  }

  // ----------------- Token -----------------

  Future<void> saveToken(String token) async {
    final prefs = await _getPreferences();
    await prefs.setString('auth_token', token);
    print('Token saved successfully.');
  }

  Future<String?> getToken() async {
    final prefs = await _getPreferences();
    return prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    final prefs = await _getPreferences();
    await prefs.remove('auth_token');
    print('Token cleared successfully.');
  }
}
