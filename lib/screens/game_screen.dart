import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lendsapp/datas/cart_game.dart';
import 'package:lendsapp/datas/game_data.dart';
import 'package:lendsapp/models/cart_model.dart';
import 'package:lendsapp/models/user_model.dart';
import 'package:lendsapp/screens/cart_screen.dart';
import 'package:lendsapp/screens/login_screen.dart';

class GameScreen extends StatefulWidget {
  final GameData game;

  GameScreen(this.game);

  @override
  _GameScreenState createState() => _GameScreenState(game);
}

class _GameScreenState extends State<GameScreen> {
  final GameData game;

  String expansion;
  bool wantExpansion = false;


  _GameScreenState(this.game);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      backgroundColor: Color.fromARGB(255, 255, 178, 21),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: game.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  game.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "Aluguel: R\$${game.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: game.expansions.isNotEmpty && UserModel.of(context).isLoggedIn() ? <Widget>[
                    Text(
                      "Expansão",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(16.0),),
                    RaisedButton(
                      onPressed: (){
                        setState(() {
                          wantExpansion = true;
                        });
                      },
                      child: Text("Sim",
                        style: TextStyle(fontSize: 18.0),),
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                    Padding(padding: EdgeInsets.all(16.0),),
                    RaisedButton(
                      onPressed: (){
                        setState(() {
                          wantExpansion = false;
                          expansion = null;
                        });
                      },
                      child: Text("Não",
                        style: TextStyle(fontSize: 18.0),),
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                  ] : <Widget>[],
                ),
                Text(
                  wantExpansion ? "Qual?" : "",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  child: wantExpansion ? GridView(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                      ),
                  children: game.expansions.map(
                      (e){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              expansion = e;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color:  e == expansion ? primaryColor : Colors.grey[500],
                                width: 3.0,
                              )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(e),
                          ),
                        );
                      }).toList()
                  ) : null,
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: !wantExpansion || wantExpansion && expansion != null || game.expansions.isEmpty ?
                        (){
                          if(UserModel.of(context).isLoggedIn()){

                            CartGame cartGame = CartGame();
                            cartGame.expansion = expansion;
                            cartGame.price = game.price;
                            cartGame.quantity = 1;
                            cartGame.gid = game.id;
                            cartGame.category = game.category;
                            cartGame.gameData = game;

                            CartModel.of(context).addCartItem(cartGame);
                            
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>CartScreen())
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>LoginScreen())
                            );
                          }
                        } : null,
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho"
                        : "Entre para Adicionar",
                    style: TextStyle(fontSize: 18.0),),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                Divider(),
                Text(
                    "Complexidade ${game.weight.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10.0,),Text(
                  "Jogadores: ${game.min}-${game.max}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Duração: ${game.time} min",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Idade: ${game.age}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  game.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
