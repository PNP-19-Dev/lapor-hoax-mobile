import 'package:flutter/material.dart';
import 'package:laporhoax/common/navigation.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final List<Widget>? children;

  CustomScaffold({required this.body, this.children});

  Widget _buildShortAppBar(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigation.back();
            },
          ),
          Container(
            padding: const EdgeInsets.only(right: 2.0),
            child: Text(
              'Berita',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            child: Row(
              children: children ?? [],
            ),
          ),
        ],
      ),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body,
            _buildShortAppBar(context),
          ],
        ),
      ),
    );
  }
}
