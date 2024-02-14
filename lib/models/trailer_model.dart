
class TrailerModel{
  String key;
  String name;


  TrailerModel({
    required this.key,
    required this.name,
  });

  factory TrailerModel.fromJson(Map<String,dynamic> json){
    return TrailerModel(
      key: json["key"], 
      name: json["name"], 
      
    );

  }


}
