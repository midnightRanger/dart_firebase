import 'package:firebase_auth/firebase_auth.dart';

enum ExceptionCodes {
  weak_password,
  email_already_in_user,
  user_not_found, 
  wrong_password,
  something_went_wrong
}

extension ExceptionCodesExtension on ExceptionCodes {
  String get exceptionMessage {
    switch(this) {
      case ExceptionCodes.email_already_in_user: 
        return "Такой E-mail уже используется!"; 
      case ExceptionCodes.user_not_found: 
        return "Пользователь с такими данными не найден";
      case ExceptionCodes.weak_password: 
        return "Пароль не удовлетворяет валидации";
      case ExceptionCodes.wrong_password: 
        return "Указанный пароль не подходит";

      default: 
        return "Что-то пошло не так..";
    }
  }
}

ExceptionCodes getExceptionCode (String code) {
  for (final e in ExceptionCodes.values) {
    String decodedException = e.name.replaceAll(RegExp(r'_'),'-').toString();
    if (decodedException == code) return e; 
     
  }
return  ExceptionCodes.something_went_wrong; 
}