import 'package:electric_admin/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<bool> saveUserToSharedRef(String key, User user) async {
    final prefs = await SharedPreferences.getInstance();
    String str = user.toJson();
    bool result = await prefs.setString(key, str);
    return result;
  }

  static Future<User> readUserFromSharedRef(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String str = prefs.getString(key);
    print(str);
    if (str != null && str != '') {
      // User fetchedUser= User.fromMap(json.decode(str));
      User fetchedUser = User.fromJson(str);

      return fetchedUser;
    } else {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.remove(key);
    return result;
  }

  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.clear();
    return result;
  }
}
