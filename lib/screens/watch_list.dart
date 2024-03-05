import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchList extends StatefulWidget {
  const WatchList({Key? key}) : super(key: key);

  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  late Future<List<Movie>> _watchListedMovies;

  @override
  void initState() {
    super.initState();
    _watchListedMovies = _retrieveDataFromFirebase('watchlist');
  }

  Future<List<Movie>> _retrieveDataFromFirebase(String collectionName) async {
    List<Movie> watchListedMovies = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).get();
      setState(() {
        watchListedMovies = snapshot.docs.map((doc)=> Movie.fromJson(doc.data() as Map<String,dynamic>)).toList();
      });
    } catch (e) {
      print('Error retrieving data from Firebase: $e');
    }

    return watchListedMovies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _watchListedMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Movie> watchListMovies = snapshot.data ?? [];
            if (watchListMovies.isEmpty) {
              return Center(child: Text('Your watchlist is empty.'));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Change this value according to your needs
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: watchListMovies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to another page when the movie is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(
                            clickedMovie: watchListMovies[index],
                          ),
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${Constants.imagePath}${watchListMovies[index].posterPath}',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      Positioned(
                        left: 15,
                        bottom: 15,
                        child: Text(
                          watchListMovies[index].title,
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
