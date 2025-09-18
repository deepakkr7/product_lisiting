class Validators {
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  static bool isValidOTP(String otp) {
    final otpRegex = RegExp(r'^\d{4}$');
    return otpRegex.hasMatch(otp);
  }

  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }
}