import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path/path.dart';

class FullScreen extends StatelessWidget {
  String imgUrl;
  FullScreen({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> downloadAndSetWallpaper(String url, BuildContext context) async {
    final filename = basename(url);
    final directory = await Directory('storage/emulated/0/Download').create(recursive: true);
    final file = File('${directory.path}/$filename');

    if (await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("File already exists, skipping download")));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downloading Started...")));

    try {
      final dio = Dio();
      final response = await dio.download(url, file.path, onReceiveProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
        }
      }).whenComplete(() {
        print("Download completed");
      });

      if (response.statusCode == 200) {
        final imageFile = File(file.path);
        final result = await WallpaperManager.setWallpaperFromFile(imageFile.path, WallpaperManager.HOME_SCREEN);

        if (result == 'Wallpaper set') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wallpaper set successfully")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to set wallpaper")));
        }
      }
    } on DioError catch (error) {
      print('Download error: ${error.message}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            await downloadAndSetWallpaper(imgUrl, context);
          },
          child: Text("Set Wallpaper")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imgUrl), fit: BoxFit.cover)),
      ),
    );
  }
}