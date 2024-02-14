import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreenTest extends StatefulWidget {
  const HomeScreenTest({super.key});

  @override
  State<HomeScreenTest> createState() => _HomeScreenTestState();
}

class _HomeScreenTestState extends State<HomeScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.menu,
            color: Colors.black45,
          ),
          title: Center(child:Text(
            'CineScope'.toUpperCase(),
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
          
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              
              child:const CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),)
            )
          ],
        ),
          
        
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trending Movies',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: 10,  
                  options: CarouselOptions(
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                      const Duration(milliseconds: 800),
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                            ),
                  itemBuilder: (context, itemIndex,pageViewIndex){
                    return Container(
                      height: 300,
                      width: 200,
                      color: Colors.black,
                      
                    );
                  },),
              )
            ]),

        )
        
    );
    
  }


}