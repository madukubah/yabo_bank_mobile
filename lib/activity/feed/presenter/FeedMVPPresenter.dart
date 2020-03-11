import 'package:yabo_bank/activity/feed/interactor/FeedMVPInteractor.dart';
import 'package:yabo_bank/activity/feed/view/FeedMVPView.dart';

abstract class FeedMVPPresenter < V extends FeedMVPView , I extends FeedMVPInteractor > 
{
    void getUser(  );
    void getRubbishSummary(  );
    void getPromotions(  );
    void getNews(  );
}