import 'package:flutter/material.dart';
import 'package:laporhoax/common/theme.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings_page';

  _buildList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Tema Gelap'),
            trailing: Switch(
              activeColor: orangeBlaze,
              value: false,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
    );
  }
}
