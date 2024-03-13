import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('watchlist')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No movies in watchlist.'));
          } else {
            List<Movie> watchlistMovies = snapshot.data!.docs.map((doc) {
              return Movie.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: watchlistMovies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(clickedMovie: watchlistMovies[index]),
                      ),
                    );
                  },
                  child:  Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      '${Constants.imagePath}${watchlistMovies[index].posterPath}',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                         color: Colors.black.withOpacity(0.5),
                        child: Column(
                          children: [
                            Text(
                             watchlistMovies[index].title,
                              style: GoogleFonts.mulish(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                 ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,  
                              maxLines: 2,
                            ),
                            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          watchlistMovies[index].voteAverage.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                            ],
                          ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                );
              },
            );
          }
        },
      ),
    );
  }
}
