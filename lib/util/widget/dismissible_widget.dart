import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final Function() onDismiss;

  const DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismiss,
  }) : super(key: key);

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) => Slidable(
        key: key,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            _showSnackBar(context, 'Deleted');
          },
        ),
        actionExtentRatio: 0.25,
        actionPane: SlidableBehindActionPane(),
        child: child,
        secondaryActions: [
          IconSlideAction(
            caption: 'Hapus',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _showSnackBar(context, "Hello"),
          ),
        ],
      );
}
