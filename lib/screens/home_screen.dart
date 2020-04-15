import 'package:flutter/material.dart';
import 'package:lendsapp/tabs/categories_tab.dart';
import 'package:lendsapp/tabs/home_tab.dart';
import 'package:lendsapp/tabs/orders_tab.dart';
import 'package:lendsapp/tabs/places_tab.dart';
import 'package:lendsapp/widgets/cart_button.dart';
import 'package:lendsapp/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 242, 87, 77)
          ),
          drawer: CustomDrawer(_pageController),
          body: CategoriesTab(),
          floatingActionButton: CartButton(),
          backgroundColor: Color.fromARGB(255, 255, 178, 21),
        ),
        Scaffold(
          appBar: AppBar(
              title: Text("Lojas"),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 242, 87, 77)
          ),
          drawer: CustomDrawer(_pageController),
          body: PlacesTab(),
          backgroundColor: Color.fromARGB(255, 255, 178, 21),
        ),
        Scaffold(
          appBar: AppBar(
              title: Text("Meus Pedidos"),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 242, 87, 77)
          ),
          backgroundColor: Color.fromARGB(255, 255, 178, 21),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
