import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplashproject/pages/details_page.dart';
import 'package:unsplashproject/services/http_service.dart';
import 'package:unsplashproject/services/log_service.dart';

import '../models/photo_model.dart';


class SearchPage extends StatefulWidget {
  static const String id = "search_page";

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Photo> items = [];
  bool isLoading = false;
  int currentPage = 1;
  ScrollController scrollController = ScrollController();

  _callDetailsPage(Photo photo) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailsPage(photo: photo);
    }));
  }

  void initState() {
    super.initState();
    scrollController.addListener((){
      if(scrollController.position.maxScrollExtent <= scrollController.offset){
        currentPage++;
        _apiSearchedPhotos();
      }
    });

    _apiSearchedPhotos();
  }

  _apiSearchedPhotos()async{
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_SEARCH_PHOTOS, Network.paramsSearchPhotos("office", currentPage));
    var result = Network.parseSearchPhotos(response!);
    LogService.i(response);

    setState(() {
      items.addAll(result.results);
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: MasonryGridView.builder(
          controller: scrollController,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: items.length,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          itemBuilder: (context, index) {
            return _itemOfPhoto(items[index], index);
          },
        ));
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
              padding: EdgeInsets.all(10),
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
                    photo.description != null ? photo.description!:"No description available",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    overflow:TextOverflow.ellipsis,
                    maxLines:3,
                  ),
                ],
              ),
            ),
            isLoading ? Center(child: CircularProgressIndicator(),):SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
