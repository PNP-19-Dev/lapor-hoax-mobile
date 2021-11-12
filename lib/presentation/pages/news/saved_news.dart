
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/presentation/widget/feed_card.dart';
import 'package:laporhoax/utils/route_observer.dart';
import 'package:provider/provider.dart';

class SavedNews extends StatefulWidget {
  static const String ROUTE_NAME = '/saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> with RouteAware {
  @override
  void initState() {
    context.read<SavedFeedCubit>().fetchSavedFeeds();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<SavedFeedCubit>().fetchSavedFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita yang tersimpan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<SavedFeedCubit, SavedFeedState>(
          builder: (context, state) {
            if (state is SavedFeedLoading) {
              return const Center(
                key: Key('saved_news_loading'),
                child: CircularProgressIndicator(),
              );
            } else if (state is SavedFeedHasData) {
              return ListView.builder(
                key: Key('saved_feed_has_data'),
                itemBuilder: (context, index) {
                  final news = state.feeds;
                  return FeedCard(news[index]);
                },
                itemCount: state.feeds.length,
              );
            } else if (state is SavedFeedEmpty) {
              return Center(
                  key: Key('error_message'), child: Text(state.message));
            } else if (state is SavedFeedError){
              return Center(
                  key: Key('error_message'), child: Text(state.message));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}