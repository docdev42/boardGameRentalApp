import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lendsapp/datas/game_data.dart';

class CartGame {

  String cid;

  String category;
  String gid;

  int quantity;
  String expansion;

  double price;

  GameData gameData;

  CartGame();

  CartGame.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    gid = document.data["gid"];
    quantity = document.data["quantity"];
    expansion = document.data["expansion"];
    price = document.data["price"];
  }

  Map<String, dynamic> toMap(){
    return {
      "category": category,
      "gid": gid,
      "quantity": quantity,
      "expansion": expansion,
      "price": price,
      "game": gameData.toResumeMap()
    };
  }

}