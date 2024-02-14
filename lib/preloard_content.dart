import 'package:app1/api/api.dart';
import 'package:app1/models/trailer_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreloadContent extends StatefulWidget {
  final int movieId;

  const PreloadContent(this.movieId, {Key? key}) : super(key: key);

  @override
  State<PreloadContent> createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  late Stream<List<TrailerModel>> _trailersStream;

  @override
  void initState() {
    super.initState();
    _trailersStream = Api().getTrailerStream(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _trailersStream,
      builder: (BuildContext context, AsyncSnapshot<List<TrailerModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if(snapshot.hasData){
          return TrailerPage(snapshot);
        }
        else{
          return Text(
            'Did not find a Trailer',
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }
}



class TrailerPage extends StatefulWidget {
  final AsyncSnapshot<List<TrailerModel>> snapshot;

  const TrailerPage(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.of(context).size.width - 16) / 2;

    return GridView.count(
      padding: EdgeInsets.all(0),
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / 155),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: NeverScrollableScrollPhysics(),
      children: List<Widget>.generate(widget.snapshot.data!.length, (index) {
        return GridTile(
          child: InkWell(
            onTap: () => launch("https://www.youtube.com/watch?v=${widget.snapshot.data![index].key}"),
            child: Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Stack(
                    children: <Widget>[
                      Image.network('https://img.youtube.com/vi/Fk4GAsJyZAA/default.jpg'),
                      Container(
                        width: itemWidth,
                        height: 100,
                        color: Colors.black,
                      ),
                      Positioned(
                        top: 36,
                        left: (itemWidth - 36 - 16) / 2,
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 36,
                          color: Colors.white,
                        ),
                      )
                    ],

                  ),
                ),
                Text(
                  widget.snapshot.data![index].name,
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

