class Validator {

  static String? validateField({required String value}) {
    if(value.isEmpty)
      return 'Field can\'t be empty';
    return null;
  }

  static String? validateUserId({required String uid}) {
    if(uid.isEmpty)
      return 'User ID can\'t be empty';
    else if(uid.length <= 3)
      return 'user ID should be greater then 3 characters';
    return null;
  }

}