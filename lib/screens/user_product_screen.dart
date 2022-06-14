import 'package:flutter/material.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true); // معناها انا اريد الفلترة الآن
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                itemCount: productsData.items.length,
                                itemBuilder: (ctx, int index) {
                                  return Column(
                                    children: [
                                      UserProductItem(productsData.items[index].id, productsData.items[index].title, productsData.items[index].imageUrl),
                                      const Divider(),
                                    ],
                                  );
                                },
                              ),
                            )),
                  ),
      ),
    );
  }
}
