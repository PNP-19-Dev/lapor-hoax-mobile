import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/token_id.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/util/widget/dismissible_widget.dart';
import 'package:laporhoax/util/widget/report_list_item.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history_page';

  final TokenId tokenId;

  HistoryPage({required this.tokenId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<UserReport> _reports;

  Future<UserReport> fetchReports(String token, String id) async {
    final client = Dio();
    final api = LaporhoaxApi(client);
    return api.getReport(token, id);
  }

  @override
  initState() {
    super.initState();
    _reports = fetchReports(widget.tokenId.token, widget.tokenId.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigation.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Riwayat',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: FutureBuilder(
        future: _reports,
        builder: (context, AsyncSnapshot<UserReport> snapshot) {
          var state = snapshot.connectionState;
          if (state != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.results.length,
                itemBuilder: (context, index) {
                  var report = snapshot.data!.results[index];
                  return DismissibleWidget<ReportItem>(
                    report.status,
                    item: report,
                    child: ReportListItem(report: report),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 30,
                      color: grey200,
                    ),
                    Text(
                      'Something Went wrong',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text('${snapshot.error}'),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Empty List'));
            }
          }
        },
      ),
    );
  }
}
