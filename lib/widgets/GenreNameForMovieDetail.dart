import 'package:flutter/material.dart';

class RowItems extends StatelessWidget {
  final String genre;
  const RowItems({
    Key? key,
    required this.genre,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, 
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjusted padding
          child: Text(genre),
        ),
      ],
    );
  }
}
