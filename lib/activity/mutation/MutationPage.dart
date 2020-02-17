import 'package:flutter/material.dart' as prefix0;
import 'package:yabo_bank/activity/mutation/interactor/MutationInteractor.dart';
import 'package:yabo_bank/activity/mutation/presenter/MutationPresenter.dart';
import 'package:yabo_bank/activity/mutation/view/MutationMVPView.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/model/Account.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'package:yabo_bank/widget/MutationWidget.dart';

import '../../data/network/AppApiHelper.dart';
import '../../data/preferences/AppPreferenceHelper.dart';
import 'interactor/MutationMVPInteractor.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class MutationPage extends StatefulWidget {
  @override
  _MutationPageState createState() => _MutationPageState();
}

class _MutationPageState extends State<MutationPage>
    implements MutationMVPView {
  MutationPresenter<MutationMVPView, MutationMVPInteractor> presenter;
  Account account;
  bool _isLoading = true;

  _MutationPageState() {
    MutationInteractor interactor = MutationInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter =
        MutationPresenter<MutationMVPView, MutationMVPInteractor>(interactor);
    account = Account(balance: 0, credit: 0, debit: 0, mutations: []);
  }
  var timeFormatter = new DateFormat('dd MMM yyyy');
  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    presenter.onAttach(this);
    startDate = new DateTime.now().subtract(new Duration(days: 30));
    endDate = new DateTime.now();

    presenter.getMutations(startDate, endDate);
    super.initState();
  }

  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    var formatter = new NumberFormat.decimalPattern();

    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    TextStyle style15BoldWhite = new TextStyle(
      inherit: true,
      fontSize: 13 * devicePixelRatio,
      color: Colors.white,
      // fontWeight:FontWeight.bold
    );
    TextStyle style15White = new TextStyle(
      inherit: true,
      fontSize: 8 * devicePixelRatio,
      color: Colors.white,
      fontWeight:FontWeight.bold
    );
    TextStyle style15 = new TextStyle(
      inherit: true,
      fontSize: 8 * devicePixelRatio,
      color: Colors.black,
    );

    if (_isLoading)
      return new Scaffold(
        body: new Center(
          child: new Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    else
      return Scaffold(
        body: prefix0.RefreshIndicator(
          onRefresh: () async {
            presenter.getMutations(startDate, endDate);
          },
          child: Container(
            // height: MediaQuery.of(context).size.height,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Stack(
                        children: [
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 3 -50,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/background.png'),
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 3 -50 ,
                            width: MediaQuery.of(context).size.width,
                            color: Color.fromARGB(120, 0, 0, 0),
                          ),
                          Positioned(
                            left: 10.0,
                            bottom: 30,
                            child: Container(
                                // color: Colors.pink,
                                height: 100.0,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Saldo : Rp. ${formatter.format(account.balance)}",
                                      style: style15BoldWhite,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                final List<DateTime> picked =
                                    await DateRagePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: startDate,
                                        initialLastDate: endDate,
                                        firstDate: new DateTime(2015),
                                        lastDate: new DateTime(2025));
                                if (picked != null && picked.length == 2) {
                                  startDate = picked[0];
                                  endDate = picked[1];
                                  presenter.getMutations(startDate, endDate);
                                }
                              },
                              child: Container(
                                color: AppColor.PRIMARY,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "${timeFormatter.format(startDate)}",
                                        style: style15White,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Sampai",
                                        style: style15White,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${timeFormatter.format(endDate)}",
                                        style: style15White,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 12.0, 8.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Total Debit",
                                          style: style15,
                                        ),
                                        Text(
                                          "Rp. ${formatter.format(account.debit)}",
                                          style: style15,
                                        ),
                                      ],
                                    ),
                                    Container(
                                          width: 2,
                                          height: 50,
                                          color: Color.fromARGB(255, 158, 155, 152),
                                        ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          "Total Kredit",
                                          style: style15,
                                        ),
                                        Text(
                                          "Rp. ${formatter.format(account.credit)}",
                                          style: style15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: account.mutations.map((i) {
                                  return Builder(builder: (BuildContext context) {
                                    return MutationWidget(mutation: i);
                                  });
                                }).toList(),
                              ),
                            ),
                            // AAAAAAAAAAAAAAAAAAAAAAAAAAA
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  @override
  void hideProgress() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showMessage(String message, int status) {
    // TODO: implement showMessage
  }

  @override
  void showProgress() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void setAccount(Account account) {
    setState(() {
      this.account = account;
    });
  }
}
