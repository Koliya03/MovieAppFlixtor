import 'dart:convert';
import 'dart:ui';
import 'package:app1/constants.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:http/http.dart' as http;
import 'package:app1/models/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Movie>> moviesList;

  TextEditingController searchController = TextEditingController();
  List<Movie> displayedMovies = [];
  List<Movie> storedMovies = [];
  List<Movie> searchedMovies = [];
  List<Movie> unsortedMovies = [];
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  int currentIndex = 0;
  bool isSorted = false;

  void updateSearchMode() {
    setState(() {
      
      searchController.clear();
      
      displayedMovies = searchedMovies.isNotEmpty ? searchedMovies : unsortedMovies;
      
    });
  }

  Future<List<Movie>> searchMovies(String query) async {
    List<Movie> searchResults = [];

    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&api_key=${Constants.apiKey}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> movies = data['results'] ?? [];
      searchResults.addAll(movies.map((json) => Movie.fromJson(json)).toList());
    } else {
      throw Exception('Failed to search movies');
    }

    return searchResults;
  }

  Future<List<Movie>> fetchAllMovies() async {
    List<Movie> allMovies = [];

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}&page=1'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> movies = data['results'] ?? [];
      allMovies.addAll(movies.map((json) => Movie.fromJson(json)).toList());
    } else {
      throw Exception('Failed to load movies');
    }

    return allMovies;
  }

  @override
  void initState() {
    super.initState();
    moviesList = fetchAllMovies();

    moviesList.then((allMovies) {
      storedMovies = allMovies;
      unsortedMovies = List.from(allMovies); // Make a copy for unsorted movies
      displayedMovies = unsortedMovies;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isSorted = !isSorted;
                      if (isSorted) {
                        unsortedMovies = List.from(displayedMovies); // Store unsorted movies before sorting
                        displayedMovies.sort((a, b) => a.title!.compareTo(b.title!));
                      } else {
                        displayedMovies = unsortedMovies;
                      }

                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSorted ? Colors.green : Colors.grey.shade800,
                  ),
                  child: Text(isSorted ? 'Sorted in alphabetical order' : 'Sort in alphabetical order'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 25),
            child: TextField(
              onChanged: (query) {
                if (query.isEmpty) {
                  setState(() {
                    searchedMovies = [];
                    displayedMovies = unsortedMovies; // Show unsorted movies when query is empty
                  });
                } else {
                  
                    searchMovies(query).then((searchResults) {
                      setState(() {
                        searchedMovies = searchResults;
                        displayedMovies = searchResults;
                        //unsortedMovies = displayedMovies;
                      });
                    });
                  
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Movies',
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Expanded(
            child: displayedMovies.isEmpty
                ? Center(
                    child: Text(
                      'No Results Found :(',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayedMovies.length,
                    itemBuilder: (context, index) => CustomListTile(
                      height: 230,
                      title: Text(
                        displayedMovies[index].title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${displayedMovies[index].releaseDate.toString()}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: Text(
                        '${displayedMovies[index].voteAverage}',
                        style: TextStyle(color: Color.fromARGB(255, 128, 123, 23)),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          displayedMovies[index].posterPath != null
                              ? '${Constants.imagePath}${displayedMovies[index].posterPath!}'
                              : 'https://cdn.dribbble.com/users/1242216/screenshots/9326781/media/6384fef8088782664310666d3b7d4bf2.png',
                          width: 150,
                          height: double.infinity,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://cdn.dribbble.com/users/1242216/screenshots/9326781/media/6384fef8088782664310666d3b7d4bf2.png',
                              width: 150,
                              height: double.infinity,
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      onTap: () async {
                        final Movie selectedMovie = displayedMovies[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetail(clickedMovie: selectedMovie),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Text? title;
  final Text? subtitle;
  final Function? onTap;
  final Widget? trailing;
  final double? height;

  const CustomListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onTap!(),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12, bottom: 12),
                child: leading,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 12.0, top: 50, bottom: 12),
                      child: title ?? const SizedBox(),
                    ),
                    const SizedBox(height: 10),
                    subtitle ?? const SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: trailing,
              )
            ],
          ),
        ),
      ),
    );
  }
}
