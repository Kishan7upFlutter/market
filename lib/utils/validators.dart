class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? requiredField(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    return null;
  }

  static String? maxdigit(String? v) {
    if (v == null || v.isEmpty) return 'Mobile No. is Required';
    if (v.length < 10) return 'Invalid Mobile No.';
    return null;
  }
}
