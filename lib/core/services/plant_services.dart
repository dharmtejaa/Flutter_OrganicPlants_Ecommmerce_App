import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:organicplants/models/all_plants_model.dart';

// base url for the API
String baseUrl =
    'https://res.cloudinary.com/daqvdhmw8/raw/upload/v1753331364/all_plants_ul7ijl.json';

/// class to get the data from the API
class PlantServices {
  /// function to get the data of all plants
  /// from the API

  static Future<List<AllPlantsModel>> loadAllPlantsApi() async {
    final allPlantsResponse = await http.get(Uri.parse(baseUrl));
    if (allPlantsResponse.statusCode == 200) {
      List<dynamic> allPlantsList = json.decode(allPlantsResponse.body);
      return allPlantsList.map((e) => AllPlantsModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to Load plants data');
    }
  }
}
