
import 'package:yabo_bank/activity/request/interactor/RequestPageMVPInteractor.dart';
import 'package:yabo_bank/activity/request/view/RequestPageMVPView.dart';
import 'package:yabo_bank/base/presenter/BasePresenter.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';

import 'RequestPageMVPPresenter.dart';


class RequestPagePresenter < V extends RequestPageMVPView , I extends RequestPageMVPInteractor > extends BasePresenter< V, I > implements RequestPageMVPPresenter<V, I>
{
  RequestPagePresenter(RequestPageMVPInteractor interactor) : super(interactor);

  @override
  void getRequests() {
    this.getView().showProgress(  );

    interactor.doGetRequest().then( ( ApiResponse response ){
          print( response );
          // return response;
          this.getView().setRequests( response.data[0] );
          this.getView().setProcessedRequests( response.data[1] );

          this.getView().hideProgress(  );

      } );
  }

  @override
  void deleteRequests( int requestId ) {
    this.getView().showProgress(  );

    interactor.doDeleteRequests( requestId ).then( ( ApiResponse response ){
          print( response );

          this.getView().hideProgress(  );
          this.getView().refresh(  );

      } );

  }

  @override
  void goToRequestAdd() {
    if( interactor.customerVerified() )
      this.getView().openRequestAdd(  );
    else
      this.getView().showModalNotVerified(  );

  }
}