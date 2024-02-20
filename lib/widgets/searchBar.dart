import 'package:app1/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchBarFunc extends StatefulWidget {
  const SearchBarFunc({Key? key}) : super(key: key);

  @override
  State<SearchBarFunc> createState() => _SearchBarFuncState();
}

class _SearchBarFuncState extends State<SearchBarFunc> {
  List<Map<String, dynamic>> searchResult = [];
  final TextEditingController searchText = TextEditingController();
  bool showList = false;
  var val1;

  Future<void> searchListFunction(String val) async {
    var searchUrl = 'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val1';
    var searchResponse = await http.get(Uri.parse(searchUrl));
    if (searchResponse.statusCode == 200) {
      var data = jsonDecode(searchResponse.body);
      var searchJson = data['results'];

      for (var item in searchJson) {
        if (item['id'] != null &&
            item['poster_path'] != null &&
            item['vote_average'] != null &&
            item['media_type'] != null &&
            ((item['media_type'] == 'tv' || item['media_type'] == 'movie') && item['poster_path'] != null) ||
            (item['media_type'] == 'person' && item['profile_path'] != null)) {
          searchResult.add({
            'id': item['id'],
            'poster_path': item['poster_path'],
            'profile_path': item['profile_path'],
            'vote_average': item['vote_average'],
            'media_type': item['media_type'],
            'popularity': item['popularity'],
            'overview': item['overview'],
            'name': item['name'],
          });

          if (searchResult.length > 20) {
            searchResult.removeRange(20, searchResult.length);
          }
        } else {
          print('Null value found');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList = !showList;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                autofocus: false,
                controller: searchText,
                onSubmitted: (value) {
                  searchResult.clear();
                  setState(() {
                    val1 = value;
                  });
                },
                onChanged: (value) {
                  searchResult.clear();
                  setState(() {
                    val1 = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "Search Cleared",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        searchText.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.amber.withOpacity(0.6),
                    ),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.amber,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            if (searchText.text.length > 0)
              FutureBuilder(
                future: searchListFunction(val1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: searchResult.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            // onTap: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => Descriptioncheckui(
                            //         searchResult[index]['id'],
                            //         searchResult[index]['media_type'],
                            //       ),
                            //     ),
                            //   );
                            // },
                            child: Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(20, 20, 20, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          (searchResult[index]['media_type'] == 'tv' ||
                                                  searchResult[index]['media_type'] == 'movie')
                                              ? 'https://image.tmdb.org/t/p/w500${searchResult[index]['poster_path']}'
                                              : 'https://image.tmdb.org/t/p/w200/${searchResult[index]['profile_path']}',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              '${searchResult[index]['media_type']}',
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber.withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(6)),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          '${searchResult[index]['vote_average']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context).size.width *0.2,
                                                  height: 30,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber.withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.people_outline_sharp,
                                                        color: Colors.amber,
                                                        size: 10,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            '${searchResult[index]['popularity']}',
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width *0.4,
                                            height: 85,
                                            child: (searchResult[index]['media_type'] == 'tv' ||
                                                    searchResult[index]['media_type'] == 'movie')
                                                ? Text(
                                                    '${searchResult[index]['overview']}',
                                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                                  )
                                                : Text(
                                                    '${searchResult[index]['name']}',
                                                    style: TextStyle(fontSize: 25, color: Colors.white),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(color: Colors.amber));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}