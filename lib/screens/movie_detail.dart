import 'dart:ui';

import 'package:app1/api/api.dart';
import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/preloard_content.dart';
//import 'package:app1/screens/widgetTree.dart';
//import 'package:app1/screens/widgetTree.dart';
import 'package:app1/widgets/GenreNameForMovieDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({
    Key? key,
    required this.clickedMovie,
  }) : super(key: key);


  final Movie clickedMovie;
   

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final User? _user = FirebaseAuth.instance.currentUser;
  
  bool isFavorite = false;
  bool isWatchlisted = false;
  List<String> movieGenres = [];
  

  @override
  void initState() {
    super.initState();
    checkFavorites();
   checkWatchlist();
   
   Api.getGenres(widget.clickedMovie.movieId).then((genres) {
      setState(() {
        movieGenres = genres;
      });
    }).catchError((error) {
      print("Error fetching genres: $error");
    });
  }


  Future<void> checkFavorites() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .doc(widget.clickedMovie.title)
          .get();
      setState(() {
        isFavorite = snapshot.exists;
      });
    } catch (e) {
      print('Error checking favorites: $e');
    }
  }

  Future<void> checkWatchlist() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .doc(widget.clickedMovie.title)
          .get();
      setState(() {
        isWatchlisted = snapshot.exists;
      });
    } catch (e) {
      print('Error checking watchlist: $e');
    }
  }

  void toggleFavorite(Movie movie) {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        addToFavorites(movie);
      } else {
        removeFromFavorites(movie);
      }
    });
  }

  void toggleWatchlist(Movie movie) {
    setState(() {
      isWatchlisted = !isWatchlisted;
      if (isWatchlisted) {
        addToWatchlist(movie);
      } else {
        removeFromWatchlist(movie);
      }
    });
  }

  void addToFavorites(Movie movie) {
    try {
      CollectionReference favoritesCollection =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('favorites');
      favoritesCollection.doc(movie.title).set({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overview ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to My Favorites!'),
        ),
      );
      print('Movie added to favorites');
    } catch (e) {
      print('Error adding movie to favorites: $e');
    }
  }



  void addToWatchlist(Movie movie) {
    try {
       CollectionReference watchlistCollection =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid).collection('watchlist');
      watchlistCollection.doc(movie.title).set({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overview ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to watchlist!'),
        ),
      );
      print('Movie added to watchlist');
    } catch (e) {
      print('Error adding movie to watchlist: $e');
    }
  }

  void removeFromFavorites(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('favorites')
          .doc(movie.title)
          .delete();
      
      print('Movie removed from favorites');
    } catch (e) {
      print('Error removing movie from favorites: $e');
    }
  }

  void removeFromWatchlist(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('watchlist')
          .doc(movie.title)
          .delete();
      print('Movie removed from watchlist');
    } catch (e) {
      print('Error removing movie from watchlist: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(198, 0, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                height: 508,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitWidth,
                    alignment: FractionalOffset.center,
                    image: NetworkImage('${Constants.imagePath}${widget.clickedMovie.posterPath}'),
                  ),
                ),
              ),
              Positioned(
                left:20,
                top: 50,
                child: InkWell(
                  onTap: ()=>Navigator.pop(context) ,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right:20,
                top: 50,
                child: InkWell(
                  onTap: ()=>toggleFavorite(widget.clickedMovie) ,
                  child: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              )
              ,
              Positioned(
                top: 430,
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 8),
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.1, 0.3, 0.5, 0.7],
                      colors: [
                        const Color.fromARGB(198, 0, 0, 0).withOpacity(0.1),
                        const Color.fromARGB(198, 0, 0, 0).withOpacity(0.3),
                        const Color.fromARGB(198, 0, 0, 0).withOpacity(0.6),
                        const Color.fromARGB(198, 0, 0, 0).withOpacity(0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 380,
                child: Text(
                  widget.clickedMovie.originalTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Positioned(
                left: 20,
                top: 420,
                child:  
                Container(
                 
                  width: MediaQuery.of(context).size.width-70,
                  child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 12,
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: <Widget>[
                      for(var genre in movieGenres)
                      RowItems(genre:   genre),
                    ]                  
                  ),
                ) ,
              ),
              Positioned(
                top: 460,
                right : 20,
                child: 
                Container(
                            
                   width:  30,
                   height: 120,
          
                  child: Align(
                    alignment: Alignment.topRight,
                   child: InkWell(
                     onTap: ()=>toggleWatchlist(widget.clickedMovie) ,
                     child: Icon(
                        isWatchlisted ? Icons.bookmark_added :Icons.bookmark_add_sharp,
                       // Icons.bookmark,
                        color: isWatchlisted ? Colors.green : Colors.white,
                        size: 50,
                      ),
                    ),
                   ) ,
                            
                            
          
                ),
          
              ),
              Positioned(
                top: 500,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),)
               
                ],
              ),
             // Stack(
              //  children: <Widget>[
                 
               
                 Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                              
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3 ,
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.clickedMovie.popularity.toString(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 65, 241, 71),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const Text(
                                'Popularity',
                                style: TextStyle(
                                  color: Colors.white
                              
                                ),
                              
                              
                              )
                            ],
                          ),
                        ),
                              
                      )
                      ,
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3 ,
                        height: 120,
                              
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.red,
                                size: 28,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: widget.clickedMovie.voteAverage.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' / 10',
                                          style: TextStyle(
                                              color: Colors.white,fontSize: 14
                                          )
                                      )
                                    ]
                              
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                              
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        // color: Colors.yellow,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.clickedMovie.voteCount.toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const Text(
                                'Vote Count',
                                style: TextStyle(
                                    color: Colors.white
                              
                                ),
                              
                              
                              )
                            ],
                          ),
                        ),
                              
                      ),
                     
                              
                     
                    ],
                              
                    )
                  ],),
                 ),
                 
             //   ],
              
              //),
              Stack(
                children: <Widget>[
                  Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: Color.fromARGB(112, 255, 255, 255),
                  
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Text(
                          'Description',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                           ),
                       ],
                    ),
              ),
              
             
              
            ],
          ),
          Text(
                      widget.clickedMovie.overview,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      

              ),
              SizedBox(
                      height: 8,
               ) ,
               Align(
                alignment: Alignment.topLeft,
                 child: Text(
                        'Video Clips',
                        style:TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                  
                        ),
                        ),
               ),
               SizedBox(
                      height: 8,
               ) ,
                Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child:LoadTrailer(widget.clickedMovie.movieId)
                    )


              
            ],
          ),
        ),
      ),
    );
  }
}