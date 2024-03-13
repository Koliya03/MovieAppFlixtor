import 'package:app1/constants.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieSlider extends StatelessWidget {
  const MovieSlider({
    super.key, required this.snapshot,
  });
  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> MovieDetail(
                      clickedMovie: snapshot.data[index])));
              },
              child: Stack(
                children: [
                  ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    
                    height: 200,
                    width: 200,
                    child: Image.network(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      '${Constants.imagePath}${snapshot.data![index].posterPath}',
                    ),
                                    
                  ),
                ),
                Positioned(
                 bottom: 0,
                  left: 0,
                   right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      // padding: EdgeInsets.only(left: 2),
                          child: Column(
                            children: [
                              Text(
                                snapshot.data[index].title,
                                style: GoogleFonts.mulish(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                 ),
                                 textAlign: TextAlign.center,
                                 overflow: TextOverflow.ellipsis,
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
                          '${snapshot.data[index].voteAverage}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                            ],
                          ),
                            ]
                ),
                
              ),
              
            ),
                ])) 
          );
        },
      ),
    );
  }
}