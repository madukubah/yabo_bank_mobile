import 'package:url_launcher/url_launcher.dart';
import 'package:yabo_bank/activity/feed/Feed.dart';
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
    controller = TabController(length: 4, vsync: this);
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
        elevation: 0.0,
        centerTitle: true,
        actions: controller.index != 3
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
        // physics: NeverScrollableScrollPhysics(),
        // Add tabs as widgets
        children: <Widget>[ Feed(), RequestPage(), MutationPage(), Profile()],
        // set the controller 
        controller: controller,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            // type : BottomNavigationBarType.shifting,
            // fixedColor: Color.fromARGB(255, 250, 247, 245),
            backgroundColor: Color.fromARGB(255, 250, 247, 245),
            unselectedItemColor: Color.fromARGB(255, 158, 155, 152),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.motorcycle),
                title: Text('Penjemputan'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                title: Text('Mutasi'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profil'),
              ),
            ],
            currentIndex: controller.index,
            selectedItemColor: AppColor.PRIMARY,
            onTap: (int index){
              controller.index = index;
            },
          ),
        ),
      ),
    );
  }

  Future<void> showDialogLogout() {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text(
                'Keluar',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Apakah Anda Yakin ?',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.black26),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok', style: TextStyle(color: AppColor.PRIMARY)),
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
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.call,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Call Center',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Text('Call Center', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Hubungi ?',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.black26),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok', style: TextStyle(color: AppColor.PRIMARY)),
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
