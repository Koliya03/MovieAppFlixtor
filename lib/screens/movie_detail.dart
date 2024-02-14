import 'dart:ui';

import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/preloard_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({
    Key? key,
    required this.clickedMovie,
  }) : super(key: key);

  final Movie clickedMovie;

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
                  image: NetworkImage('${Constants.imagePath}${clickedMovie.posterPath}'),
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
                onTap: ()=>print("") ,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
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
              top: 420,
              child: Text(
                clickedMovie.originalTitle,
                style: const TextStyle(color: Colors.white, fontSize: 20),
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
                          width: (MediaQuery.of(context).size.width - 40) / 3,
                          height: 120,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  clickedMovie.popularity.toString(),
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
                          width: (MediaQuery.of(context).size.width - 40) / 3,
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
                                      text: clickedMovie.voteAverage.toString(),
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
                                  clickedMovie.voteCount.toString(),
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

                        )
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
                      clickedMovie.overview,
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
                      child:PreloadContent(clickedMovie.movieId)
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
