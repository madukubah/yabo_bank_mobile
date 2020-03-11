
import 'package:yabo_bank/activity/feed/interactor/FeedMVPInteractor.dart';
import 'package:yabo_bank/activity/feed/view/FeedMVPView.dart';
import 'package:yabo_bank/base/presenter/BasePresenter.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/util/AppConstants.dart';

import 'FeedMVPPresenter.dart';


class FeedPresenter < V extends FeedMVPView , I extends FeedMVPInteractor > extends BasePresenter< V, I > implements FeedMVPPresenter<V, I>
{
  FeedPresenter(FeedMVPInteractor interactor) : super(interactor);

   @override
  void getUser() async {
    this.getView().showProgress();

    interactor.doGetUser(  ).then( ( ApiResponse response ){
        this.getView().hideProgress(  );

        if( response.data == null ) return;

        interactor.updateUserInSharedPref( response, LoggedInMode.LOGGED_IN_MODE_SERVER );
        this.getView().onUserLoad( response.data );
    });
  }

  @override
  void getRubbishSummary() {
    interactor.doGetRubbishSummary(  ).then( ( ApiResponse response ){
        if( response.data == null ) return;

        this.getView().onRubbishSummaryLoad( response.data );
    });
  }

  @override
  void getPromotions() {
    interactor.doGetPromotions(  ).then( ( ApiResponse response ){
        if( response.data == null ) return;

        this.getView().onPromotionsLoad( response.data );
    });
  }

  @override
  void getNews() {
    interactor.doGetNews(  ).then( ( ApiResponse response ){
        if( response.data == null ) return;

        this.getView().onNewsLoad( response.data );
    });
  }
  
}