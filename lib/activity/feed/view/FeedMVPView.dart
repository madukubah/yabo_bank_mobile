import 'package:yabo_bank/base/view/MVPView.dart';
import 'package:yabo_bank/model/News.dart';
import 'package:yabo_bank/model/Promotion.dart';
import 'package:yabo_bank/model/RubbishSummary.dart';
import 'package:yabo_bank/model/User.dart';
// import 'package:customer/model/Group.dart';

abstract class FeedMVPView extends MVPView {
  void showMessage( String message, int status );
  void onUserLoad( User user );
  void onRubbishSummaryLoad( List<RubbishSummary> rubbishSummaries );
  void onPromotionsLoad( List<Promotion> promotions );
  void onNewsLoad( List<News> news );
}