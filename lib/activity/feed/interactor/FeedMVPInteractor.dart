import 'package:yabo_bank/base/interactor/MVPInteractor.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';

abstract class FeedMVPInteractor extends MVPInteractor {
    Future<ApiResponse> doGetUser( );
    Future<ApiResponse> doGetRubbishSummary(  );
    Future<ApiResponse> doGetPromotions(  );
    Future<ApiResponse> doGetNews(  );

}