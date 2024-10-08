import 'package:flutter/material.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser _user = AuthUser.getEmpty();

  AuthUser get user {
    return _user;
  }

  bool get isLogged {
    return _user.id >= 0;
  }

  void setUser(int id, String name, String email, String role, bool withStand, int balance) {
    _user = AuthUser(
      id: id,
      name: name,
      email: email,
      role: role,
      withStand: withStand,
      balance: balance,
    );
    notifyListeners();
  }

  void setHasStand(
      bool withStand,
      ) {
    _user = AuthUser(
      id: _user.id,
      name: _user.name,
      email: _user.email,
      role: _user.role,
      withStand: withStand,
      balance: _user.balance,
    );
    notifyListeners();
  }

  void setBalance(int newBalance) {
    _user = AuthUser(
      id: _user.id,
      name: _user.name,
      email: _user.email,
      role: _user.role,
      withStand: _user.withStand,
      balance: newBalance,
    );
    notifyListeners();
  }
}