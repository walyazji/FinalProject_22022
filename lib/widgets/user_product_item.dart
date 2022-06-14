// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id),
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    const SnackBar(
                        content: Text(
                      'Deleting Failed!',
                      textAlign: TextAlign.center,
                    )
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
              icon: const Icon(Icons.delete)),
        ]),
      ),
    );
  }
}
