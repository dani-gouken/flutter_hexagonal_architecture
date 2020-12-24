class ValidationService {
  static bool isInvalidDate(String date) {
    return RegExp(r"(?:\d{2})-(?:\d{2})-(?:\d{4})")
        .allMatches(date ?? "")
        .isEmpty;
  }

  static bool isEmpty(String string) {
    return string == null || string.isEmpty;
  }

  static bool isInvalidSex(String string) {
    return string != "Male" && string != "Female";
  }

  static bool isInvalidAmount(double amount) {
    return amount == null || amount < 0;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  static bool isNull(value) {
    return value == null;
  }
}

class ValidationMessage {
  static String required(String field) => "The field $field is required";
  static String invalid(String field) => "The field $field is not valid";
}
