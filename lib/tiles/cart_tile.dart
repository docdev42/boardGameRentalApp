import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lendsapp/datas/cart_game.dart';
import 'package:lendsapp/datas/game_data.dart';
import 'package:lendsapp/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartGame cartGame;

  CartTile(this.cartGame);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartGame.gameData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartGame.gameData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                      cartGame.gameData.expansions.isNotEmpty? "Expanção: ${cartGame.expansion}" : "",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$${cartGame.gameData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartGame.quantity > 1 ? (){
                              CartModel.of(context).decGame(cartGame);
                            } : null,
                      ),
                      Text(cartGame.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incGame(cartGame);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartGame);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartGame.gameData == null ?
      FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("games").document(cartGame.category).collection("items").document(cartGame.gid).get(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            cartGame.gameData = GameData.fromDocument(snapshot.data);
            return _buildContent();
          } else {
            return Container(
              height: 70.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },
      ) : _buildContent()
    );
  }
}
