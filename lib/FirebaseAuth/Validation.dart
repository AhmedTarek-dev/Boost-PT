class Validator {
  bool validateEmail(String email) {
    List list1;
    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$',
            caseSensitive: false,
            multiLine: false)
        .hasMatch(email);

    // bool emailValid =
    //     RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    //             r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    //             r"{0,253}[a-zA-Z0-9])?)*$")
    //         .hasMatch(email);
    if (emailValid) {
      return true;
    } else {
      return false;
    }
  }

  bool validateName(String name) {
    bool nameValid = RegExp(r"^[a-z A-Z,.\-]+$").hasMatch(name);
    if (nameValid && name.length >= 4) {
      // print('$name');
      return true;
    } else {
      // print('$name');
      return false;
    }
  }

  bool validatePhone(String phone) {
    bool phoneValid = RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(phone);

    if (phoneValid) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePassword(String password) {
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password);

    if (passwordValid) {
      return true;
    } else {
      return false;
    }
  }
}
