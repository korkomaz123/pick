import 'dart:convert';
import 'package:http/http.dart' as http;

class SlackChannels {
  static String mainUrl = 'https://hooks.slack.com/services/T02D5TDG719/';
  static String logAppUsers = 'B02J20A1VM1/OKUwBeH0MhGWHMtpNp07uvNa';
  static String logAppErrors = 'B02JEHXL4GH/UlsW4YNSev2gOLOiiHuv3oFS';
  static String logAddOrder = 'B02JRKK6CRW/XyccPcUW9CMCg5k05Q6Yz6hf';
  static String logOrderError = 'B02J1UXRGJX/kfXGfai3VoTe7C4QGmXloNKe';
  static String logPaymentSuccessOrder = 'B02J1V3PSBU/SYUlHxayFempohDNKM8M6sK2';
  static String logPaymentFailedOrder = 'B02HV7PE23G/VJuFe9uRMvg00xL1WOCkALwa';
  static String logCanceledByUserOrder = 'B02HZ06MZKP/JxRBnph77evIEAhhbk8Rc4Ml';

  static send(String message, String channel) {
    //Makes request headers
    Map<String, String> requestHeader = {
      'Content-type': 'application/json',
    };

    var request = {
      'text': message,
    };

    var result = http
        .post(
      Uri.parse(mainUrl + channel),
      body: json.encode(request),
      headers: requestHeader,
    )
        .then((response) {
      print(response.body);
    });
    print(result);
  }
}
