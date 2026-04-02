import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<ErrorMessageService>(() => ErrorMessageService());
  getIt.registerLazySingleton<OpenDialogService>(() => OpenDialogService());
  getIt.registerLazySingleton<UserLoginService>(() => UserLoginService());
}

class ErrorMessageService {
  String? _errorMessage;

  String? getErrorMessage() {
    return _errorMessage;
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
  }

  void clearErrorMessage() {
    _errorMessage = null;
  }
}

class OpenDialogService {
  bool _isOpen = false;
  bool get isOpen => _isOpen;

  void setIsOpen(bool value) {
    _isOpen = value;
  }
}

class UserLoginService extends ChangeNotifier {
  String isUserLogin = '';
  String get userLogin => isUserLogin;

  void setUserLogin(String userLogin) {
    if (isUserLogin != userLogin) {
      isUserLogin = userLogin;
      notifyListeners();
    }
  }

  String? getUserLogin() {
    return isUserLogin;
  }
}
