import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

/// Account model for storing multiple user accounts
class Account {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final String? token;
  final DateTime lastLogin;

  Account({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.token,
    required this.lastLogin,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Student',
      avatarUrl: json['avatarUrl'],
      token: json['token'],
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'token': token,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    String? token,
    DateTime? lastLogin,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      token: token ?? this.token,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  String get initials {
    if (name.isEmpty) return '??';
    final names = name.split(' ');
    if (names.length >= 2 && names[0].isNotEmpty && names[1].isNotEmpty) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    if (name.length >= 2) return name.substring(0, 2).toUpperCase();
    return name[0].toUpperCase();
  }
}

/// Service for managing multiple user accounts
/// 
/// Backend developers: This service allows users to switch between
/// multiple accounts on the same device without re-entering credentials.
class AccountService {
  static const String _accountsKey = 'saved_accounts';
  static const String _currentAccountIdKey = 'current_account_id';

  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  /// Get all saved accounts
  static Future<List<Account>> getAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getStringList(_accountsKey) ?? [];
    return accountsJson
        .map((json) => Account.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Get current active account
  static Future<Account?> getCurrentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getString(_currentAccountIdKey);
    if (currentId == null) return null;

    final accounts = await getAllAccounts();
    return accounts.where((a) => a.id == currentId).firstOrNull;
  }

  /// Get current account ID
  static Future<String?> getCurrentAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAccountIdKey);
  }

  /// Add or update an account
  static Future<void> addAccount(Account account) async {
    final accounts = await getAllAccounts();
    final prefs = await SharedPreferences.getInstance();

    // Remove existing account with same ID or email if exists
    accounts.removeWhere((a) => a.id == account.id || a.email == account.email);
    
    // Add new account at the beginning (most recent)
    accounts.insert(0, account);
    
    // Save accounts list
    final accountsJson = accounts.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_accountsKey, accountsJson);
    
    // Set as current account
    await prefs.setString(_currentAccountIdKey, account.id);
  }

  /// Switch to a different account
  static Future<void> switchAccount(String accountId) async {
    final accounts = await getAllAccounts();
    final account = accounts.where((a) => a.id == accountId).firstOrNull;
    
    if (account == null) {
      throw Exception('Account not found');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAccountIdKey, accountId);
    
    // Also update AuthService with the new account's credentials
    await AuthService.setCurrentAccount(account);
  }

  /// Remove an account
  static Future<void> removeAccount(String accountId) async {
    final accounts = await getAllAccounts();
    final prefs = await SharedPreferences.getInstance();
    
    accounts.removeWhere((a) => a.id == accountId);
    
    final accountsJson = accounts.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_accountsKey, accountsJson);
    
    // If removed account was current, clear current account
    final currentId = prefs.getString(_currentAccountIdKey);
    if (currentId == accountId) {
      await prefs.remove(_currentAccountIdKey);
      await prefs.clear(); // Clear all session data
    }
  }

  /// Remove all accounts
  static Future<void> removeAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accountsKey);
    await prefs.remove(_currentAccountIdKey);
    await prefs.clear();
  }

  /// Check if there are any saved accounts
  static Future<bool> hasAccounts() async {
    final accounts = await getAllAccounts();
    return accounts.isNotEmpty;
  }

  /// Get account count
  static Future<int> getAccountCount() async {
    final accounts = await getAllAccounts();
    return accounts.length;
  }

  /// Update account last login time
  static Future<void> updateLastLogin(String accountId) async {
    final accounts = await getAllAccounts();
    final index = accounts.indexWhere((a) => a.id == accountId);
    
    if (index != -1) {
      accounts[index] = accounts[index].copyWith(lastLogin: DateTime.now());
      // Move to beginning (most recent)
      final account = accounts.removeAt(index);
      accounts.insert(0, account);
      
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = accounts.map((a) => jsonEncode(a.toJson())).toList();
      await prefs.setStringList(_accountsKey, accountsJson);
    }
  }
}
