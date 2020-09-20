String validateEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool emailValid = new RegExp(pattern).hasMatch(email);
  if (!emailValid) {
    return 'Please enter a valid email';
  } else {
    return null;
  }
}

String validatePassword(String password) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  bool pwValid = RegExp(pattern).hasMatch(password);
  if (password.length < 8) {
    return 'Password must be 8 character long';
  } else if (!pwValid) {
    return 'Password must contain lowercase, uppercase, number & special character';
  } else {
    return null;
  }
}

String validateRePassword(String password, String rePassword) {
  if (password == rePassword) {
    return null;
  } else {
    return 'Password not matched';
  }
}

String validateUserName(String username) {
  if (username.length < 6) {
    return 'Username length must be 6 character long';
  } else if (username.trim().isEmpty || username.trim() == '') {
    return 'Please enter valid username';
  } else {
    return null;
  }
}

String validatePhone(String phone) {
  if (phone.isEmpty) {
    return 'Please enter phone number';
  }
  if (phone.trim().length != 10) {
    return 'Phone number must be 10 digits long';
  }
  try {
    var phoneNu = int.parse(phone);
  } on FormatException {
    return 'Please enter numbers only';
  }
  return null;
}
