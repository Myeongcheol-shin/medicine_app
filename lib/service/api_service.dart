import 'dart:convert';

import 'package:medicine_app/key/app_key.dart';
import 'package:medicine_app/model/medicine_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList";
  static String key = ApiKey.key;

  final String name;

  ApiService({required this.name});

  static Future<List<Items>> getMedicine(String name) async {
    if (name == "") return [];
    final url = Uri.parse(
        "$baseUrl?serviceKey=$key&pageNum=1&numOfRows=8&itemName=$name&type=json");
    final response = await http.get(url);
    final List<Items> medicines = [];
    if (response.statusCode == 200) {
      try {
        jsonDecode(response.body);
      } on FormatException {
        return [];
      }
      final rb = jsonDecode(response.body);
      final items = rb['body']['items'];
      if (items == null) return [];
      for (var item in items) {
        medicines.add(Items.fromJson(item));
      }
      return medicines;
    }
    return medicines;
  }
}
