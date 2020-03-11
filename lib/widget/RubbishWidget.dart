import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/model/RubbishSummary.dart';

class RubbishWidget extends StatelessWidget {
  MediaQueryData queryData;
  final RubbishSummary rubbishSummary;

  RubbishWidget({Key key, this.rubbishSummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.decimalPattern();
    queryData = MediaQuery.of(context);

    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          width: 120.0,
          height: 100.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: new DecorationImage(
              image: AssetImage(
                '${rubbishSummary.image}',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 150.0,
            height: 100.0,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(50, 0, 0, 0),
            ),
          ),
        ),
        Positioned(
          left: 14,
          top: 8,
          child: Text('${rubbishSummary.name}',
              style: TextStyle(
                inherit: true,
                color: Colors.white,
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${rubbishSummary.qty}",
              style: TextStyle(
                inherit: true,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Kilogram",
              style: TextStyle(
                inherit: true,
                color: Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }
}
