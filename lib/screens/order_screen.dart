import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;

  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Relizado"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Color.fromARGB(255, 255, 178, 21),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check,
            color: Theme.of(context).primaryColor,
            size: 80.0,
            ),
            Text("Pedido realizado com sucesso!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text("Código do pedido: $orderId", style: TextStyle(fontSize: 16.0))
          ],
        ),
      ),
    );
  }
}
