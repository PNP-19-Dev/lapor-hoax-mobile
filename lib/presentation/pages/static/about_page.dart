/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';

class About extends StatefulWidget {
  static const String routeName = '/about';

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    super.initState();
    context.read<AboutCubit>().getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Lapor Hoax'),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset('assets/icons/logo_new.png', width: 100),
              SizedBox(height: 10),
              Text('LAPOR HOAX', style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Aplikasi pelaporan hoax yang ditangani langsung oleh pihak yang berwewenang',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/pnp_logo.png',
                    width: 50,
                  ),
                  Image.asset(
                    'assets/icons/polda_sumbar_logo.png',
                    width: 50,
                  ),
                ],
              ),
              SizedBox(height: 50),
              BlocBuilder<AboutCubit, AboutState>(
                builder: (_, state) => InkWell(
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationIcon:
                    Image.asset('assets/icons/logo_new.png', width: 50),
                    applicationName: 'LAPOR HOAX',
                    applicationVersion: state.data,
                  ),
                  child: Text('version ${state.data}',
                    key: Key('about_page_version'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
