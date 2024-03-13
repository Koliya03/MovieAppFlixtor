import 'package:flutter/material.dart';
import 'package:app1/models/movie.dart';
//import 'package:app1/api/api.dart';
import 'package:app1/constants.dart';
import 'package:app1/screens/movie_detail.dart';

class SeeMoreScreen extends StatefulWidget {
  final String title;
  final Function(int) fetchFunction;

  SeeMoreScreen({required this.title, required this.fetchFunction});

  @override
  _SeeMoreScreenState createState() => _SeeMoreScreenState();
}

class _SeeMoreScreenState extends State<SeeMoreScreen> {
  late ScrollController _scrollController;
  late List<Movie> _movies;
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _movies = [];
    _fetchMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _fetchMovies();
    }
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<Movie> newMovies =
          await widget.fetchFunction(_currentPage);
      setState(() {
        _movies.addAll(newMovies);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(
                      clickedMovie: _movies[index],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(
                    '${Constants.imagePath}${_movies[index].posterPath}',
                    fit: BoxFit.cover,
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
