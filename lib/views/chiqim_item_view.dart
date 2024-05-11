import 'package:expenses_manager/extension/extension.dart';
import 'package:flutter/material.dart';

import '../model/expense_model.dart';
import '../utils/colors.dart';

class ChiqimItemView extends StatefulWidget{

  final ExpenseModel item;

  ChiqimItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChiqimItemViewState();
  }
  
}
class ChiqimItemViewState extends State<ChiqimItemView>{
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.5),
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.item.typeOfExpenseName, style: TextStyle(color: BLACK, fontSize: 18),),
          Text(' - ${widget.item.summa.formattedAmount(withSymbol: false)} ${widget.item.valyutaName}',style: TextStyle(color: RED, fontSize: 18),),
        ],),
    );
  }
  
}