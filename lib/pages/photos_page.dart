import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplashproject/services/http_service.dart';
import 'package:unsplashproject/services/log_service.dart';
import '../models/collection_model.dart';
import '../models/photo_model.dart';
import 'details_page.dart';

class PhotosPage extends StatefulWidget {
  final Collection? collection;
  const PhotosPage({super.key, this.collection});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<Photo> items = [];
  bool iSLoading = false;


  _callDetailsPage(Photo photo) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailsPage(photo: photo);
    }));
  }

  void initState() {
    super.initState();
    _apiCollectionPhotos();
  }
  _apiCollectionPhotos()async{
    setState(() {
      iSLoading = true;
    });
    var response = await Network.GET(Network.API_COLLECTIONS_PHOTOS.replaceFirst(":id", widget.collection!.id), Network.paramsCollectionsPhotos(1));
    LogService.i(response!);
    var result = Network.parseCollectionsPhotos(response);
    setState(() {
      items = result;
      iSLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.collection!.title!,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        
      ),

        body: MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: items.length,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          itemBuilder: (context, index) {
            return _itemOfPhoto(items[index], index);
          },
        )
    );
  }
  Widget _itemOfPhoto(Photo photo, int index) {
    return GestureDetector(
      onTap: () {
        _callDetailsPage(photo);
      },
      child: Container(
        height: (index % 5 + 5) * 50.0,
        child: Stack(
          children: [
            Container(
              height: (index % 5 + 5) * 50.0,
              child: CachedNetworkImage(
                imageUrl: photo.urls.small,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.black12],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    photo.description != null ? photo.description!:"No description",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            iSLoading ? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

}
