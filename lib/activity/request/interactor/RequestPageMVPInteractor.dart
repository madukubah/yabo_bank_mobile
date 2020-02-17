import 'package:yabo_bank/base/interactor/MVPInteractor.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';

abstract class RequestPageMVPInteractor extends MVPInteractor {
  Future<ApiResponse> doGetRequest(  );
  Future<ApiResponse> doDeleteRequests( int requestId );
  bool customerVerified( );
  
}