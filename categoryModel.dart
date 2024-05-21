class WallpaperCategoryModel {
  String catName;
  String catImgUrl;


  WallpaperCategoryModel({required this.catName, required this.catImgUrl});

  static WallpaperCategoryModel fromAPI2App(Map<String, dynamic> photoMap) {
    return WallpaperCategoryModel(
        catName: photoMap["photographer"],
        catImgUrl: (photoMap["src"])["portrait"]);
  }
}
