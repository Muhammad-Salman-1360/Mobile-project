class WallpaperPhotosModel {
  String imgSrc;
  String PhotoName;

  WallpaperPhotosModel({required this.PhotoName, required this.imgSrc});

  static WallpaperPhotosModel fromAPI2App(Map<String, dynamic> photoMap) {
    return WallpaperPhotosModel(
        PhotoName: photoMap["photographer"],
        imgSrc: (photoMap["src"])["portrait"]);
  }
}
