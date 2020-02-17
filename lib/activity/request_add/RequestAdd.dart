import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yabo_bank/activity/map/MapSearch.dart';
import 'package:yabo_bank/activity/request_add/presenter/RequestAddPresenter.dart';
import 'package:yabo_bank/activity/request_add/view/RequestAddMVPView.dart';
import 'package:flutter/material.dart';
// import 'package:yabo_bank/data/network/ApiEndPoint.dart';
import 'package:yabo_bank/data/network/AppApiHelper.dart';
import 'package:yabo_bank/data/preferences/AppPreferenceHelper.dart';
import 'package:yabo_bank/model/PriceList.dart';
import 'package:yabo_bank/module/FIXLImage.dart';
import 'package:yabo_bank/template/form/MyForm.dart';
import 'package:location/location.dart';
import 'package:yabo_bank/util/AppConstants.dart';
import 'package:yabo_bank/widget/PriceListWidget.dart';

import 'interactor/RequestAddInteractor.dart';
import 'interactor/RequestAddMVPInteractor.dart';

class RequestAdd extends StatefulWidget {
  @override
  _RequestAddState createState() => _RequestAddState();
}

class _RequestAddState extends State<RequestAdd> implements RequestAddMVPView {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  GoogleMapController mapController;

  final LatLng _center = const LatLng(-3.9850467, 122.5129742);

  RequestAddPresenter<RequestAddMVPView, RequestAddMVPInteractor> presenter;
  List<PriceList> priceLists = [];
  bool _isLoading = true;
  List<MyForm> dataForm = [
    MyForm(type: MyForm.TYPE_TEXTAREA, name: "info", label: "Keterangan"),
  ];

  bool isMessageShowed = false;
  String message = "";
  Color messageColor = Colors.red;
  File _imageFile;

  _RequestAddState() {
    RequestAddInteractor interactor = RequestAddInteractor(
        AppPreferenceHelper.getInstance(), AppApiHelper.getInstance());
    presenter = RequestAddPresenter<RequestAddMVPView, RequestAddMVPInteractor>(
        interactor);
  }
  final Map<String, Marker> _markers = {};
  FIXLImage imageHandler = FIXLImage();

  @override
  void initState() {
    presenter.onAttach(this);
    super.initState();
    presenter.getPriceLists();
    getPermission();
  }

  getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      setState(() {
        // _allowWriteFile = true;
      });
    }
  }

  void refresh() async {
    final center = await getUserLocation();
    print( 'center COORDINATES = $center' );
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    setState(() {
      Map<String, Marker> point = {'info': Marker( position: center, markerId: MarkerId('currentLocation') ) };
      _markers.addAll( point );
    });
    // getNearbyPlaces(center);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation;
    final Location location = Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } catch (  e ) {
      showMessage( e.code, 0 );
      currentLocation = null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        // isButtonDisabled : true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          presenter.createRequests(priceLists, this._imageFile);
          // if (_fbKey.currentState.saveAndValidate()) {
          //   print(_fbKey.currentState.value);
          //   presenter.createRequests(
          //       _fbKey.currentState.value, this._imageFile);
          // } else {
          //   print(_fbKey.currentState.value);
          //   print("validation failed");
          // }
        },
        padding: EdgeInsets.all(12),
        color: AppColor.PRIMARY,
        child: Text('Kirim', style: TextStyle(color: Colors.white)),
      ),
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
        // backgroundColor: Colors.black26,
        appBar: new AppBar(
          backgroundColor: AppColor.PRIMARY,
          title: new Text("Buat Penjemputan"),
        ),
        body: Container(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Jenis Sampah",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8)
                    ],
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 2,
                    crossAxisCount: 3,
                  ),
                  delegate: SliverChildListDelegate(
                    priceLists.map((i) {
                      return Builder(builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                          child: Container(
                            decoration: (i.status == 0)
                                ? null
                                : new BoxDecoration(boxShadow: [
                                    new BoxShadow(
                                      color: AppColor.PRIMARY,
                                      blurRadius: 4.0,
                                    ),
                                  ]),
                            height: 10,
                            child: Card(
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    i.status = (i.status == 0) ? 1 : 0;
                                  });
                                },
                                child: Center(
                                  child: new Text(
                                    "${i.name.toUpperCase()}",
                                    // style: style15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Perkiraan Berat Sampah",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: priceLists.map((i) {
                            return Builder(builder: (BuildContext context) {
                              return Visibility(
                                visible: i.status == 1,
                                child: PriceListWidget(
                                    priceList: i,
                                    onChange: (PriceList priceList) {
                                      // countTotal();
                                    }),
                              );
                            });
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Gambar",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                // SliverGrid(
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     // childAspectRatio : 3/2,
                //     crossAxisCount: 3,
                //   ),
                //   delegate: SliverChildListDelegate(
                //     [1, 1, 1].map((i) {
                //       return Builder(builder: (BuildContext context) {
                //         return Container(
                //           child: Card(
                //             color: Colors.white,
                //             child: InkWell(
                //               onTap: () {
                //                 setState(() {});
                //               },
                //               child: Center(
                //                 child: IconButton(
                //                     icon: Icon(Icons.add_a_photo),
                //                     onPressed: null),
                //               ),
                //             ),
                //           ),
                //         );
                //       });
                //     }).toList(),
                //   ),
                // ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width * 4 / 7,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _openImagePickerModal(context);
                              });
                            },
                            child: (_imageFile != null)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(_imageFile,
                                        fit: BoxFit.fitWidth))
                                : Card(
                                    color: Colors.white,
                                    child: Center(
                                      child: IconButton(
                                          icon: Icon(Icons.add_a_photo),
                                          onPressed: null),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Posisi Di Map",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.width * 6 / 10,
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                gotoMapSearch();
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: 
                              AbsorbPointer(
                                absorbing: true,
                                child: 
                                GoogleMap(
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 11,
                                  ),
                                  markers: _markers.values.toSet(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: submitButton),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void getImage(ImageSource source) {
    imageHandler.getImage(
      source,
      start: () {
        this.showProgress();
      },
      success: (File image) {
        this.hideProgress();
        setState(() {
          this._imageFile = image;
        });
      },
      failed: (String message) {
        this.hideProgress();
        this.showMessage(message, 0);
      },
    );
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Ambil Gambar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Gunakan Kamera'),
                  onPressed: () {
                    Navigator.pop(context);
                    // presenter.getImage( ImageSource.camera );
                    getImage(ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Buka Galeri'),
                  onPressed: () {
                    Navigator.pop(context);
                    // presenter.getImage( ImageSource.gallery );
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  void hideProgress() {
    Navigator.pop(context);
  }

  @override
  Future<void> showMessage(String message, int status) {
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
  void onImageLoad(File image) {
    setState(() {
      this._imageFile = image;
    });
  }

  @override
  void setPriceLists(List<PriceList> items) {
    if (items.length > 0) items[0].status = 1;

    setState(() {
      this.priceLists = items;
    });
  }

  @override
  void hideProgressCircle() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showProgressCircle() {
    _isLoading = true;
  }

  @override
  void backToRRequestList() {
    Navigator.pop(context, 1);
  }

  void gotoMapSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSearch(),
      ),
    );
    if (result != null) {
      print(result);
    }
  }
}
