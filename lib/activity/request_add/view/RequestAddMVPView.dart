import 'dart:io';

import 'package:yabo_bank/base/view/MVPView.dart';
import 'package:yabo_bank/model/PriceList.dart';
// import 'package:customer/model/Group.dart';

abstract class RequestAddMVPView extends MVPView {
  Future<void> showMessage( String message, int status );
  void onImageLoad( File image );
  void setPriceLists( List<PriceList> items );
  void showProgressCircle(  );
  void hideProgressCircle(  );
  void backToRRequestList(  );
  // Future<void> showDialogError(  );
}