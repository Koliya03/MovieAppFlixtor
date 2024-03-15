import 'package:app1/api/api.dart';
import 'package:app1/models/trailer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadTrailer extends StatefulWidget {
  final int movieId;

  const LoadTrailer(this.movieId, {Key? key}) : super(key: key);

  @override
  State<LoadTrailer> createState() => _LoadTrailerState();
}

class _LoadTrailerState extends State<LoadTrailer> {
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
    return GridView.builder(
      padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      physics: BouncingScrollPhysics(),
      itemCount: widget.snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkWell(
            onTap: () => launch("https://www.youtube.com/watch?v=${widget.snapshot.data![index].key}"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children:<Widget>[
                    ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImage(index),
                  
                  ),
                   Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                  ] 
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                  child: Text(
                    widget.snapshot.data![index].name,
                    style: TextStyle(color: Colors.white,),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(int index) {
    String imageUrl = 'https://img.youtube.com/vi/${widget.snapshot.data![index].key}/mqdefault.jpg'; // Using "mqdefault" for medium quality thumbnail
    return Image.network(
      imageUrl,
      height: 120,
      width: double.infinity,
      fit: BoxFit.fitHeight,
      filterQuality: FilterQuality.high,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        }
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        //print(exception);
        return Container(
          color: Colors.grey, // Placeholder color for failed images
          height: 150,
          width: double.infinity,
          child: Center(
            child: Icon(
              Icons.image_not_supported, // Placeholder icon for failed images
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }


}
