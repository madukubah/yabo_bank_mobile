import 'package:yabo_bank/base/interactor/BaseInteractor.dart';
import 'package:yabo_bank/data/network/ApiHelper.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/data/preferences/PreferenceHelper.dart';

import 'FeedMVPInteractor.dart';

class FeedInteractor extends BaseInteractor implements FeedMVPInteractor
{
  FeedInteractor(PreferenceHelper preferenceHelper, ApiHelper apiHelper) : super(preferenceHelper, apiHelper);
  
  @override
  Future<ApiResponse> doGetUser( ) async {
    return apiHelper.performGetUser(  ).then( ( ApiResponse response ){
      return response;
    } );
  }

  @override
  Future<ApiResponse> doGetRubbishSummary() {
    return apiHelper.performGetRubbishSummary(  ).then( ( ApiResponse response ){
      return response;
    } );
  }

  @override
  Future<ApiResponse> doGetPromotions() {
    return apiHelper.performGetPromotions(  ).then( ( ApiResponse response ){
      return response;
    } );
  }

  @override
  Future<ApiResponse> doGetNews() {
    return apiHelper.performGetNews(  ).then( ( ApiResponse response ){
      return response;
    } );
  }
}