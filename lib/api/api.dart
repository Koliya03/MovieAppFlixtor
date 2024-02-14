import 'dart:convert';

import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/models/trailer_model.dart';
import 'package:http/http.dart' as http;

class Api{
  static const _trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';
  static const _topRatedUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _upcomingUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';
  
  Future<List<Movie>> getTrendingMovies() async{
    final response = await http.get(Uri.parse(_trendingUrl)); 
    if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getTopRatedMovies() async{
    final response = await http.get(Uri.parse(_topRatedUrl)); 
    if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getUpcomingMovies() async{
    final response = await http.get(Uri.parse(_upcomingUrl)); 
    if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Stream<List<TrailerModel>> getTrailerStream(int movieId) async* {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${Constants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      final trailers = decodedData.map((trailerResult) => TrailerModel.fromJson(trailerResult)).toList();
      yield trailers;
    } else {
      throw Exception("Failed to fetch trailers");
    }
  }
}



