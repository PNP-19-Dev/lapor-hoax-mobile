import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:laporhoax/presentation/widget/report_list_item.dart';
import 'package:laporhoax/utils/navigation.dart';
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
    context.read<HistoryCubit>().getHistory(widget.tokenId);
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _getSlidable(BuildContext context, Report report) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      child: Slidable(
        key: Key(report.id.toString()),
        direction: Axis.horizontal,
        dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) async {
            setState(() {
              // remove item pada report
              context.read<HistoryCubit>().removeReport(widget.tokenId, report.status!);
            });
          },
          onWillDismiss: (actionType) {
            return context.read<HistoryCubit>().removeReport(widget.tokenId, report.status!);
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
            onTap: () {
              _showSnackBar(context, "Geser untuk ke kiri menghapus");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem() {
    var reports = <Report>[];
    return BlocConsumer<HistoryCubit, HistoryState>(listener: (context, state) {
      if (state is HistoryDeleteSomeData){
        reports = state.reports;
        _showSnackBar(context, state.message);
      }

    }, builder: (_, state) {
      print(state);
      if (state is HistoryLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is HistoryHasData) {
        reports = state.reports;
        return LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              itemCount: reports.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _getSlidable(context, report);
              },
            );
          },
        );
      } else if (state is HistoryError) {
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
                'Terjadi masalah ${state.message}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigation.back(),
          icon: Icon(Icons.arrow_back),
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
