// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem
      order; //لو ما حطينا ال اورد هيفكر بقصد نفس الكلاس يلي انا فيه

  const OrderItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm').format(order.dateTime)),
        children: order.products
            .map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(prod.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${prod.quantity}x \$${prod.price}',
                        style: const TextStyle(fontSize: 18, color: Colors.grey))
                  ],
                ))
            .toList(),
      ),
    );
  }
}
