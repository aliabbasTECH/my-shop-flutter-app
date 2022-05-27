import 'package:flutter/material.dart';
import 'package:myshop2/providers/Cart.dart' show Cart;
import 'package:myshop2/providers/orders.dart';
import 'package:myshop2/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total"),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    backgroundColor: Colors.purple,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].title),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isloading = false;
  
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isloading ) ? null: () async {
          setState(() {
            _isloading = true;
          });
         await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
          );
          setState(() {
            _isloading = false;
          });
          widget.cart.clear();
        },
        child: _isloading ? CircularProgressIndicator():Text("order Now"));
  }
}
