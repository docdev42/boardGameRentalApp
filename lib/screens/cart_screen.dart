import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendsapp/models/cart_model.dart';
import 'package:lendsapp/models/user_model.dart';
import 'package:lendsapp/screens/login_screen.dart';
import 'package:lendsapp/screens/order_screen.dart';
import 'package:lendsapp/tiles/cart_tile.dart';
import 'package:lendsapp/widgets/cart_price.dart';
import 'package:lendsapp/widgets/discount_card.dart';
import 'package:lendsapp/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int g = model.games.length;
                return Text(
                  "${g ?? 0} ${g == 1 ? "Item" : "Itens"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 178, 21),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                    size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Faça o login para adicionar jogos",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
          } else if (model.games == null || model.games.length == 0){
            return Center(
              child: Text("Nenhum jogo no carrinho!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.games.map(
                      (game){
                        return CartTile(game);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if(orderId != null)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>OrderScreen(orderId))
                    );
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
