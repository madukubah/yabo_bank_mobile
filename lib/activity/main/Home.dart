import 'package:url_launcher/url_launcher.dart';
import 'package:yabo_bank/activity/main/presenter/HomePresenter.dart';
import 'package:yabo_bank/activity/main/view/HomeMVPView.dart';
import 'package:yabo_bank/activity/mutation/MutationPage.dart';
import 'package:yabo_bank/activity/request/RequestPage.dart';
import 'package:yabo_bank/data/network/AppApiHelper.dart';
import 'package:yabo_bank/data/preferences/AppPreferenceHelper.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'package:flutter/material.dart';

import '../profile/Profile.dart';
import 'interactor/HomeInteractor.dart';
import 'interactor/HomeMVPInteractor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin
    implements HomeMVPView {
  TabController controller;

  HomePresenter<HomeMVPView, HomeMVPInteractor> presenter;

  _HomeState() {
    HomeInteractor interactor = HomeInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter = HomePresenter<HomeMVPView, HomeMVPInteractor>(interactor);
    this.presenter.onAttach(this);
  }

  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    controller = TabController(length: 3, vsync: this);
    controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      print(" index: ${controller.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: AppColor.PRIMARY,
        title: new Text("${AppConstants.APP_NAME}"),
        actions: controller.index != 2
            ? null
            : <Widget>[
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    showDialogCallCenter();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    showDialogLogout();
                  },
                ),
              ],
      ),
      body: TabBarView(
        // Add tabs as widgets
        children: <Widget>[MutationPage(), RequestPage(), Profile()],
        // set the controller
        controller: controller,
      ),
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: AppColor.PRIMARY,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              // set icon to the tab
              icon: Icon(Icons.credit_card),
              text: 'Mutasi',
            ),
            Tab(
              icon: Icon(Icons.airport_shuttle),
              text: 'Penjemputan',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'Profil',
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }

  Future<void> showDialogLogout() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Apakah anda yakin ?',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok', style: TextStyle(color: Colors.green)),
              onPressed: () {
                presenter.logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogCallCenter() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Center', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Hubungi ?',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok', style: TextStyle(color: Colors.green)),
              onPressed: () {
                launch("tel:0811405154");
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void hideProgress() {
    // TODO: implement hideProgress
  }

  @override
  void showMessage(String message, int status) {
    // TODO: implement showMessage
  }

  @override
  void showProgress() {
    // TODO: implement showProgress
  }

  @override
  void toLoginPage() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed("/LoginPage");
  }
}
