
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:yabo_bank/activity/request_add/interactor/RequestAddMVPInteractor.dart';
import 'package:yabo_bank/activity/request_add/view/RequestAddMVPView.dart';
import 'package:yabo_bank/base/presenter/BasePresenter.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/model/PriceList.dart';

import 'RequestAddMVPPresenter.dart';
import 'package:image/image.dart' as _image;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RequestAddPresenter < V extends RequestAddMVPView , I extends RequestAddMVPInteractor > extends BasePresenter< V, I > implements RequestAddMVPPresenter<V, I>
{
  RequestAddPresenter(RequestAddMVPInteractor interactor) : super(interactor);

   @override
  void getPriceLists() {
    this.getView().showProgressCircle();  
    interactor.doGetPriceLists(  ).then( ( ApiResponse response ){

        this.getView().setPriceLists( response.data );  
        this.getView().hideProgressCircle();  
    });
  }

  @override
  void createRequests(List<PriceList> priceLists, File image, LatLng position) {
    
    if( ! checkPriceList( priceLists ) ){
      this.getView().showMessage(  'Input Jenis Sampah Beserta Perkiraan Berat !', 0 );
      return;
    }
    if( image == null )
    {
      this.getView().showMessage(  'Masukkan Gambar !', 0 );
      return;
    }
    Map<String, String> formData = {
      'info'    : this.buildInfo(priceLists),
      'latitude': '${position.latitude}',
      'longitude': '${position.longitude}',
    };
    this.getView().showProgress(  );
    interactor.doCreateRequests( formData, image ).then( ( ApiResponse response ){
          this.getView().hideProgress(  );
          if( response.success )   
            this.getView().backToRRequestList();
          else
            this.getView().showMessage(  response.message, 0 );
      } );
  }

  bool checkPriceList( List<PriceList> priceLists ){
    for (var i = 0; i < priceLists.length; i++) {
      if( priceLists[i].status == 1 && priceLists[i].quantity > 0 ){
        return true;
      }
    }
    return false;
  }

  String buildInfo( List<PriceList> priceLists ){
    List<String> info = [];
    for (var i = 0; i < priceLists.length; i++) {
      if( priceLists[i].status == 1 && priceLists[i].quantity > 0 ){
        info.add( "${priceLists[i].name} ${priceLists[i].quantity} ${priceLists[i].unit}" ) ;
      }
    }
    return info.join(', ');
  }

  @override
  void getImage(ImageSource source) async {
    this.getView().showProgress(  );

    File image = await ImagePicker.pickImage(source: source);
    
    if (image != null) {
      _image.Image imageFile = _image.decodeJpg(image.readAsBytesSync());

      _image.Image thumbnail = _image.copyResize(imageFile, width: 500, height : 400);

      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      new Directory(appDocDirectory.path + '/customer').create(recursive: true)
          // The created directory is returned as a Future.
          .then((Directory directory) {
        var name = DateTime.now().millisecondsSinceEpoch;
        File(directory.path + '/$name.png')
            .writeAsBytesSync(_image.encodePng(thumbnail));

        File imageThumbnail = File(directory.path + '/$name.png');
        this.getView().onImageLoad(  imageThumbnail );
        print('Path of New Dir: ' + directory.path);
      });
    } else
        this.getView().showMessage(  'tidak ada gambar', 0 );

    this.getView().showMessage(  '', 1 );
      
  }
}