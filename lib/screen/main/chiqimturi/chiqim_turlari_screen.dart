import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/model/chiqim_turi_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../model/kirim_turi_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/utils.dart';
import '../../main_viewmodel.dart';

class ChiqimTurlariScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChiqimTurlariScreenState();
  }
}

class ChiqimTurlariScreenState extends State<ChiqimTurlariScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
      return MainViewModel();
    }, onViewModelReady: (viewModel) {
      viewModel.getChiqimTurlariList();

      viewModel.errorData.listen((event) {
        showError(context, event);
      });

      viewModel.addedChiqimTuriData.listen((event) {
        if (event) {
          viewModel.getChiqimTurlariList();
        }
      });

      viewModel.updatedChiqimTuriData.listen((event) {
        if (event) {
          viewModel.getChiqimTurlariList();
        }
      });

      viewModel.deletedChiqimTuriData.listen((event) {
        if (event) {
          viewModel.getChiqimTurlariList();
        }
      });
    }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: COLOR_PRIMARY,
          iconTheme: IconThemeData(color: WHITE),
          title: Text(
            "Chiqim turlari",
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
                      itemCount: viewModel.chiqimTuriList.length,
                      itemBuilder: (_, position) {
                        var item = viewModel.chiqimTuriList[position];
                        print('JW - ${item.name}');
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: ListTile(
                            tileColor: Theme.of(context).colorScheme.primaryContainer,
                            title: Text(item.name),
                            subtitle: Text(
                              DateFormat("dd-MM-yyyy h:mm a").format(
                                item.createdOn.toDate(),
                              ),
                            ),
                            onLongPress: () {
                              viewModel.deleteChiqimTuri(item.id);
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            if (viewModel.chiqimTuriList.isEmpty)
              Center(
                child: Lottie.asset(Assets.lottiesEmptylist,
                    height: getScreenHeight(context) * .8, width: getScreenWidth(context) * .6),
              ),
            if (viewModel.progressData) showAsProgress(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Chiqim turini qo\'shing'),
                  content: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: "Kiriting...."),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      child: const Text('Ok'),
                      onPressed: () {
                        ChiqimTuriModel chiqimTuri = ChiqimTuriModel(
                          name: _textEditingController.text,
                          createdOn: Timestamp.now(),
                          id: '',
                        );
                        if (_textEditingController.text.isNotEmpty) {
                          viewModel.addChiqimTuri(chiqimTuri);
                          Navigator.pop(context);
                          _textEditingController.clear();
                        } else {
                          showWarning(context, "Iltimos chiqim turini kiriting");
                        }
                      },
                    ),
                  ],
                );
              },
            );
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
