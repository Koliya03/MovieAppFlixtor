// Define a class to represent a Movie
class Movie {
  // Properties of a Movie
  String title; // Title of the movie
  String backdropPath; // Path to the backdrop image of the movie
  String originalTitle; // Original title of the movie
  String overview; // Overview or summary of the movie
  String? posterPath; // Path to the poster image of the movie (nullable)
  String releaseDate; // Release date of the movie
  double voteAverage; // Average vote rating of the movie
  double popularity; // Popularity rating of the movie
  int voteCount; // Total count of votes for the movie
  int movieId; // Unique identifier for the movie
  String mediaType; // Type of media (e.g., movie, TV show)
  List<String> genres; // List of genres associated with the movie

  // Constructor for creating a Movie object
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
    required this.mediaType,
  });

  // Factory method to create a Movie object from JSON data
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? '', // Assign the title from JSON or an empty string if null
      backdropPath: json["backdrop_path"] ?? '', // Assign the backdrop path from JSON or an empty string if null
      originalTitle: json["original_title"] ?? '', // Assign the original title from JSON or an empty string if null
      overview: json["overview"] ?? '', // Assign the overview from JSON or an empty string if null
      posterPath: json["poster_path"] ?? '', // Assign the poster path from JSON or null if not available
      releaseDate: json["release_date"] ?? '', // Assign the release date from JSON or an empty string if null
      voteAverage: json["vote_average"] ?? 0, // Assign the vote average from JSON or 0 if not available
      popularity: json["popularity"] ?? 0, // Assign the popularity from JSON or 0 if not available
      voteCount: json["vote_count"] ?? 0, // Assign the vote count from JSON or 0 if not available
      movieId: json["id"] ?? 0, // Assign the movie ID from JSON or 0 if not available
      mediaType: json["media_type"] ?? 'movie', // Assign the media type from JSON or 'movie' if not available
      genres: [], // Initialize genres as an empty list
    );
  }

  // Method to convert a Movie object to JSON format
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
