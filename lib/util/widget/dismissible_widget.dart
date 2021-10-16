import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laporhoax/util/widget/toast.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final String message;
  final Widget child;

  const DismissibleWidget(
    this.message, {
    required this.item,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: child,
        secondaryActions: [
          IconSlideAction(
            caption: 'Hapus',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => toast('status $message'),
          )
        ],
      );
}
