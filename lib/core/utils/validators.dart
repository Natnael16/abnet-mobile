String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your full name';
  }

  return null;
}

String? validateTitle(String? value) {
  if (value == null || value.isEmpty || value.length < 5) {
    return 'Title must be at least 5 characters';
  }

  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty || value.length < 10) {
    return 'Description must be at least 10 characters';
  }

  return null;
}