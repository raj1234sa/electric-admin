dynamic validateServiceName(String value) {
  if (value.isEmpty) {
    return 'Service name is required.';
  }
  return null;
}

dynamic validateServicePrice(String value) {
  if (value.isEmpty) {
    return 'Service price is required.';
  }
  return null;
}

dynamic validatePhoneNumber(String value) {
  Pattern pattern = r'/([^\d])\d{10}([^\d])/';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(pattern)) {
    return 'Please enter 10 digits only';
  }
  return null;
}
