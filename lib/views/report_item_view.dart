import 'package:expenses_manager/model/expense_model.dart';
import 'package:expenses_manager/model/report_model.dart';
import 'package:expenses_manager/views/report_inner_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ReportItemView extends StatefulWidget{

  final DailyReportModel? item;

  ReportItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return ReportItemViewState();
  }

}
class ReportItemViewState extends State<ReportItemView>{

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        color: WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                    child: Container(
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('Hisobot:',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.center,))),
                Expanded(
                  flex: 1,
                    child: Container(
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('So\'m',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.center,))),
                Expanded(
                  flex: 1,
                    child: Container(
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('\$',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.center,))),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('Jami kirim ',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.start,))),
                Expanded(
                  flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('${widget.item?.jamiKirimSum}',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.end,))),
                Expanded(
                  flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('${widget.item?.jamiKirimDollar}',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.end,))),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('Jami chiqim ',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.start,))),
                Expanded(
                  flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('${widget.item?.jamiChiqimSum}',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.end,))),
                Expanded(
                  flex: 1,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration( // Background color for the first text
                          border: Border.all(color: Colors.black), // Black border
                        ),child: Text('${widget.item?.jamiChiqimDollar}',style:TextStyle(fontSize: 14,color: BLACK),textAlign: TextAlign.end,))),
              ],
            ),
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: widget.item?.item.length,
                itemBuilder: (_, position) {
                  var item = widget.item?.item[position];if (item != null) {
                    return ReportInnerItemView(item: item);
                  } else {
                    // Handle the case where widget.item is null
                    return Text('No information found'); // Or any other placeholder widget
                  }
                }),
          ],
        ),
      ),
    );
  }


}