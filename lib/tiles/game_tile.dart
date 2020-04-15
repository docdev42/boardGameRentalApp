import 'package:flutter/material.dart';
import 'package:lendsapp/datas/game_data.dart';
import 'package:lendsapp/screens/game_screen.dart';

class GameTile extends StatelessWidget {
  final String type;
  final GameData game;

  GameTile(this.type, this.game);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GameScreen(game))
        );
      },
      child: Card(
        color: Colors.transparent,
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      game.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            game.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text("Complexidade ${game.weight.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 178, 21),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      game.images[0],
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            game.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text("Complexidade ${game.weight.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 178, 21),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
