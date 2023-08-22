import 'package:json_annotation/json_annotation.dart';

part 'promo_code_details_response_model.g.dart';

@JsonSerializable(
    createToJson: false, fieldRename: FieldRename.snake, includeIfNull: false)
class PromoCodeDetailsResponseModel {
  String? promoCode;
  String? entityName;
  String? entityCode;
  int? percentageDiscount;
  bool? isExpired;

  PromoCodeDetailsResponseModel(
      {this.promoCode,
      this.entityCode,
      this.entityName,
      this.isExpired,
      this.percentageDiscount});

  factory PromoCodeDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PromoCodeDetailsResponseModelFromJson(json);
}
