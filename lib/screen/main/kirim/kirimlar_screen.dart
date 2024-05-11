import 'dart:async';

import 'package:expenses_manager/screen/main/kirim/kirim_qoshish_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../model/event_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/event_bus.dart';
import '../../../utils/utils.dart';
import '../../../views/kirim_item_view.dart';
import '../../main_viewmodel.dart';

class KirimlarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KirimlarScreenState();
  }
}

class KirimlarScreenState extends State<KirimlarScreen> {

  StreamSubscription? eventBusListener;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
      return MainViewModel();
    }, onViewModelReady: (viewModel) {
      viewModel.getUserKirimlar();
      viewModel.errorData.listen((event) {
        showError(context, event);
      });
    }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {

      eventBusListener = eventBus.on<EventModel>().listen((event){
        if(event.event == EVENT_DATA){
          viewModel.getUserKirimlar();
        }
      });

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: COLOR_PRIMARY,
          iconTheme: IconThemeData(color: WHITE),
          title: Text(
            "Kirimlar",
            style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: viewModel.kirimlar.length,
                      itemBuilder: (_, position) {
                        var item = viewModel.kirimlar[position];
                        print('JW - ${item.comment}');
                        return KirimItemView(item: item,);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: ListTile(
                            tileColor: Theme.of(context).colorScheme.primaryContainer,
                            title: Text(item.summa.toString()),
                            subtitle: Text(
                              DateFormat("dd-MM-yyyy h:mm a").format(
                                item.createdOn.toDate(),
                              ),
                            ),
                            onLongPress: () {
                              // viewModel.deleteEmployee(item.id);
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            if (viewModel.kirimlar.isEmpty)
              Center(
                child: Lottie.asset(Assets.lottiesEmptylist,
                    height: getScreenHeight(context) * .8, width: getScreenWidth(context) * .6),
              ),
            if (viewModel.progressData) showAsProgress(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_) => KirimQoshishScreen()));
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
