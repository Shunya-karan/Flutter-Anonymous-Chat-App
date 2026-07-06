class Validators {
  Validators._();

  /// Username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required";
    }

    if (value.trim().length < 3) {
      return "Username must be at least 3 characters";
    }

    if (value.trim().length > 20) {
      return "Username cannot exceed 20 characters";
    }

    return null;
  }

  /// Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  /// Password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  /// Confirm Password
  static String? confirmPassword(
      String? value,
      String password)
  {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }

  /// Bio
  static String? bio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.length > 150) {
      return "Bio cannot exceed 150 characters";
    }

    return null;
  }

  static String? identifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email or Username is required";
    }

    return null;
  }
}
