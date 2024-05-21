import 'package:flutter/material.dart';
import 'package:mywallpapergallery/control/api.dart';
import 'package:mywallpapergallery/model/photosModel.dart';
import 'package:mywallpapergallery/views/image_view.dart';
import 'package:mywallpapergallery/widgets/CustomAppBar.dart';
import 'package:mywallpapergallery/widgets/SearchBar.dart';
import 'package:mywallpapergallery/widgets/catBlock.dart';

class WallpaperSearchScreen extends StatefulWidget {
  String query;
  WallpaperSearchScreen({super.key, required this.query});

  @override
  State<WallpaperSearchScreen> createState() => _WallpaperSearchScreenState();
}

class _WallpaperSearchScreenState extends State<WallpaperSearchScreen> {
  late List<WallpaperPhotosModel> searchResults;
  bool isLoading = true;
  GetSearchResults() async {
    searchResults = await WallpaperApiOperations.searchWallpapers(widget.query);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetSearchResults();
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
      body: isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: WallpaperSearchBar()),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 400,
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 10),
                  itemCount: searchResults.length,
                  itemBuilder: ((context, index) => GridTile(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(
                                    imgUrl: searchResults[index].imgSrc)));
                      },
                      child: Hero(
                        tag: searchResults[index].imgSrc,
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
                                searchResults[index].imgSrc),
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
