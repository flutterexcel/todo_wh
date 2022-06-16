import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../authentication/googleSignIn.dart';

class BarCharts extends StatefulWidget {
  const BarCharts({Key? key}) : super(key: key);

  @override
  State<BarCharts> createState() => _BarChartsState();
}

class _BarChartsState extends State<BarCharts> {
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  late final Stream<QuerySnapshot> _mainStream = FirebaseFirestore.instance
      .collection('tasks')
      .doc(auth.currentUser!.uid)
      .collection('barData')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _mainStream,
        builder: (context, AsyncSnapshot mainSnapshot) {
          if (mainSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (mainSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final barData = mainSnapshot.data!.docs;
          print('barData >> : ${barData.length}');
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFF0932B),
                title: const Text('Todo Bar chart'),
              ),
              body: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 5.0, interval: 1),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    BarSeries<_ChartData, String>(
                        dataSource: createData(barData),
                        xValueMapper: (_ChartData data, _) => data.type,
                        yValueMapper: (_ChartData data, _) => data.val,
                        name: 'Tasks',
                        color: Color.fromARGB(255, 32, 111, 175))
                  ]));
        });
  }
}

class _ChartData {
  _ChartData(this.type, this.val);

  final String type;
  final double val;
}

List<_ChartData> createData(dynamic barData) {
  // List valueList = getValue(barData);
  List<_ChartData> _data = [];
  barData.forEach((e) {
    _data.add(_ChartData(e.get("type"), e.get("value") + .0));
  });
  return _data;
}
