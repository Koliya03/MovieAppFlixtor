import 'package:app1/models/movie.dart';
import 'package:epawelaflutter/colors.dart';
import 'package:flutter/material.dart';
import 'package:epawelaflutter/models/movie.dart';
import 'package:epawelaflutter/widgets/backButton.dart';
import 'package:epawelaflutter/widgets/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class detailScreen extends StatefulWidget {
  const detailScreen({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
  bool isFavorite = false;
  bool isWatchlisted = false;

  @override
  void initState() {
    super.initState();
    checkFavorites();
    checkWatchlist();
  }

  void checkFavorites() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('title', isEqualTo: widget.movie.title)
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
          .where('title', isEqualTo: widget.movie.title)
          .get();
      setState(() {
        isWatchlisted = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking watchlist: $e');
    }
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        addToFavorites(widget.movie);
      } else {
        removeFromFavorites(widget.movie);
      }
    });
  }

  void toggleWatchlist() {
    setState(() {
      isWatchlisted = !isWatchlisted;
      if (isWatchlisted) {
        addToWatchlist(widget.movie);
      } else {
        removeFromWatchlist(widget.movie);
      }
    });
  }

  void addToFavorites(Movie movie) {
    try {
      CollectionReference favoritesCollection =
          FirebaseFirestore.instance.collection('favorites');
      favoritesCollection.add({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overView ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
      print('Movie added to favorites');
    } catch (e) {
      print('Error adding movie to favorites: $e');
    }
  }

  void addToWatchlist(Movie movie) {
    try {
      CollectionReference watchlistCollection =
          FirebaseFirestore.instance.collection('watchlist');
      watchlistCollection.add({
        'title': movie.title ?? '',
        'backdrop_path': movie.backdropPath ?? '',
        'original_title': movie.originalTitle ?? '',
        'overview': movie.overView ?? '',
        'poster_path': movie.posterPath ?? '',
        'release_date': movie.releaseDate ?? '',
        'vote_average': movie.voteAverage ?? 0.0,
      });
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
        snapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const backButton(),
            backgroundColor: Colours.scaffoldBgColor,
            expandedHeight: 500,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: GoogleFonts.belleza(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  '${Constants.imagePath}${widget.movie.posterPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 8,
                    right: 8,
                  ),
                  child: IconButton(
                    onPressed: toggleWatchlist,
                    icon: Icon(
                      Icons.bookmark,
                      color: isWatchlisted ? Colors.blue : Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                  right: 8,
                ),
                child: IconButton(
                  onPressed: toggleFavorite,
                  icon: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.movie.overView,
                    style: GoogleFonts.cabin(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Released date: ',
                              style: GoogleFonts.cabin(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.movie.releaseDate,
                              style: GoogleFonts.cabin(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Rating',
                              style: GoogleFonts.cabin(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}











void addToFavorite(BuildContext context) async {
  try {
    final CollectionReference moviesCollection =
        FirebaseFirestore.instance.collection('movies');

    // Check if the movie already exists in Firestore
    final QuerySnapshot existingMovies = await moviesCollection
        .where('movieId', isEqualTo: clickedMovie.movieId)
        .get();

    if (existingMovies.docs.isEmpty) {
      // Movie does not exist, add it to Firestore
      await moviesCollection.add(clickedMovie.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to favorites!'),
        ),
      );
    } else {
      // Movie already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie already exists in favorites!'),
        ),
      );
    }
  } catch (e) {
    print('Error adding movie to favorites: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding movie to favorites'),
      ),
    );
  }
}