import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lendsapp/datas/cart_game.dart';
import 'package:lendsapp/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;

  List<CartGame> games = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartGame cartGame){
    games.add(cartGame);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartGame.toMap()).then((doc){
      cartGame.cid = doc.documentID; //id gerado pelo firebase quando cria o item no banco
    });

    notifyListeners();
  }

  void removeCartItem(CartGame cartGame){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartGame.cid).delete();

    games.remove(cartGame);

    notifyListeners();
  }

  void decGame(CartGame cartGame){
    cartGame.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartGame.cid).updateData(cartGame.toMap());

    notifyListeners();
  }

  void incGame(CartGame cartGame){
    cartGame.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartGame.cid).updateData(cartGame.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getGamesPrice(){
    double price = 0.0;
    for(CartGame c in games){
      if(c.gameData != null)
        price += c.gameData.price;
    }
    return price;
  }

  double getDiscount(){
    return getGamesPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishOrder() async {
    if(games.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double gamesPrice = getGamesPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientId": user.firebaseUser.uid,
        "games": games.map((cartGame)=>cartGame.toMap()).toList(),
        "shipPrice": shipPrice,
        "gamesPrice": gamesPrice,
        "discount": discount,
        "totalPrice": gamesPrice - discount + shipPrice,
        "status": 1
      }
    );

    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders").document(refOrder.documentID).setData(
        {
          "orderId": refOrder.documentID
        }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    games.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void _loadCartItems() async {

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();
    
    games = query.documents.map((doc) => CartGame.fromDocument(doc)).toList();

    notifyListeners();
  }

}