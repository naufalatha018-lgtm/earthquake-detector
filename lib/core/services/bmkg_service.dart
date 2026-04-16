import 'dart:convert';
import 'package:http/http.dart' as http;

class BMKGService {
  static Future<Map<String, String>> getGempa() async {
    final url = Uri.parse(
      'https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final gempa = data['Infogempa']['gempa'];

      return {
        "tanggal": gempa['Tanggal'],
        "jam": gempa['Jam'],
        "magnitude": gempa['Magnitude'],
        "kedalaman": gempa['Kedalaman'],
        "wilayah": gempa['Wilayah'],
      };
    } else {
      throw Exception('Gagal ambil data BMKG');
    }
  }
}
