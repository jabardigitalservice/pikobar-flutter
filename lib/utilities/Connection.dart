import 'package:http/http.dart' as http;

class Connection {
  Future<bool> checkConnection(String host) async {
    var response = await http.get(host).timeout(Duration(seconds: 2));
    return response.statusCode == 200;
  }
}