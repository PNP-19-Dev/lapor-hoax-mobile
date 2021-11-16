/*
 * Created by andii on 16/11/21 22.37
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 17.56
 */

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
  var reports = <Report>[];
  var canClose = false;

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

  Widget _getList(BuildContext context, List<Report> items) {
    List<Report> reports = items;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: reports.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 4,
              child: Slidable(
                key: Key(reports[index].toString()),
                direction: Axis.horizontal,
                endActionPane: ActionPane(
                  motion: BehindMotion(),
                  extentRatio: 0.25,
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      setState(() {
                        // remove item pada report
                        reports.removeAt(index);
                      });
                    },
                    confirmDismiss: () {

                      return context.read<HistoryCubit>().removeReport(
                              widget.tokenId,
                              report.id,
                              report.status!,
                            );
                    },
                    dismissalDuration: Duration(milliseconds: 500),
                    closeOnCancel: true,
                  ),
                  closeThreshold: 0.75,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showSnackBar(context, "Geser untuk ke kiri menghapus");
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      label: 'Hapus',
                    ),
                  ],
                ),
                child: ReportListItem(report: report),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportItem() {
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {
        if (state is HistoryDeleteSomeData) {
          _showSnackBar(context, state.message);
        }
      },
      builder: (_, state) {
        print(state);
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HistoryHasData) {
          return _getList(context, state.reports);
        } else if (state is HistoryError) {
          return Center(
            key: Key('history_page_item_error'),
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
                  '${state.message}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
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
