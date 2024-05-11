import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/model/kirim_turi_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/utils.dart';
import '../../main_viewmodel.dart';

class KirimTurlariScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KirimTurlariScreenState();
  }
  
}
class KirimTurlariScreenState extends State<KirimTurlariScreen>{

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<MainViewModel>.reactive(
        viewModelBuilder: () {
          return MainViewModel();
        },
        onViewModelReady: (viewModel) {

          viewModel.getKirimTuri();

          viewModel.errorData.listen((event) {
            showError(context, event);
          });

          viewModel.addedKirimData.listen((event) {
            if (event) {
              viewModel.getKirimTuri();
            }
          });

          viewModel.updatedKirimData.listen((event) {
            if (event) {
              viewModel.getKirimTuri();
            }
          });

          viewModel.deletedKirimData.listen((event) {
            if (event) {
              viewModel.getKirimTuri();
            }
          });

        },
        builder: (BuildContext context, MainViewModel viewModel, Widget? child){
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: COLOR_PRIMARY,
              iconTheme: IconThemeData(color: WHITE),
              title: Text("Kirimlar turlari", style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),),
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
                          itemCount: viewModel.kirimList.length,
                          itemBuilder: (_, position) {
                            var item = viewModel.kirimList[position];
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
                                  viewModel.deleteKirimTuri(item.id);
                                },
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                if (viewModel.kirimList.isEmpty)
                  Center(
                    child: Lottie.asset(Assets.lottiesEmptylist,
                        height: getScreenHeight(context) * .8, width: getScreenWidth(context) * .6),
                  ),
                if (viewModel.progressData) showAsProgress(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Kirim turini qo\'shing'),
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
                            KirimTuriModel kirimTuri = KirimTuriModel(
                              name: _textEditingController.text,createdOn: Timestamp.now(),id: '',);
                            if(_textEditingController.text.isNotEmpty){
                              viewModel.addKirimTuri(kirimTuri);
                              Navigator.pop(context);
                              _textEditingController.clear();
                            } else {
                              showWarning(context, "Iltimos kirim turini kiriting");
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
        }
    );
  }
  
}