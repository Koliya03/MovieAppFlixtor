import 'dart:ui';
import 'package:app1/api/api.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/screens/sampleSearch.dart';
import 'package:app1/screens/seeMoreScreen.dart';
import 'package:app1/widgets/MovieSlider.dart';
import 'package:app1/widgets/Sidebar.dart';
import 'package:app1/widgets/TrendingSlider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isKidMode = false;
  bool _sidebarOpen = false;
  int page = 1;

  String fantasyKidsTitle = 'Fantasy Movies for kids';
  String animatedKidsTitle = 'Animated Movies for Kids';
  String familyKidsTitle = 'Watch with your family';
  String adventureKidsTitle = 'Kids adventure movies';
  String comedyKidsTitle = 'Comedy movies';

  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<List<Movie>> popularMovies;

//for kids movies
late Future<List<Movie>> kidsFantasyMovies;
late Future<List<Movie>> kidsAnimatedMovies;
late Future<List<Movie>> kidsFamilyMovies;
late Future<List<Movie>> kidsAdventureMovies;
late Future<List<Movie>> kidsComedyMovies;


  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies(page);
    topRatedMovies = Api().getTopRatedMovies(page);
    upcomingMovies = Api().getUpcomingMovies(page);
    nowPlayingMovies = Api().getNowPlaying(page);
    popularMovies = Api().getPopular(page);

    kidsFantasyMovies = Api().getfantasyKids(page);
     kidsAnimatedMovies = Api().getAnimationKids(page);
     kidsFamilyMovies = Api().getFamilyKids(page);
     kidsAdventureMovies = Api().adventureKids(page);
     kidsComedyMovies = Api().comedyKids(page);


    // Api().getfantasyKids(page).then((kidsMovies) {
    //   setState(() {
    //     kidsFantasyMovies = kidsMovies;
    //   });
    // }).catchError((error) {
    //   print("Error fetching genres: $error");
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            //backgroundColor: const Color.fromARGB(255, 124, 122, 122),
            backgroundColor: Colors.transparent,
            
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                setState(() {
                  _sidebarOpen = !_sidebarOpen;
                });
              },
              child: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            title:  Text(
              'Flixtor'.toUpperCase(),
              style: TextStyle(color: const Color.fromARGB(115, 255, 253, 253)),
            ),
            centerTitle: true,

            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => SearchPage())
                    );
                  // Add your search functionality here
                },
              ),
            ],


            
            
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Kids Mode',
                      style: TextStyle(fontSize: 15),
                      ),
                    Switch(
                  value: _isKidMode, 
                  onChanged: (mode){
                    setState(() {
                      _isKidMode = mode;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.grey,
                  ),],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      
                      child: Text(
                        _isKidMode ?  familyKidsTitle : 'Trending movies',
                        
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: 
                      ElevatedButton(
                          onPressed: () async {
                         // List<Movie> movies = await topRatedMovies;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                title: _isKidMode ? familyKidsTitle : 'Trending movies',
                                fetchFunction: (page) =>
                                _isKidMode ?   Api().getFamilyKids(page) : Api().getTrendingMovies(page) ,
                              ),
                            ),
                          );
                        },
                           child: Text(
                          'see more',
                          style: GoogleFonts.aBeeZee(fontSize: 15),
                        ),
                           )
                    ),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  child: FutureBuilder(
                    future: _isKidMode ? kidsFamilyMovies : trendingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return TrendingSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _isKidMode ? animatedKidsTitle:'Now Playing movies',
                        
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: //GestureDetector(
                      //   onTap: () async {
                      //    // List<Movie> movies = await topRatedMovies;
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => SeeMoreScreen(
                      //           title: _isKidMode ? animatedKidsTitle:'Now Playing movies',
                      //           fetchFunction: (page) => _isKidMode ? Api().getAnimationKids(page): Api().getNowPlaying(page),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   child: //Text(
                      //     //'see more',
                      //    // style: GoogleFonts.aBeeZee(fontSize: 15),
                      //  // ),
                        ElevatedButton(
                          onPressed: () async {
                         // List<Movie> movies = await topRatedMovies;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                title: _isKidMode ? animatedKidsTitle:'Now Playing movies',
                                fetchFunction: (page) => _isKidMode ? Api().getAnimationKids(page): Api().getNowPlaying(page),
                              ),
                            ),
                          );
                        },
                           child: Text(
                          'see more',
                          style: GoogleFonts.aBeeZee(fontSize: 15),
                        ),
                           )
                      ),
                   // ),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                  const SizedBox(height: 32),
                SizedBox(
                  child: FutureBuilder(
                    future: _isKidMode ? kidsAnimatedMovies : nowPlayingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return MovieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                 const SizedBox(height: 40),
                 Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                       _isKidMode ? fantasyKidsTitle: 'Popular movies',
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: 
                      ElevatedButton(
                          onPressed: () async {
                         // List<Movie> movies = await topRatedMovies;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                title: _isKidMode ? fantasyKidsTitle: 'Popular movies',
                                fetchFunction: (page) => _isKidMode ? Api().getfantasyKids(page):Api().getPopular(page),
                              ),
                            ),
                          );
                        },
                           child: Text(
                          'see more',
                          style: GoogleFonts.aBeeZee(fontSize: 15),
                        ),
                           )
                      
                    ),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                  const SizedBox(height: 32),
                SizedBox(
                  child: FutureBuilder(
                    future:_isKidMode ? kidsFantasyMovies: popularMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return MovieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _isKidMode ? adventureKidsTitle:'Top rated movies',
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: 
                      ElevatedButton(
                          onPressed: () async {
                         // List<Movie> movies = await topRatedMovies;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                                title: _isKidMode ? adventureKidsTitle:'Top rated movies',
                                fetchFunction: (page) => _isKidMode ? Api().adventureKids(page):Api().getTopRatedMovies(page),
                              ),
                            ),
                          );
                        },
                           child: Text(
                          'see more',
                          style: GoogleFonts.aBeeZee(fontSize: 15),
                        ),
                           )
                      
                    ),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                  const SizedBox(height: 32),
                SizedBox(
                  child: FutureBuilder(
                    future:_isKidMode ? kidsAdventureMovies: topRatedMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return MovieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _isKidMode ? comedyKidsTitle:'Upcoming movies',
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: 
                      ElevatedButton(
                          onPressed: () async {
                         // List<Movie> movies = await topRatedMovies;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeeMoreScreen(
                               title: _isKidMode ? comedyKidsTitle:'Upcoming movies',
                                fetchFunction: (page) =>_isKidMode ?Api().comedyKids(page) :Api().getUpcomingMovies(page)
                              ),
                            ),
                          );
                        },
                           child: Text(
                          'see more',
                          style: GoogleFonts.aBeeZee(fontSize: 15),
                        ),
                           )
                    ),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    color: Color.fromARGB(112, 255, 255, 255),
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  child: FutureBuilder(
                    future:_isKidMode ? kidsComedyMovies: upcomingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return MovieSlider(snapshot: snapshot);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_sidebarOpen)
          GestureDetector(
            onTap: () {
              setState(() {
                _sidebarOpen = false;
              });
            },
            child: Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
          ),
        if (_sidebarOpen)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                color: const Color.fromARGB(198, 150, 150, 150), // Lighter color than const Color.fromARGB(198, 0, 0, 0)
                child: Sidebar(
                  onClose: () {
                    setState(() {
                      _sidebarOpen = false;
                    });
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
