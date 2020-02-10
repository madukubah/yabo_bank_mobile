import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/model/Mutation.dart';

class MutationWidget extends StatelessWidget {
  MediaQueryData queryData;
  final Mutation mutation;
  Color statusColor;
  MutationWidget({@required this.mutation});
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

    if (mutation.position == 1)
      statusColor = Colors.red;
    else
      statusColor = Colors.green;

    TextStyle style15 = new TextStyle(
      inherit: true,
      fontSize: 8 * devicePixelRatio,
      color: statusColor,
    );

    return Container(
        child: Column(
      children: <Widget>[
        Container(
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${mutation.created_at.split(" ")[0]}",
                  style: style15White,
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    "${mutation.description}",
                    style: TextStyle(
                      inherit: true,
                      fontSize: 8 * devicePixelRatio,
                      color: Colors.black,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Rp. ${formatter.format(mutation.nominal)}",
                      style: style15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}