import 'package:yabo_bank/data/network/ApiHelper.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/data/preferences/PreferenceHelper.dart';
import 'package:yabo_bank/model/User.dart';
import 'package:yabo_bank/util/AppConstants.dart';

import 'MVPInteractor.dart';

class BaseInteractor extends MVPInteractor
{
  final PreferenceHelper preferenceHelper ;
  final  ApiHelper apiHelper ;

  BaseInteractor(  this.preferenceHelper, this.apiHelper );

  
  @override
  Future< bool > isUserLoggedIn() async {
    return apiHelper.performGetUser(  ).then( ( ApiResponse response ){
      if( response.success != null ){
          this.updateUserInSharedPref(response, LoggedInMode.LOGGED_IN_MODE_SERVER);
          return response.success;
      }
      return false;
    } );
    // return  this.preferenceHelper.getCurrentUserLoggedInMode() != LoggedInMode.LOGGED_IN_MODE_LOGGED_OUT.index;
  }

  @override
  void performUserLogout() {
    this.preferenceHelper.setCurrentUserLoggedInMode( LoggedInMode.LOGGED_IN_MODE_LOGGED_OUT );
    this.preferenceHelper.setCurrentUserId( null );
    this.preferenceHelper.setAccessToken( null );
    this.preferenceHelper.setCurrentUserEmail( "" );
    this.preferenceHelper.setCurrentUserPhoto( "assets/images/as.png" );
  }

  @override
  void updateUserInSharedPref(ApiResponse loginResponse, LoggedInMode loggedInMode) {
    User user = loginResponse.data;
    if( user != null )
    {
        if( ! ( user.token == '' || user.token == null ) )
            preferenceHelper.setAccessToken( user.token );

        if( ! ( user.status == null ) )
            preferenceHelper.setCurrentCustomerStatus( user.status );
            
        preferenceHelper.setCurrentUserLoggedInMode( loggedInMode );
        preferenceHelper.setCurrentUserId( user.id );
        preferenceHelper.setCurrentUserName( user.name );
        preferenceHelper.setCurrentUserEmail( user.email );
        preferenceHelper.setCurrentUserPhoto( user.photo );
        preferenceHelper.setCurrentIdentityPhoto( user.identity_photo );
        preferenceHelper.setCurrentUserPhone( user.phone );
        preferenceHelper.setCurrentUserAddress( user.address );
        preferenceHelper.setCurrentMapPoint( user.map_point );
        preferenceHelper.setCurrentUserableType( user.userable_type );
        preferenceHelper.setCurrentUserableId( user.userable_id );
    }

  }
}