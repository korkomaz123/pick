import 'dart:convert';
import 'package:http/http.dart' as http;

class SlackChannels {
  static String logAppUsers = 'https://hooks.slack.com/services/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';
  static String logAppErrors = 'https://hooks.slack.com/services/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';
  static send(String message, String channel) {
    //Makes request headers
    Map<String, String> requestHeader = {
      'Content-type': 'application/json',
    };

    var request = {
      'text': message,
    };

    var result = http.post(Uri.parse(channel), body: json.encode(request), headers: requestHeader).then((response) {
      print(response.body);
    });
    print(result);
  }
}
