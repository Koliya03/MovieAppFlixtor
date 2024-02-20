import 'package:app1/constants.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:app1/models/movie.dart';

class SeeMoreScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  SeeMoreScreen({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> MovieDetail(
                      clickedMovie: movies[index])));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  
                  height: 200,
                  width: 200,
                  child: Image.network(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    '${Constants.imagePath}${movies[index].posterPath}',
                  ),
                                  
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

