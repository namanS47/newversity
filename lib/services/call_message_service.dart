import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number");
  void sendEmail(String email) => launch("mailto:$email");
  void sendWhatsAppMessage(String number) => launch("whatsapp://send?phone=$number");
}