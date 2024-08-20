import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final String query;

  const SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Center(
        child: Text(
          'Results for "$query"',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
