import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_Items.dart';

class OrderScreen extends StatefulWidget {
  static const routName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // this we used to conditioned the loading-circle that if false it will not show and if true it will show
  var _isLoading =false; 

  @override
  void initState() { 
        // this will show loadind circle until fetchAndSetOrders function  is complated
        _isLoading = true; 
       Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((value) {
         setState(() {
        // this will hide loading_circle when above fetchAndSetOrders function is completed 
        _isLoading = false; 
      });
       });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body:_isLoading ? Center(child: Text("No Order Yet!",style: TextStyle(fontSize: 25,color: Colors.grey),),) :  ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
