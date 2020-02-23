import 'package:yabo_bank/base/view/MVPView.dart';
import 'package:yabo_bank/model/User.dart';
// import 'package:customer/model/Group.dart';

abstract class ProfileMVPView extends MVPView {
  Future<void> showMessage( String message, int status );
  void showProgressCircle(  );
  void hideProgressCircle(  );
  void onUserLoad( User user );
}