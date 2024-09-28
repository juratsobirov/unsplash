import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unsplashproject/pages/photos_page.dart';
import 'package:unsplashproject/services/http_service.dart';
import 'package:unsplashproject/services/log_service.dart';

import '../models/collection_model.dart';

class CollectionPage extends StatefulWidget {
  static const String id = "collection_page";
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List<Collection> items = [];
  bool isLoading = false;

  _callPhotosPage(Collection collection) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return PhotosPage(collection: collection);
    }));
  }

  @override
  void initState() {
    super.initState();
    _apiCollectionList();
  }
  
  _apiCollectionList()async{
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_COLLECTIONS, Network.paramsCollections(1));
    var result = await Network.parseCollections(response!);
    LogService.i(response);
    setState(() {
      items = result;
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemOfCollection(items[index]);
          }),
    );
  }

  Widget itemOfCollection(Collection collection) {
    return GestureDetector(
      onTap: (){
        _callPhotosPage(collection);
      },
      child: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: collection.coverPhoto.urls.small,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black54,
                    Colors.black12,
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(collection.title, style: TextStyle(color: Colors.white,fontSize: 18),),
                  ],
                ),
              ),
            ),
            isLoading ? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
