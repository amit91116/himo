class Validator {
  /// [pattern for validation, These are the basic validation regex patterns you can add your custom regex by passing it to function]
  static const Pattern patternNameOnlyChar =
      r'^[A-Za-z ]+(?:[ _-][A-Za-z ]+)*$';
  static const Pattern passwordMinLen8withCamelAndSpecialChar =
      r'^((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,20})';
  static const Pattern passwordMinLen8withLowerCaseAndSpecialChar =
      r'^((?=.*\d)(?=.*[a-z])(?=.*[\W_]).{8,20})';
  static const Pattern patternEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const Pattern patternPhone = r'^(?:[+0]9)?[0-9]{10,11}$';

  /// [common functions]
  static bool name(String name, Pattern pattern) {
    RegExp regexName = RegExp(pattern.toString());
    return !regexName.hasMatch(name) ? false : true;
  }

  static bool password(String password, Pattern pattern) {
    RegExp regexPassword = RegExp(pattern.toString());
    return !regexPassword.hasMatch(password) ? false : true;
  }

  static bool email(String email, Pattern pattern) {
    RegExp regexEmail = RegExp(pattern.toString());
    return !regexEmail.hasMatch(email) ? false : true;
  }

  static bool phone(String phone, Pattern pattern) {
    RegExp regexPhone = RegExp(pattern.toString());
    return !regexPhone.hasMatch(phone) ? false : true;
  }
}