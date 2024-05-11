import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/screen/main/drawer/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../api/firestore_db_service.dart';
import '../../generated/assets.dart';
import '../../model/todo.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';

class ManagerMainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ManagerMainScreenState();
  }
  
}
class ManagerMainScreenState extends State<ManagerMainScreen>{

  final TextEditingController _textEditingController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();
  DateTime timeBackPressed = DateTime.now();
  late List<CatChartData> chartData;
  num totalValue = 0;
  @override
  void initState() {
    chartData = [
      CatChartData('Persian', 15000),
      CatChartData('Munchkin', 25000),
      CatChartData('Billy', 5000),
      CatChartData('Scottish fold', 50000),
      CatChartData('Himalayan', 10000),
    ];
    for (var element in chartData) {
      totalValue += element.total;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_PRIMARY,
          iconTheme: IconThemeData(color: WHITE),
          title: Text("Tillo Textil 24", style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),),
        ),
        body: SfCircularChart(
            legend: Legend(
              overflowMode: LegendItemOverflowMode.wrap,
              isVisible: true,
              legendItemBuilder: (String legendText, dynamic series,
                  dynamic point, int seriesIndex) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 125,
                    child: Row(
                      children: [
                        Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: series.renderPoints[point.index].color,
                          ),
                          margin: const EdgeInsets.only(right: 8.0),
                        ),
                        Text(
                          '$legendText ${(point.y / (totalValue / 100)).round()}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            series: [
              PieSeries<CatChartData, String>(
                  animationDuration: 700,
                  dataSource: chartData,
                  radius: '50%',
                  explode: true,
                  explodeGesture: ActivationMode.singleTap,
                  xValueMapper: (CatChartData data, _) => data.category,
                  yValueMapper: (CatChartData data, _) => data.total,
                  dataLabelMapper: (CatChartData data, _) => data.category,
                  sortingOrder: SortingOrder.descending,
                  legendIconType: LegendIconType.circle,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return Text(
                        data.category +
                            ' ${(data.total / (totalValue / 100)).round()}' +
                            '%',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                    connectorLineSettings:
                    const ConnectorLineSettings(type: ConnectorType.curve),
                    overflowMode: OverflowMode.shift,
                    showZeroValue: false,
                    labelPosition: ChartDataLabelPosition.outside,
                  ))
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: _displayTextInputDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        drawer: DrawerScreen(),
      ),
    );
  }
  Future<bool> _onWillPop() {
    final differeance = DateTime.now().difference(timeBackPressed);
    timeBackPressed = DateTime.now();
    if (differeance >= Duration(seconds: 2)) {
      Fluttertoast.showToast(msg: "Chiqish uchun yana bir marta bosing!");
      return Future.value(false);
    }
    Fluttertoast.cancel();
    SystemNavigator.pop();
    return Future.value(true);
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
          children: [
            _messagesListView(),
          ],
        ));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: showAsProgress(), // Show progress indicator while fetching data
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message if any
            );
          } else {

            List todos = snapshot.data?.docs ?? [];
            if (todos.isEmpty) {
              return const Center(
                child: Text("Add a todo!"),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index].data();
                  String todoId = todos[index].id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      title: Text(todo.task),
                      subtitle: Text(
                        DateFormat("dd-MM-yyyy h:mm a").format(
                          todo.updatedOn.toDate(),
                        ),
                      ),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todo updatedTodo = todo.copyWith(isDone: !todo.isDone, updatedOn: Timestamp.now());
                          _databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      onLongPress: () {
                        _databaseService.deleteTodo(todoId);
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget sample(){
    return Center(
      child: Lottie.asset(
        Assets.lottiesLoginRobot,
        width: getScreenWidth(context) * .4,
        height: getScreenHeight(context) * .3,
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Todo...."),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text('Ok'),
              onPressed: () {
                Todo todo = Todo(
                    task: _textEditingController.text, isDone: false, createdOn: Timestamp.now(), updatedOn: Timestamp.now());
                _databaseService.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
class CatChartData {
  final String category;
  final num total;


  CatChartData(this.category, this.total);
}