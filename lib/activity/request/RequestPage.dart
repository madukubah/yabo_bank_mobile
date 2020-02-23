import 'package:yabo_bank/activity/request/interactor/RequestPageInteractor.dart';
import 'package:yabo_bank/activity/request/presenter/RequestPagePresenter.dart';
import 'package:yabo_bank/activity/request/view/RequestPageMVPView.dart';
import 'package:flutter/material.dart';
import 'package:yabo_bank/activity/request_add/RequestAdd.dart';
import 'package:yabo_bank/model/ProcessedRequest.dart';
import 'package:yabo_bank/model/Request.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'package:yabo_bank/widget/ProcessedRequestWidget.dart';
import 'package:yabo_bank/widget/RequestWidget.dart';

import '../../data/network/AppApiHelper.dart';
import '../../data/preferences/AppPreferenceHelper.dart';
import 'interactor/RequestPageMVPInteractor.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with SingleTickerProviderStateMixin
    implements RequestPageMVPView {
  RequestPagePresenter<RequestPageMVPView, RequestPageMVPInteractor> presenter;
  bool _isLoading = true;
  // LatLng centerPoint;
  List<Request> requests;
  List<ProcessedRequest> processedRequests;
  TabController tabController;

  _RequestPageState() {
    RequestPageInteractor interactor = RequestPageInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter =
        RequestPagePresenter<RequestPageMVPView, RequestPageMVPInteractor>(
            interactor);
  }

  @override
  void initState() {
    presenter.onAttach(this);
    super.initState();
    presenter.getRequests();
    tabController = TabController(length: 2, vsync: this);
  }

  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;

    TextStyle style15BoldWhite = new TextStyle(
      inherit: true,
      fontSize: 13 * devicePixelRatio,
      color: Colors.white,
    );
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
        body: RefreshIndicator(
            onRefresh: () async {
              presenter.getRequests();
            },
            child: Column(children: [
              Container(
                color: Color.fromARGB(255, 246, 223, 208),
                child: TabBar(
                  unselectedLabelColor: Color.fromARGB(255, 158, 155, 152),
                  labelColor: AppColor.PRIMARY,
                  controller: tabController,
                  indicatorColor: AppColor.PRIMARY,
                  tabs: [
                    Tab(
                      // text: "Jemput",
                      icon: (requests.length == 0)
                          ? Text("Pesanan") //Icon(Icons.list)
                          : new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  new Text("Pesanan"),
                                  new Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      new Icon(Icons.brightness_1,
                                          size: 18.0, color: AppColor.PRIMARY),
                                      Center(
                                        child: new Text('${requests.length}',
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ]),
                    ),
                    Tab(
                      // text: "Terkonfirmasi",
                      icon: (processedRequests.length == 0)
                          ? Text("Diproses")
                          : new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  new Text("Diproses"),
                                  new Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      new Icon(Icons.brightness_1,
                                          size: 18.0, color: AppColor.PRIMARY),
                                      Center(
                                        child: new Text('${processedRequests.length}',
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500)),
                                      )
                                    ],
                                  ),
                                ]),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 4 / 6,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  // Add tabs as widgets
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: () async {
                        presenter.getRequests();
                      },
                      child: requests.length == 0
                          ? ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              4 /
                                              6,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                          child: Container(
                                        // color: Colors.pink,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                    1 /
                                                    4 +
                                                30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/no_data.png'),
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ))),
                                )
                              ],
                            )
                          : CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            // unprocess req
                                            Column(
                                              children: requests.map((i) {
                                                return Builder(builder:
                                                    (BuildContext context) {
                                                  return RequestWidget(
                                                    request: i,
                                                    onTap: (Request request) {
                                                      showDialogDelete(request);
                                                    },
                                                  );
                                                });
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    )
                    /////////////////////////////////////
                    ,
                    /////////////////////////////////////////
                    RefreshIndicator(
                      onRefresh: () async {
                        presenter.getRequests();
                      },
                      child: processedRequests.length == 0
                          ? ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              4 /
                                              6,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                          child: Container(
                                        // color: Colors.pink,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                    1 /
                                                    4 +
                                                30,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/no_data.png'),
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ))),
                                )
                              ],
                            )
                          : CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              children:
                                                  processedRequests.map((i) {
                                                return Builder(builder:
                                                    (BuildContext context) {
                                                  return ProcessedRequestWidget(
                                                      request: i);
                                                });
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                  // set the controller
                  controller: tabController,
                ),
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            presenter.goToRequestAdd();
          },
          backgroundColor: AppColor.PRIMARY,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );
  }

  void goToRequestAdd() async {
    // print("$itemId");
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestAdd(),
      ),
    );
    if (result != null) presenter.getRequests();
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
  void setProcessedRequests(List<ProcessedRequest> items) {
    setState(() {
      this.processedRequests = items;
    });
  }

  @override
  void setRequests(List<Request> items) {
    setState(() {
      this.requests = items;
    });
  }

  Future<void> showDialogDelete(Request request) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text('Hapus Penjemputan'),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Apakah anda yakin ?',
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
                Navigator.of(context).pop();
                presenter.deleteRequests(request.id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void refresh() {
    presenter.getRequests();
  }

  @override
  void openRequestAdd() {
    goToRequestAdd();
  }

  @override
  Future<void> showModalNotVerified() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Text(
            'Belum Terverifikasi',
            maxLines: 2,
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Mohon untuk mengupload foto KTP',
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
              child: Text('Ok', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
