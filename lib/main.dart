import 'package:flutter/material.dart';
import 'package:unsplashproject/pages/collection_page.dart';
import 'package:unsplashproject/pages/details_page.dart';
import 'package:unsplashproject/pages/home_page.dart';
import 'package:unsplashproject/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
      routes: {
        HomePage.id: (context) =>HomePage(),
        SearchPage.id: (context) =>SearchPage(),
        CollectionPage.id: (context) =>CollectionPage(),
        DetailsPage.id: (context) =>DetailsPage(),
      },
    );
  }
}
