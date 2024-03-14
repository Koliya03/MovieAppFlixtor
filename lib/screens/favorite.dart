import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  const FavoriteMoviesScreen({Key? key}) : super(key: key);

  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isAscendingOrder = true; // Flag to track sorting order

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: Column(
        children: [
           Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAscendingOrder = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAscendingOrder ? Colors.green : null,
                ),
                child: Text('Sort A-Z'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAscendingOrder = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAscendingOrder ? null : Colors.green,
                ),
                child: Text('Sort Z-A'),
              ),
            ],
          ),
          Container(
            height: 20,
          ),

          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user!.uid)
                  .collection('favorites')
                  .orderBy('title', descending: !_isAscendingOrder) // Ordering based on the flag
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No favorite movies found.'));
                } else {
                  List<Movie> favoriteMovies = snapshot.data!.docs.map((doc) {
                    return Movie.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: favoriteMovies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetail(clickedMovie: favoriteMovies[index]),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              '${Constants.imagePath}${favoriteMovies[index].posterPath}',
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
                                      favoriteMovies[index].title,
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
                                              favoriteMovies[index].voteAverage.toString(),
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
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
