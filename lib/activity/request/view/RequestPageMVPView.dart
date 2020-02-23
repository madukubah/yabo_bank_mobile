import 'package:yabo_bank/base/view/MVPView.dart';
import 'package:yabo_bank/model/ProcessedRequest.dart';
import 'package:yabo_bank/model/Request.dart';
// import 'package:customer/model/Group.dart';

abstract class RequestPageMVPView extends MVPView {
  void showMessage( String message, int status );
  void setRequests( List<Request> items );
  void setProcessedRequests( List<ProcessedRequest> items );
  void refresh(  );
  void openRequestAdd(  );
  Future<void> showModalNotVerified(  );
}