extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
    return emailRegExp.hasMatch(this);
  }

  double get toDouble {
    if (isValid) {
      var myDouble = double.parse(this);
      return myDouble;
    } else {
      return 0.0;
    }
  }

  /// Converts [text] to a slug [String] separated by the [delimiter].
  String get convertToSlug {
    // Trim leading and trailing whitespace.
    var slug = trim();
    slug = slug.toLowerCase();
    var _dupeSpaceRegExp = RegExp(r'\s{2,}');
    var _punctuationRegExp = RegExp(r'[^\w\s-]');
    slug = slug
        // Condense whitespaces to 1 space.
        .replaceAll(_dupeSpaceRegExp, ' ')
        // Remove punctuation.
        .replaceAll(_punctuationRegExp, '')
        // Replace space with the delimiter.
        .replaceAll(' ', "_");

    return slug;
  }

  String get getStringFromEnum {
    return split('.').last;
  }
}

extension NullStringExtensions on String? {
  bool get isNotNull {
    return this != null;
  }

  bool get isValid {
    return this != null && this!.isNotEmpty;
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this ?? "");
  }

  double? get toDouble {
    if (this != null && isValid) {
      var myDouble = double.parse(this!);
      return myDouble;
    } else {
      return null;
    }
  }

  String? get convertToSlug {
    // Trim leading and trailing whitespace.
    String? slug;
    if (this != null) {
      slug = this!.trim();
      slug = slug.toLowerCase();
      var _dupeSpaceRegExp = RegExp(r'\s{2,}');
      var _punctuationRegExp = RegExp(r'[^\w\s-]');
      slug = slug
          // Condense whitespaces to 1 space.
          .replaceAll(_dupeSpaceRegExp, ' ')
          // Remove punctuation.
          .replaceAll(_punctuationRegExp, '')
          // Replace space with the delimiter.
          .replaceAll(' ', "_");
    }

    return slug;
  }
}
