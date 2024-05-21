// Import necessary libraries
import 'package:flutter/material.dart';
import 'package:mywallpapergallery/control/api.dart';
import 'package:mywallpapergallery/model/categoryModel.dart';
import 'package:mywallpapergallery/model/photosModel.dart';
import 'package:mywallpapergallery/views/image_view.dart';
import 'package:mywallpapergallery/widgets/CustomAppBar.dart';
import 'package:mywallpapergallery/widgets/SearchBar.dart';
import 'package:mywallpapergallery/widgets/catBlock.dart';

// Define the WallpaperHomeScreen widget
class WallpaperHomeScreen extends StatefulWidget {
  const WallpaperHomeScreen({super.key});

  @override
  State<WallpaperHomeScreen> createState() => _WallpaperHomeScreenState();
}

// Define the state for the WallpaperHomeScreen widget
class _WallpaperHomeScreenState extends State<WallpaperHomeScreen> {
  late List<WallpaperPhotosModel> trendingWallList;
  List<WallpaperCategoryModel> CatModList = [];
  bool isLoading = true;

  // Define a method to get category details
  GetCatDetails() async {
    CatModList = await WallpaperApiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  // Define a method to get trending wallpapers
  GetTrendingWallpapers() async {
    trendingWallList = await WallpaperApiOperations.getTrendingWallpapers();
    setState(() {
      isLoading = false;
    });
  }

  // Initialize the state
  @override
  void initState() {
    GetCatDetails();
    GetTrendingWallpapers();
    super.initState();
  }

  // Build the widget
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
      body:  isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Column(
              children: [
          Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: WallpaperSearchBar()),
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: CatModList!.length,
              itemBuilder: ((context, index) => WallpaperCategoryBlock(
                categoryImgSrc: CatModList![index].catImgUrl,
                categoryName: CatModList![index].catName,
              ))),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 700,
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WallpaperHomeScreen()));
          },
          child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 400,
                  crossAxisCount: 2,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 10),
              itemCount: trendingWallList.length,
              itemBuilder: ((context, index) => GridTile(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreen(
                                imgUrl: trendingWallList[index].imgSrc)));
                  },
                  child: Hero(
                    tag: trendingWallList[index].imgSrc,
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
                            trendingWallList[index].imgSrc),
                      ),
                    ),
                  ),
                ),
              ))),
        ))
        ],
      ),
    ),
    );
  }
}
