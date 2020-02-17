import 'package:yabo_bank/activity/request/interactor/RequestPageMVPInteractor.dart';
import 'package:yabo_bank/activity/request/view/RequestPageMVPView.dart';

abstract class RequestPageMVPPresenter < V extends RequestPageMVPView , I extends RequestPageMVPInteractor > 
{
    void getRequests(  );
    void deleteRequests( int requestId );
    void goToRequestAdd(  );
}