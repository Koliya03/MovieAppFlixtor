// import 'package:app1/constants.dart';
// import 'package:app1/models/movie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MovieInfo extends StatelessWidget {
//   const MovieInfo({super.key, required this.movie}
//   );

//   final Movie movie;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar.large(
//             leading: Container(
//               height: 70,
//               width:70,
//               margin: const EdgeInsets.only(top: 16,left: 16),
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(198, 0, 0, 0),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: IconButton(
//                 onPressed: (){
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                 ),
//               ),
//             ),
//             backgroundColor:const Color.fromARGB(198, 0, 0, 0), 
//             expandedHeight: 500,
//             pinned: true,
//             floating: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 movie.title,
//                 style: const TextStyle(//GoogleFonts.belleza(
                  
//                   fontWeight :FontWeight.w600,
//                   fontSize: 17
//                 ),
//                 ),
//                 background: Image.network(),
//               )

//           )
//         ],
//       )
//     );
//   }
// }