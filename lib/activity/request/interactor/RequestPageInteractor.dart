import 'package:yabo_bank/base/interactor/BaseInteractor.dart';
import 'package:yabo_bank/data/network/ApiHelper.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/data/preferences/PreferenceHelper.dart';

import 'RequestPageMVPInteractor.dart';

class RequestPageInteractor extends BaseInteractor implements RequestPageMVPInteractor
{
  RequestPageInteractor(PreferenceHelper preferenceHelper, ApiHelper apiHelper) : super(preferenceHelper, apiHelper);

  @override
  Future<ApiResponse> doGetRequest() {
        return apiHelper.performGetRequests( ).then( ( ApiResponse response ){
                  return response;
              } );
  }

  @override
  Future<ApiResponse> doDeleteRequests(int requestId) {
    return apiHelper.performDeleteRequests( requestId ).then( ( ApiResponse response ){
                  return response;
              } );
  }

  @override
  bool customerVerified() {
    if( preferenceHelper.getCurrentCustomerStatus() == 1 ) return true;
    else return false;
  }

}