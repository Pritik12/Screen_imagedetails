import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List movies = [];
  String query = '';

  Future<void> searchMovies(String searchTerm) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
          ),
          onSubmitted: (value) {
            setState(() {
              query = value;
            });
            searchMovies(query);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index]['show'];
          return ListTile(
            leading: Image.network(
              movie['image'] != null ? movie['image']['medium'] : '',
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(movie['name'],
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              movie['summary'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
