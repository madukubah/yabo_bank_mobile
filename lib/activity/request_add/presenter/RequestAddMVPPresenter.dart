import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:yabo_bank/activity/request_add/interactor/RequestAddMVPInteractor.dart';
import 'package:yabo_bank/activity/request_add/view/RequestAddMVPView.dart';
import 'package:yabo_bank/model/PriceList.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


abstract class RequestAddMVPPresenter < V extends RequestAddMVPView , I extends RequestAddMVPInteractor > 
{
    void createRequests( List<PriceList> priceLists, File image, LatLng position );
    void getImage( ImageSource source );
    void getPriceLists(  );

}