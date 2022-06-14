// ignore_for_file: equal_keys_in_map
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProducts) => previousProducts
            ..getData(
                authValue.token!, authValue.userId!, previousProducts.items),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders
            ..getData(
                authValue.token!, authValue.userId!, previousOrders.orders),
        ),
        // ChangeNotifierProvider.value(value: Product()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            //     .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            AuthScreen.routeName: (_) =>  AuthScreen(),
            ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
