// Import necessary libraries
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mywallpapergallery/model/categoryModel.dart';
import 'package:mywallpapergallery/model/photosModel.dart';
import 'dart:math';

// Define the WallpaperApiOperations class
class WallpaperApiOperations {
  // Define static lists to store wallpapers and categories
  static List<WallpaperPhotosModel> trendingWallpapers = [];
  static List<WallpaperPhotosModel> searchWallpapersList = [];
  static List<WallpaperCategoryModel> categoryModelList = [];

  // Define the API key
  static String _apiKey =
      "hPosrUuALggaxzWlrKs0ZoYOyIg00B3hkTdbUyOViOSP42UWV5KV0mCl";

  // Define a method to get trending wallpapers
  static Future<List<WallpaperPhotosModel>> getTrendingWallpapers() async {
    try {
      // Make a GET request to the API
      final response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated"),
        headers: {"Authorization": "$_apiKey"},
      );

      // If the request is successful...
      if (response.statusCode == 200) {
        // Decode the JSON data
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // For each photo in the data...
        jsonData['photos'].forEach((element) {
          // Add the photo to the trending wallpapers list
          trendingWallpapers.add(WallpaperPhotosModel.fromAPI2App(element));
        });
      } else {
        // If the request failed, throw an exception
        throw Exception('Failed to load wallpapers');
      }
    } catch (e) {
      // If an error occurred, print it
      print(e.toString());
    }

    // Return the list of trending wallpapers
    return trendingWallpapers;
  }

  // Define a method to search wallpapers based on a query
  static Future<List<WallpaperPhotosModel>> searchWallpapers(
      String query) async {
    try {
      // Make a GET request to the API with the search query
      final response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {"Authorization": "$_apiKey"},
      );

      // If the request is successful...
      if (response.statusCode == 200) {
        // Decode the JSON data
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Clear the previous search results
        searchWallpapersList.clear();
        // For each photo in the data...
        jsonData['photos'].forEach((element) {
          // Add the photo to the search wallpapers list
          searchWallpapersList.add(WallpaperPhotosModel.fromAPI2App(element));
        });
      } else {
        // If the request failed, throw an exception
        throw Exception('Failed to search wallpapers');
      }
    } catch (e) {
      // If an error occurred, print it
      print(e.toString());
    }

    // Return the list of search wallpapers
    return searchWallpapersList;
  }

  // Define a method to get categories list
  static Future<List<WallpaperCategoryModel>> getCategoriesList() async {
    // Define a list of category names
    List categoryName = [
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers"
    ];
    // Clear the previous categories list
    categoryModelList.clear();
    // For each category name...
    for (var catName in categoryName) {
      // Create a random number generator
      final _random = new Random();
      // Get a random photo from the search results
      WallpaperPhotosModel photoModel =
          (await searchWallpapers(catName))[0 + _random.nextInt(11 - 0)];
      // Add the category to the categories list
      categoryModelList.add(WallpaperCategoryModel(
          catImgUrl: photoModel.imgSrc, catName: catName));
    }

    // Return the list of categories
    return categoryModelList;
  }
}
