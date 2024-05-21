import 'package:flutter/material.dart';
import 'package:mywallpapergallery/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  const WallpaperApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'My Wallpaper Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  WallpaperHomeScreen(),
    );
  }
}
