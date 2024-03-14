import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/screens/movie_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots_indicator/dots_indicator.dart';

late List<Movie> movieList;

class TrendingSlider extends StatefulWidget {
  const TrendingSlider({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  _TrendingSliderState createState() => _TrendingSliderState();
}

class _TrendingSliderState extends State<TrendingSlider> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
     
      child: Stack(
        children: [
          Column(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                //itemCount: widget.snapshot.data.length,
                itemCount: 18,
                options: CarouselOptions(
                  height: 300,
                  autoPlay: true,
                  viewportFraction: 0.55,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pageSnapping: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, itemIndex, pageViewIndex) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          MovieDetail(
                            clickedMovie: widget.snapshot.data[itemIndex],
                          ),
                          //SearchPage()
                        ),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${Constants.imagePath}${widget.snapshot.data[itemIndex].backdropPath}',
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.fitHeight,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                       // Align(
                         // alignment: Alignment.bottomCenter,
                           Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                widget.snapshot.data[itemIndex].title,
                                style: GoogleFonts.mulish(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        //),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 3,
            child: DotsIndicator(
              dotsCount: 18,
              position: _currentIndex,
              decorator: DotsDecorator(
                size: const Size.square(8.0),
                activeSize: const Size(20.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onTap: (index) {
                setState(() {
                  _currentIndex = index.toInt();
                });
                _controller.animateToPage(index.toInt());
              },
            ),
          ),
        ],
      ),
    );
  }
}
