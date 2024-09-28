import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/photo_model.dart';

class DetailsPage extends StatefulWidget {
  static const String id = "details_page";
  final Photo? photo;

  const DetailsPage({super.key, this.photo});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.photo!.description != null ? widget.photo!.description!:"No description",
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

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.ios_share,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: widget.photo!.urls.full,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              height: double.infinity,
            ),


            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
