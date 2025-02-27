import 'dart:convert';

import 'package:dio/dio.dart';

import 'model/response_status.dart';

class AppException implements Exception {
  late int? statusCode;
  late String? message;
  late dynamic errorBody;
  String? displayMessage;

  // ignore: sort_constructors_first
  AppException.noArgs();

  // ignore: sort_constructors_first
  AppException.allArgs(this.statusCode, this.message, this.errorBody);

  // ignore: sort_constructors_first
  AppException(Response? response, [String? message])
      : this.allArgs(response?.statusCode, message, response?.data);

  static AppException forException(Response? response, [String? message]) {
    int? statusCode = response?.statusCode ?? 0;
    switch (statusCode) {
      case 400:
        return BadRequestException(response, message ?? 'Bad Request');

      case 401:
        return UnauthorizedException(response, message ?? 'Unauthorized');

      case 477:
        return DisplayMessageException(
            response, message ?? 'Display Message Exception');

      case 500:
        return InternalServerException(
            response, message ?? 'Internal Server error');

      case 502:
        return InternalServerException(
            response, message ?? 'Internal Server error');

      default:
        return AppException(
            response, message ?? 'An error occurred. Please try again.');
    }
  }
}

/*====== Custom Exceptions =======*/

class BadRequestException extends AppException {
  BadRequestException(Response? response, String message)
      : super(response, message) {
    final responseStatus = response?.data as Map<String, dynamic>?;
    this.message = responseStatus?["status"] ?? "";
    statusCode = response?.statusCode;
  }
}

class UnauthorizedException extends AppException {
  UnauthorizedException(Response? response, String message)
      : super(response, message);
}

class InvalidGrantException extends AppException {
  InvalidGrantException(Response response, String message)
      : super(response, message);
}

class DisplayMessageException extends AppException {
  DisplayMessageException(Response? response, String message)
      : super(response, message) {
    final responseStatus = response?.data as Map<String, dynamic>?;
    this.message = responseStatus?[0] ?? "";
    statusCode = response?.statusCode;
  }
}

class InternalServerException extends AppException {
  InternalServerException(Response? response, String message)
      : super(response, message) {
    if (response?.statusCode != 502) {
      final responseStatus = response?.data as Map<String, dynamic>?;
      this.message = responseStatus?[0] ?? 'Internal Server error';
    }
  }
}