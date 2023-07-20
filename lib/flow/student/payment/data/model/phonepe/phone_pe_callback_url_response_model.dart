class PhonePeCallbackUrlResponseModel {
  String? response;

  PhonePeCallbackUrlResponseModel({this.response});

  PhonePeCallbackUrlResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
  }
}
