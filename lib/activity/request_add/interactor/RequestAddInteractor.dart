import 'dart:io';

import 'package:yabo_bank/base/interactor/BaseInteractor.dart';
import 'package:yabo_bank/data/network/ApiHelper.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/data/preferences/PreferenceHelper.dart';

import 'RequestAddMVPInteractor.dart';

class RequestAddInteractor extends BaseInteractor implements RequestAddMVPInteractor
{
  RequestAddInteractor(PreferenceHelper preferenceHelper, ApiHelper apiHelper) : super(preferenceHelper, apiHelper);
  @override
  Future<ApiResponse> doCreateRequests(dynamic formData, File image) async {
    return apiHelper.performCreateRequests( formData, image ).then( ( ApiResponse response ){
                  return response;
              } );
  }
  
  @override
  Future<ApiResponse> doGetPriceLists() {
    return apiHelper.performGetPriceLists().then( ( ApiResponse response ){
        return response;
    });
  }
}