import 'dart:convert';

import 'package:app1/constants.dart';
import 'package:app1/models/movie.dart';
import 'package:app1/models/trailer_model.dart';
import 'package:http/http.dart' as http;

class Api{
  Future<List<Movie>> getTrendingMovies(int page) async{
    final String _trendingUrl = 'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}&page=$page';
    final response = await http.get(Uri.parse(_trendingUrl)); 
    if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getTopRatedMovies(int page) async{
    final String  _topRatedUrl = 'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}&page=$page';

    final response = await http.get(Uri.parse(_topRatedUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getUpcomingMovies(page) async{
    final String  _upcomingUrl = 'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}&page=$page';
    final response = await http.get(Uri.parse(_upcomingUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getNowPlaying(page) async{
    final String  _nowPlayingUrl = 'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}&page=$page';
    final response = await http.get(Uri.parse(_nowPlayingUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> getPopular(page) async{
    final String  popularUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=${Constants.apiKey}&page=$page';
    final response = await http.get(Uri.parse(popularUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }


//for kids
 Future<List<Movie>> getfantasyKids(page) async{
  
    final String  fantasyUrl = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=14&page=$page';
    final response = await http.get(Uri.parse(fantasyUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

   Future<List<Movie>> getAnimationKids(page) async{
  
    final String  AnimationUrl = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=16&page=$page';
    final response = await http.get(Uri.parse(AnimationUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }
  Future<List<Movie>> getFamilyKids(page) async{
  
    final String  familyUrl = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=10751&page=$page';
    final response = await http.get(Uri.parse(familyUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> adventureKids(page) async{
  
    final String  adventureUrl = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=12&page=$page';
    final response = await http.get(Uri.parse(adventureUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
      return decodedDate.map((movie)=>Movie.fromJson(movie)).toList();
    }else{
      throw Exception("Something happened");
    }
  }

  Future<List<Movie>> comedyKids(page) async{
  
    final String  comedyUrl = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&with_genres=36&page=$page';
    final response = await http.get(Uri.parse(comedyUrl)); 
     if(response.statusCode == 200){
      final decodedDate = json.decode(response.body)['results'] as List;//
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
  

  static Future<Movie> getfullMovieDetail(int movieId) async {
    final String url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      Movie movie = decodedData.map((movieJson) {
        return Movie.fromJson(movieJson);
      });
      List<dynamic> genresData = decodedData['genres'];
      List<String> genres = genresData.map((genre) => genre['name'].toString()).toList();
      movie.genres = genres;
      
    
      return movie;
    } else {
      throw Exception("Failed to fetch genres");
    }
  }

  static Future<List<String>> getGenres(int movieId) async {
    final String url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      List<dynamic> genresData = decodedData['genres'];
      List<String> genres = genresData.map((genre) => genre['name'].toString()).toList();
      return genres;
    } else {
      throw Exception("Failed to fetch genres");
    }
  }





}



