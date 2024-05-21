import 'package:flutter/material.dart';
import 'package:mywallpapergallery/control/api.dart';
import 'package:mywallpapergallery/model/photosModel.dart';
import 'package:mywallpapergallery/views/image_view.dart';
import 'package:mywallpapergallery/widgets/CustomAppBar.dart';
import 'package:mywallpapergallery/widgets/SearchBar.dart';
import 'package:mywallpapergallery/widgets/catBlock.dart';

class WallpaperCategoryScreen extends StatefulWidget {
  String catName;
  String catImgUrl;

  WallpaperCategoryScreen({super.key, required this.catImgUrl, required this.catName});

  @override
  State<WallpaperCategoryScreen> createState() => _WallpaperCategoryScreenState();
}

class _WallpaperCategoryScreenState extends State<WallpaperCategoryScreen> {
  late List<WallpaperPhotosModel> categoryResults;
  bool isLoading  = true;
  GetCatRelWall() async {
    categoryResults = await WallpaperApiOperations.searchWallpapers(widget.catName);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    GetCatRelWall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: WallpaperCustomAppBar(
          word1: "My Wallpaper",
          word2: "Gallery",
        ),
      ),
      body: isLoading  ? Center(child: CircularProgressIndicator(),)  : SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    widget.catImgUrl),
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black38,
                ),
                Positioned(
                  left: 120,
                  top: 40,
                  child: Column(
                    children: [
                      Text("Category",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w300)),
                      Text(
                        widget.catName,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 700,
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 400,
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 10),
                  itemCount: categoryResults.length,
                  itemBuilder: ((context, index) => GridTile(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                    imgUrl:
                                    categoryResults[index].imgSrc)));
                      },
                      child: Hero(
                        tag: categoryResults[index].imgSrc,
                        child: Container(
                          height: 800,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                height: 800,
                                width: 50,
                                fit: BoxFit.cover,
                                categoryResults[index].imgSrc),
                          ),
                        ),
                      ),
                    ),
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
