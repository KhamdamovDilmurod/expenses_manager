import 'package:expenses_manager/extension/extension.dart';
import 'package:expenses_manager/model/expense_model.dart';
import 'package:expenses_manager/utils/colors.dart';
import 'package:flutter/material.dart';

class KirimItemView extends StatefulWidget{

  final ExpenseModel item;

  KirimItemView({Key? key, required this.item}) : super(key: key);
  @override
  State<StatefulWidget> createState() {

    return KirimItemViewState();
  }
  
}
class KirimItemViewState extends State<KirimItemView>{
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
        Text(' + ${widget.item.summa.formattedAmount(withSymbol: false)} ${widget.item.valyutaName}',style: TextStyle(color: COLOR_GREEN, fontSize: 18),),
      ],),
    );
  }

  
}