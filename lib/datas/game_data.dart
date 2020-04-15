import 'package:cloud_firestore/cloud_firestore.dart';

class GameData {

  String category;
  String id;

  String title;
  String description;

  int age;
  int min;
  int max;
  int time;

  double weight;
  double price;

  List expansions;
  List images;

  GameData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    age = snapshot.data["age"];
    min = snapshot.data["min"];
    max = snapshot.data["max"];
    time = snapshot.data["time"];
    weight = snapshot.data["weight"];
    price = snapshot.data["price"];
    expansions = snapshot.data["expansions"];
    images = snapshot.data["images"];
  }

  Map<String, dynamic> toResumeMap(){
    return {
      "title": title,
      "price": price,
    };
  }

}