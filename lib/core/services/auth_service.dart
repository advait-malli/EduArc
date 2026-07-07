import 'package:shared_preferences/shared_preferences.dart';
import 'account_service.dart';
import 'api_service.dart';

/// Authentication Service for managing user session
/// 
/// Backend developers should update the [login] method to call
/// [ApiService.login] and store the returned token.
class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userRoleKey = 'userRole';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';
  static const String _userIdKey = 'userId';
  static const String _tokenKey = 'authToken';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Login with email and password (calls server API)
  static Future<Map<String, dynamic>> loginWithPassword(
    String email,
    String password,
  ) async {
    final response = await ApiService().login(email, password);
    final token = response['token'] as String;
    final user = response['user'] as Map<String, dynamic>;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userRoleKey, user['role'] as String);
    await prefs.setString(_userEmailKey, user['email'] as String);
    await prefs.setString(_userNameKey, user['name'] as String);
    await prefs.setString(_userIdKey, user['id'] as String);
    await prefs.setString(_tokenKey, token);

    final account = Account(
      id: user['id'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      role: user['role'] as String,
      token: token,
      lastLogin: DateTime.now(),
    );
    await AccountService.addAccount(account);

    return response;
  }

  /// Login with email and role (mock implementation)
  static Future<void> login(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final name = email.split('@').first;
    
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userRoleKey, role);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userIdKey, userId);
    
    // Save to account service for multi-account support
    final account = Account(
      id: userId,
      name: name,
      email: email,
      role: role,
      lastLogin: DateTime.now(),
    );
    await AccountService.addAccount(account);
  }

  /// Set current account (used when switching accounts)
  static Future<void> setCurrentAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, account.id);
    await prefs.setString(_userNameKey, account.name);
    await prefs.setString(_userEmailKey, account.email);
    await prefs.setString(_userRoleKey, account.role);
    if (account.token != null) {
      await prefs.setString(_tokenKey, account.token!);
    }
    
    // Update last login
    await AccountService.updateLastLogin(account.id);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Update auth token
  static Future<void> updateToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    
    // Also update in account service
    final accountId = await getUserId();
    if (accountId != null) {
      final accounts = await AccountService.getAllAccounts();
      final index = accounts.indexWhere((a) => a.id == accountId);
      if (index != -1) {
        accounts[index] = accounts[index].copyWith(token: token);
        // Note: Would need to save back to AccountService
      }
    }
  }
}