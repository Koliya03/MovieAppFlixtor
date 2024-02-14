
class Movie{
  String title;
  String backdropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage ;
  double popularity ;
  int voteCount;
  int movieId;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.popularity,
    required this.voteCount,
    required this.movieId,
  });

  factory Movie.fromJson(Map<String,dynamic> json){
    return Movie(
      title: json["title"], 
      backdropPath: json["backdrop_path"], 
      originalTitle: json["original_title"], 
      overview: json["overview"], 
      posterPath: json["poster_path"], 
      releaseDate: json["release_date"], 
      voteAverage: json["vote_average"],
      popularity: json["popularity"],
      voteCount:json["vote_count"],
      movieId:json["id"],
    );
  }


}
