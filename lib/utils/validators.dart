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
