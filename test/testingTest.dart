import 'package:app1/api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app1/models/movie.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Api Tests', () {
    late Api api;
    late MockClient client;

    setUp(() {
      client = MockClient();
      api = Api();
    });

    test('Test getTrendingMovies', () async {
      when(client.get(Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=cd335d8624acd3729b41a640e5c0c783'))).thenAnswer((_) async => http.Response(json.encode({'results': []}), 200));
      
      final movies = await api.getTrendingMovies(1);

      expect(movies, isInstanceOf<List<Movie>>());
      expect(movies.length, equals(0));
    });

    test('Test getTopRatedMovies', () async {
      when(client.get(Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=cd335d8624acd3729b41a640e5c0c783'))).thenAnswer((_) async => http.Response(json.encode({'results': []}), 200));
      
      final movies = await api.getTopRatedMovies(1);

      expect(movies, isInstanceOf<List<Movie>>());
      expect(movies.length, equals(0));
    });

    // Write similar tests for other API functions
  });
}