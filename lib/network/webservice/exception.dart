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
  AppException(Response response, [String? message])
      : this.allArgs(response.statusCode, message, response.data);

  static AppException forResponse(Response response, [String? message]) {
    int? statusCode = response.statusCode;
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
  BadRequestException(Response response, String message)
      : super(response, message) {
    ResponseStatusModel responseStatus = ResponseStatusModel.fromJson(
        jsonDecode(response.data) as Map<String, dynamic>);
    this.message = responseStatus.responseStatus?.messages?.first.message ?? '';
    statusCode = responseStatus.responseStatus?.statusCode!;
  }
}

class UnauthorizedException extends AppException {
  UnauthorizedException(Response response, String message)
      : super(response, message);
}

class InvalidGrantException extends AppException {
  InvalidGrantException(Response response, String message)
      : super(response, message);
}

class DisplayMessageException extends AppException {
  DisplayMessageException(Response response, String message)
      : super(response, message) {
    ResponseStatusModel responseStatus = ResponseStatusModel.fromJson(
        jsonDecode(response.data) as Map<String, dynamic>);
    message = responseStatus.responseStatus?.messages?.first.message ?? '';
    statusCode = responseStatus.responseStatus?.statusCode!;
  }
}

class InternalServerException extends AppException {
  InternalServerException(Response response, String message)
      : super(response, message) {
    if (response.statusCode != 502) {
      final ResponseStatusModel responseStatus = ResponseStatusModel.fromJson(
          jsonDecode(response.data) as Map<String, dynamic>);
      this.message = responseStatus.responseStatus?.messages?.first.message ??
          'Internal Server error';
    }
  }
}