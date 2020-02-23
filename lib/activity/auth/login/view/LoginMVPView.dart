import 'package:yabo_bank/base/view/MVPView.dart';

abstract class LoginMVPView extends MVPView
{
    void showValidationMessage( int errorCode );
    Future<void> showMessage( String message, bool status );
    void openMainAvtivity(  );
}