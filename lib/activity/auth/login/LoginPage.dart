import 'package:url_launcher/url_launcher.dart';
import 'package:yabo_bank/activity/auth/login/presenter/LoginPresenter.dart';
import 'package:yabo_bank/activity/auth/login/view/LoginMVPView.dart';
import 'package:yabo_bank/data/network/AppApiHelper.dart';
import 'package:yabo_bank/data/preferences/AppPreferenceHelper.dart';
import 'package:yabo_bank/template/form/MyForm.dart';
import 'package:yabo_bank/template/form/MyFormBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:yabo_bank/util/AppConstants.dart';

import 'interactor/LoginInteractor.dart';
import 'interactor/LoginMVPInteractor.dart';

class LoginPage extends StatefulWidget {
  static const String tag = 'LoginPage';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginMVPView {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  LoginPresenter<LoginMVPView, LoginMVPInteractor> presenter;

  bool isMessageShowed = false;
  String message = "";
  Color messageColor = Colors.red;

  List<MyForm> dataForm = [
    MyForm(
      type: MyForm.TYPE_TEXT,
      name: "email",
      label: "Email",
      value: "",
    ),
    MyForm(
        type: MyForm.TYPE_PASSWORD,
        name: "password",
        label: "Password",
        value: ""),
  ];

  _LoginPageState() {
    LoginInteractor interactor = LoginInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter = LoginPresenter<LoginMVPView, LoginMVPInteractor>(interactor);
  }
  @override
  void initState() {
    presenter.onAttach(this);
    super.initState();
    presenter.start();
  }

  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 52.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          if (_fbKey.currentState.saveAndValidate()) {
            print(_fbKey.currentState.value);
            presenter.onServerLoginClicked(_fbKey.currentState.value['email'],
                _fbKey.currentState.value['password']);
          } else {
            print(_fbKey.currentState.value);
            print("validation failed");
          }
        },
        padding: EdgeInsets.all(12),
        color: AppColor.PRIMARY,
        child: Text('Masuk', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerLabel = FlatButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Belum punya akun? ',
          style: TextStyle(color: Colors.black54),
        ),
        Text(
          'Daftar',
          style: TextStyle(color: AppColor.PRIMARY),
        ),
      ]),
      onPressed: () {
        Navigator.of(context).pushNamed("/RegisterPage");
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Container(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    icon: Icon(
                      Icons.phone,
                      color: AppColor.PRIMARY,
                    ),
                    onPressed: () {
                      showDialogCallCenter();
                    },
                  ),
                ]),
                SizedBox(
                  height: 42,
                ),
                logo,
                SizedBox(height: 28 ),
                Visibility(
                  visible: isMessageShowed,
                  child: Center(
                    child: Text(
                      "$message",
                      style: TextStyle(color: messageColor),
                    ),
                  ),
                ),
                FormBuilder(
                  key: _fbKey,
                  autovalidate: false,
                  child: Column(
                    children: MyFormBuilder().create_forms(dataForm),
                  ),
                ),
                // SizedBox(height: 8.0),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  loginButton,
                ]),
                Container(
                  // color: Colors.pink,
                  height: MediaQuery.of(context).size.height * 1/4 + 30,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                registerLabel,
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void hideProgress() {
    Navigator.pop(context);
  }

  @override
  void showProgress() {
    print("showProgress");
    showDialog(
      barrierDismissible: false,
      context: context,
      child: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void showValidationMessage(int errorCode) {
    // TODO: implement showValidationMessage
  }

  @override
  Future<void> showMessage(String message, bool status) {
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
                Icons.warning,
                color: Colors.red,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Oops !',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    '$message',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void openMainAvtivity() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed("/Home");
  }

  Future<void> showDialogCallCenter() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
}
