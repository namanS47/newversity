
import 'package:json_annotation/json_annotation.dart';
part 'payment_argument.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class PaymentArgument {
  PaymentArgument({required this.amount, required this.availabilityId});

  final int amount;
  final String availabilityId;
  String? studentId;

  Map<String, dynamic> toJson() => _$PaymentArgumentToJson(this);
}
