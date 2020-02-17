import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/model/PriceList.dart';
import 'package:yabo_bank/model/Request.dart';

class PriceListWidget extends StatelessWidget {
  MediaQueryData queryData;
  final ValueChanged<PriceList> onChange;
  TextEditingController _controller;

  final PriceList priceList;
  PriceListWidget({@required this.priceList, this.onChange});
  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.decimalPattern();
    _controller = TextEditingController();
    _controller.text = "${priceList.quantity}";
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    TextStyle style15White = new TextStyle(
      inherit: true,
      fontSize: 8 * devicePixelRatio,
      color: Colors.white,
    );
    TextStyle style15 = new TextStyle(
      inherit: true,
      fontSize: 8 * devicePixelRatio,
      color: Colors.black54,
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2 - 50,
              child: Text(
                "${priceList.name[0].toUpperCase()}${priceList.name.substring(1)} (${formatter.format(priceList.price)}/${priceList.unit})",
                style: style15,
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (priceList.quantity != 0) priceList.quantity--;
                    _controller.text = "${priceList.quantity}";
                    onChange(priceList);
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.remove),
                ),
                // Text(
                //   "${priceList.quantity}",
                //   style: style15,
                // ),
                Container(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    onSubmitted: ( String value ){
                      // _controller.text = value;
                      priceList.quantity = int.parse( value );
                      if( value == '' ) priceList.quantity = 0;
                      onChange(priceList);
                    },
                    // decoration: InputDecoration(
                    //   border: OutlineInputBorder(),
                    // ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    priceList.quantity++;
                    _controller.text = "${priceList.quantity}";
                    onChange(priceList);
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
