import 'dart:ui';

import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/preloard_content.dart';
//import 'package:app1/screens/widgetTree.dart';
//import 'package:app1/screens/widgetTree.dart';
import 'package:app1/widgets/GenreNameForMovieDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieDetailNOnWindows extends StatefulWidget {
  const MovieDetailNOnWindows({
    Key? key,
    required this.clickedMovie,
  }) : super(key: key);


  final Movie clickedMovie;
   

  @override
  State<MovieDetailNOnWindows> createState() => _MovieDetailNOnWindowsState();
}

class _MovieDetailNOnWindowsState extends State<MovieDetailNOnWindows> {
  bool isFavorite = false;
  bool isWatchlisted = false;
  List<String> movieGenres = [];
  

  @override
  void initState() {
    super.initState();
    checkFavorites();
   checkWatchlist();
   movieGenres = widget.clickedMovie.genres;
  }


  void checkFavorites() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('title', isEqualTo: widget.clickedMovie.title)
          .get();
      setState(() {
        isFavorite = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking favorites: $e');
    }
  }

   void checkWatchlist() async {
   try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('watchlist')
          .where('title', isEqualTo: widget.clickedMovie.title)
          .get();
      setState(() {
        isWatchlisted = snapshot.docs.isNotEmpty;
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
          FirebaseFirestore.instance.collection('favorites');
     favoritesCollection.add(movie.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to favorites!'),
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
          FirebaseFirestore.instance.collection('watchlist');
      watchlistCollection.add(movie.toJson());
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
          .collection('favorites')
          .where('title', isEqualTo: movie.title)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      print('Movie removed from favorites');
    } catch (e) {
      print('Error removing movie from favorites: $e');
    }
  }

  void removeFromWatchlist(Movie movie) {
    try {
      FirebaseFirestore.instance
          .collection('watchlist')
          .where('title', isEqualTo: movie.title)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
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
        child: Stack(
          children: <Widget>[
            Container(
              height: 500,
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
                  alignment: Alignment.topCenter,
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
            //genres
           
           Positioned(
            top : 500,
            child: Container(
              width: MediaQuery.of(context).size.width ,
              height : MediaQuery.of(context).size.height - 500,
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  color: Color.fromARGB(112, 255, 255, 255),
                ),
                Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: SingleChildScrollView(
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
              ),
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
                    SizedBox(
                      height: 8,
                    )
                    ,
                    Text(
                      widget.clickedMovie.overview,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Trailers',
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,

                      ),
                      ),
                       SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child:PreloadContent(widget.clickedMovie.movieId)
                    )
                    
                  ],


                ),
              ),


                ],
                ),
              ),
            )
           ),

          


          ],
        ),
      ),
    );
  }
}