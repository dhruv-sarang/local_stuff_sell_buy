import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AppUtil {
  static String? isValidEmail(String email) {
    if (email.isEmpty) {
      return 'Email can\'t be empty.';
    }
    String pattern = r'\w+@\w+\.\w+';

    if (!RegExp(pattern).hasMatch(email)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  static String? isValidPassword(String password) {
    RegExp passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])(?!.*\s).{8,16}$');

    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 8 || password.length > 16) {
      return 'Length between 8-16 characters';
    }
    if (!passwordRegex.hasMatch(password)) {
      return 'Password is not strong enough';
    }
    return null;
  }

  static String? checkPasswordEpmty(String email) {
    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Name';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Description';
    }
    return null;
  }

  static String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? validateSelection(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select any one from given Option';
    }
    return null;
  }

  static Future<XFile?> pickImageFromGallery() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      return image;
    } catch (e) {
      return null;
    }
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an Description';
    }
    return null;
  }

  static String formatCurrency(int amount) {
    final format = NumberFormat.currency(
      locale: 'en_IN', // Specify Indian locale
      symbol: '₹', // Currency symbol
      decimalDigits: 0, // Decimal digits to display
    );
    return format.format(amount);
  }
}
