import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/result_state.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/report_response.dart';
import 'package:laporhoax/data/model/token_id.dart';
import 'package:laporhoax/presentation/provider/reports_provider.dart';
import 'package:laporhoax/presentation/widget/report_list_item.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history_page';

  final TokenId tokenId;

  HistoryPage({required this.tokenId});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _getSlidable(
      BuildContext context, int index, List<ReportItem> reports) {
    final report = reports[index];
    var provider = Provider.of<ReportsProvider>(
      context,
      listen: false,
    );

    return Slidable(
      key: Key(report.id.toString()),
      direction: Axis.horizontal,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            // remove item pada report
            provider.deleteReport(report.id.toString()).then((value) {
              _showSnackBar(context, 'Delete $value');
              reports.removeAt(index);
            }).onError((error, stackTrace) {
              _showSnackBar(context, 'Delete fail');
            });
          });
        },
        onWillDismiss: (actionType) {
          return report.status.toLowerCase() == 'belum diproses';
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
    return Consumer<ReportsProvider>(builder: (context, provider, widget) {
      if (provider.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (provider.state == ResultState.HasData) {
        var reports = provider.reports.results;
        return ListView.builder(
          itemCount: provider.count,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _getSlidable(context, index, reports);
          },
        );
      } else if (provider.state == ResultState.NoData) {
        return Center(child: Text(provider.message));
      } else {
        toast('Terjadi Masalah');
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
                'Terjadi masalah ${provider.message}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              /*Text(
                'Token: ${provider.token} \nId: ${provider.id}',
                style: Theme.of(context).textTheme.bodyText2,
              ),*/
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
        child: ChangeNotifierProvider<ReportsProvider>(
          create: (_) =>
              ReportsProvider(api: LaporhoaxApi(), tokenId: widget.tokenId),
          child: _buildReportItem(),
        ),
      ),
    );
  }
}
