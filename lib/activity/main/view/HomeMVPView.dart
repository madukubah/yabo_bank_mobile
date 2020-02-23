import 'package:yabo_bank/base/view/MVPView.dart';
// import 'package:customer/model/Group.dart';

abstract class HomeMVPView extends MVPView {
  void showMessage( String message, int status );
  void toLoginPage(  );
}