// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailsScreen.routeName,
                arguments: product.id),
            child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
                ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                      onPressed: () {
                        product.toggleFavoriteStatus(
                            authData.token!, authData.userId!);
                      },
                      icon: Icon(product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added to Cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO!',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('This Item was removed from Washlist!'),
                          duration: Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'Done!',
                            onPressed: () {},
                          )));
                    },
                  ),
                ));
              },
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ));
  }
}
