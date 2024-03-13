


class Movie{
  String title;
  String backdropPath;
  String originalTitle;
  String overview;
  String? posterPath;
  String releaseDate;
  double voteAverage ;
  double popularity ;
  int voteCount;
  int movieId;
  String mediaType;
  List<String> genres;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.popularity,
    required this.voteCount,
    required this.movieId,
    required this.genres,
    required this.mediaType
  });

  factory Movie.fromJson(Map<String,dynamic> json){

    return Movie(
      title: json["title"] ?? '', 
      backdropPath: json["backdrop_path"] ?? '', 
      originalTitle: json["original_title"] ?? '', 
      overview: json["overview"] ?? '', 
      posterPath: json["poster_path"] ?? '', 
      releaseDate: json["release_date"] ?? '', 
      voteAverage: json["vote_average"] ?? 0,
      popularity: json["popularity"] ?? 0,
      voteCount:json["vote_count"] ?? 0,
      movieId:json["id"] ?? 0,
      mediaType :json["media_type"] ?? 'movie',
      genres: [],
      
    );

  }
  Map<String, dynamic> toJson() {
    
    return {
      'title': title,
      'backdrop_path': backdropPath,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'popularity': popularity,
      'vote_count': voteCount,
      'id': movieId,
    };
  }


}
