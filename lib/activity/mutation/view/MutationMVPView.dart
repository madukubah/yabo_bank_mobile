import 'package:yabo_bank/base/view/MVPView.dart';
import 'package:yabo_bank/model/Account.dart';
// import 'package:customer/model/Group.dart';

abstract class MutationMVPView extends MVPView {
  void showMessage( String message, int status );
  void setAccount( Account account );
}