// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Inclusive of all taxes`
  String get inclusiveTax {
    return Intl.message(
      'Inclusive of all taxes',
      name: 'inclusiveTax',
      desc: '',
      args: [],
    );
  }

  /// `Select Shades: `
  String get selectShades {
    return Intl.message(
      'Select Shades: ',
      name: 'selectShades',
      desc: '',
      args: [],
    );
  }

  /// `Select Size: `
  String get selectSize {
    return Intl.message(
      'Select Size: ',
      name: 'selectSize',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number to get started`
  String get descriptionText {
    return Intl.message(
      'Enter your phone number to get started',
      name: 'descriptionText',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get mobileDescription {
    return Intl.message(
      'Mobile Number',
      name: 'mobileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Hello !`
  String get hello {
    return Intl.message(
      'Hello !',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `PROCEED`
  String get proceed {
    return Intl.message(
      'PROCEED',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `Verify using OTP`
  String get verificationDescription {
    return Intl.message(
      'Verify using OTP',
      name: 'verificationDescription',
      desc: '',
      args: [],
    );
  }

  /// `send to `
  String get justSendCode {
    return Intl.message(
      'send to ',
      name: 'justSendCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendCode {
    return Intl.message(
      'Resend OTP',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAccount {
    return Intl.message(
      'Create an account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Email Id`
  String get email {
    return Intl.message(
      'Email Id',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `What is your field Of interest ?`
  String get whatIsFieldOfIntrest {
    return Intl.message(
      'What is your field Of interest ?',
      name: 'whatIsFieldOfIntrest',
      desc: '',
      args: [],
    );
  }

  /// `Which class you are in ?`
  String get whichClass {
    return Intl.message(
      'Which class you are in ?',
      name: 'whichClass',
      desc: '',
      args: [],
    );
  }

  /// `Tell us more about yourself`
  String get tellUsMore {
    return Intl.message(
      'Tell us more about yourself',
      name: 'tellUsMore',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAcc {
    return Intl.message(
      'Create Account',
      name: 'createAcc',
      desc: '',
      args: [],
    );
  }

  /// `please enter Name`
  String get enterName {
    return Intl.message(
      'please enter Name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid name`
  String get invalidName {
    return Intl.message(
      'Please enter valid name',
      name: 'invalidName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get enterEmail {
    return Intl.message(
      'Please enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter class`
  String get enterClass {
    return Intl.message(
      'Please enter class',
      name: 'enterClass',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid class`
  String get invalidClass {
    return Intl.message(
      'Please enter valid class',
      name: 'invalidClass',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
