import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shamo/models/category_model.dart';

class CategoryService {
  String baseUrl = 'https://shamo-backend.buildwithangga.id/api';

  Future<List<CategoryModel>> getCategory() async {
    var url = '$baseUrl/categories';
    var headers = {'Content-Type': 'application/json'};
    var response = await http.get(Uri.parse(url), headers: headers);

    print('${response.statusCode}');
    print('${response.body}');

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];

      List<CategoryModel> category = [];

      print('panjang list = ${data.length}');

      for (int i = data.length - 1; i >= 0; i--) {
        category.add(CategoryModel.fromJson(data[i]));
      }

      //note:tes
      category.map((e) => print(e.name)).toList();

      return category;
    } else {
      throw Exception('get category gagal');
    }
  }
}
