import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewData {
  final id;

  NewsWebViewData(this.id);
}

class NewsWebView extends StatefulWidget {
  static const ROUTE_NAME = '/news_web_view';

  final int id;

  const NewsWebView({required this.id});

  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  void initState() {
    super.initState();
    context.read<DetailCubit>().fetchDetail(widget.id);
    context.read<ItemCubit>().getStatus(widget.id);
  }

  final _key = UniqueKey();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: '${RemoteDataSourceImpl.baseUrl}/news/${widget.id}',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final Widget body;

  CustomScaffold({required this.body});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildShortAppBar(BuildContext context, Feed feed) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(0),
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                'Berita',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Row(
              children: [
                BlocConsumer<ItemCubit, ItemState>(
                  listener: (context, state) {
                    if (state is ItemSaved) {
                      showSnackBar(context, state.message);
                    } else if (state is ItemRemoved) {
                      showSnackBar(context, state.message);
                    }

                    if (state is ItemSaveError) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(state.message),
                            );
                          });
                    }
                  },
                  builder: (context, state) {
                    if (state is ItemIsSave || state is ItemSaved) {
                      return IconButton(
                          onPressed: (){
                            print('unsave tapped!');
                            context.read<ItemCubit>().removeFeed(feed);
                          },
                          icon: Icon(Icons.bookmark, color: orangeBlaze));
                    } else if (state is ItemUnsaved || state is ItemRemoved) {
                      return IconButton(
                        onPressed: () {
                          print('save tapped!');
                          context.read<ItemCubit>().saveFeed(feed);
                        },
                        icon: Icon(Icons.bookmark_outline, color: orangeBlaze),
                      );
                    } else
                      return Container();
                  },
                ),
                IconButton(
                  onPressed: () => Share.share(
                      'Ada berita di laporhoax ${RemoteDataSourceImpl.baseUrl}/pages/${feed.id}'),
                  icon: SvgPicture.asset('assets/icons/share.svg'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailCubit, DetailState>(builder: (context, state) {
        print(state);
        if (state is DetailLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DetailHasData) {
          return SafeArea(
            child: Stack(
              children: [
                body,
                _buildShortAppBar(context, state.data),
              ],
            ),
          );
        } else if (state is DetailError) {
          return Center(child: Text(state.message));
        } else
          return Container();
      }),
    );
  }
}
