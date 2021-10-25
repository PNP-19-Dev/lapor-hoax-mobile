import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/widget/report_list_item.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  static const ROUTE_NAME = '/history_page';

  final TokenId tokenId;

  HistoryPage({required this.tokenId});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReportNotifier>(context, listen: false)
        ..fetchReports(widget.tokenId),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _getSlidable(BuildContext context, int index, List<Report> reports) {
    final report = reports[index];
    var provider = Provider.of<ReportNotifier>(context, listen: false);

    return Slidable(
      key: Key(report.id.toString()),
      direction: Axis.horizontal,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() async {
            // remove item pada report
            provider.removeReport(widget.tokenId, report.id);

            if (provider.postReportState == RequestState.Success) {
              _showSnackBar(context, provider.postReportMessage);
            } else {
              _showSnackBar(context, provider.postReportMessage);
            }
          });
        },
        onWillDismiss: (actionType) {
          return report.status!.toLowerCase() == 'belum diproses';
        },
      ),
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: ReportListItem(report: report),
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

  Widget _buildReportItem() {
    return Consumer<ReportNotifier>(builder: (context, provider, widget) {
      if (provider.fetchReportState == RequestState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (provider.fetchReportState == RequestState.Loaded) {
        var reports = provider.reports;
        return ListView.builder(
          itemCount: reports.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _getSlidable(context, index, reports);
          },
        );
      } else if (provider.fetchReportState == RequestState.Empty) {
        return Center(child: Text(provider.fetchReportMessage));
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 30,
                color: Color(0xFFBDBDBD),
              ),
              Text(
                'Terjadi masalah ${provider.fetchReportMessage}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        );
      }
    });
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
      body: Container(
        child: _buildReportItem(),
      ),
    );
  }
}
