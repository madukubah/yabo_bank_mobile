import 'package:yabo_bank/activity/auth/register/interactor/RegisterInteractor.dart';
import 'package:yabo_bank/activity/auth/register/presenter/RegisterPresenter.dart';
import 'package:yabo_bank/activity/auth/register/view/RegisterMVPView.dart';
import 'package:yabo_bank/data/network/AppApiHelper.dart';
import 'package:yabo_bank/data/preferences/AppPreferenceHelper.dart';
import 'package:yabo_bank/template/form/MyForm.dart';
import 'package:yabo_bank/template/form/MyFormBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'interactor/RegisterMVPInteractor.dart';

class RegisterPage extends StatefulWidget {
  static const String tag = 'RegisterPage';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    implements RegisterMVPView {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<MyForm> dataForm = [
    MyForm(
        type: MyForm.TYPE_TEXT,
        name: "name",
        label: "Nama Lengkap",
        value: ""),
    MyForm(
        type: MyForm.TYPE_EMAIL,
        name: "email",
        label: "Email",
        value: ""),
    MyForm(
        type: MyForm.TYPE_NUMBER,
        name: "phone",
        label: "NO HP",
        value: ""),
    MyForm(
        type: MyForm.TYPE_TEXT,
        name: "address",
        label: "Alamat", 
        value: ""),
    MyForm(
        type: MyForm.TYPE_PASSWORD,
        name: "password",
        label: "Password",
        value: ""),
    MyForm(
        type: MyForm.TYPE_PASSWORD,
        name: "c_password",
        label: "Konfirmasi Password",
        value: ""),
  ];
  bool isMessageShowed = false;
  String message = "";
  Color messageColor = Colors.red;

  RegisterPresenter<RegisterMVPView, RegisterMVPInteractor> presenter;
  _RegisterPageState() {
    RegisterInteractor interactor = RegisterInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter =
        RegisterPresenter<RegisterMVPView, RegisterMVPInteractor>(interactor);
  }
  @override
  void initState() {
    super.initState();
    presenter.onAttach(this);
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        // isButtonDisabled : true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
                if (_fbKey.currentState.saveAndValidate()) {
                  print(_fbKey.currentState.value);
                  presenter.onServerRegisterClicked(_fbKey.currentState.value);
                } else {
                  print(_fbKey.currentState.value);
                  print("validation failed");
                }
              },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
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
                children:
                    MyFormBuilder().create_forms(dataForm, isLabeled: true),
              ),
            ),
            SizedBox(height: 24.0),
            submitButton,
          ],
        ),
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
  void showMessage(String message, int status) {
    List<Color> messageColor = [Colors.red, Colors.green];
    setState(() {
      this.message = message;
      this.isMessageShowed = true;
      this.messageColor = messageColor[status];
    });
  }

  @override
  void openMainAvtivity() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacementNamed("/Home");
  }
}
