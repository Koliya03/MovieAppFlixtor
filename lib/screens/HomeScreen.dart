import 'package:app1/models/movie.dart';
import 'package:app1/widgets/MovieSlider.dart';
import 'package:app1/widgets/TrendingSlider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app1/api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> { //with  TickerProviderStateMixin{
  int uval = 1;
  
late Future<List<Movie>> trendingMovies;
late Future<List<Movie>> topRatedMovies;
late Future<List<Movie>> upcomingMovies;
 
@override
  void initState(){
  super.initState();
  trendingMovies = Api().getTrendingMovies();
  topRatedMovies = Api().getTopRatedMovies();
  upcomingMovies = Api().getUpcomingMovies();
  
}
  @override
  Widget build(BuildContext context) {
     
   // TabController _tabController = TabController(length: 2, vsync: this); 

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.menu,
            color: Colors.black45,
          ),
          title: Text(
            'Movies-db'.toUpperCase(),
            style: const TextStyle(
              color: Colors.black45
            ),
          ),
        ),
          
        
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           // children: <Widget>[
             // Row(
                children: [
                  const Text(
                'Trending Movies',
                style: TextStyle(fontSize: 25),
              ),
              //TextButton(onPressed: onPressed, child: child)
              
              //],
                
              

              //),
              
              const SizedBox(height: 32),
               SizedBox(
                child:FutureBuilder(
                  future: trendingMovies,
                  builder:(context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                        );
                        
                    }
                    else if(snapshot.hasData){
              
                      return  TrendingSlider(snapshot: snapshot ,);
                    }else{
                      return const Center(child: CircularProgressIndicator());

                    }
                  } ,
                ),
              ),
              const SizedBox(height: 32,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Top rated movies',
                      style: GoogleFonts.aBeeZee(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Adjust the spacing as needed
                    child: Text(
                      'see more',
                      style: GoogleFonts.aBeeZee(fontSize: 15),
                    ),
                  ),
                ],
              ),

              
             // Text('Top rated movies',style: GoogleFonts.aBeeZee(fontSize: 25),),
              SizedBox(
                child:FutureBuilder(
                  future: topRatedMovies,
                  builder:(context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                        );
                        
                    }
                    else if(snapshot.hasData){
              
                      return  MovieSlider(snapshot: snapshot ,);
                    }else{
                      return const Center(child: CircularProgressIndicator());

                    }
                  } ,
                ),
              ),
              const SizedBox(height: 32,),
              Text('Upcoming  movies',style: GoogleFonts.aBeeZee(fontSize: 25),),
              const SizedBox(height: 32,),
              SizedBox(
                child:FutureBuilder(
                  future: upcomingMovies,
                  builder:(context, snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                        );
                        
                    }
                    else if(snapshot.hasData){
              
                      return  MovieSlider(snapshot: snapshot ,);
                    }else{
                      return const Center(child: CircularProgressIndicator());

                    }
                  } ,
                ),
              ),

            ]),

        )
        
    );
    
  }


}



