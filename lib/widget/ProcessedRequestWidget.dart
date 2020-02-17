import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/model/ProcessedRequest.dart';
import 'package:yabo_bank/model/Request.dart';

class ProcessedRequestWidget extends StatelessWidget {
  MediaQueryData queryData;
  final ValueChanged<Request> onTap;

  final ProcessedRequest request;
  ProcessedRequestWidget({@required this.request, this.onTap});
  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.decimalPattern();

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
      color: Colors.black,
    );

    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                "${request.info}",
                style: style15,
              ),
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.motorcycle,
                  color: Colors.orange,
                ), 
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${request.driver_name}",
                  style: style15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
