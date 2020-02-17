import 'package:yabo_bank/util/AppConstants.dart';

abstract class PreferenceHelper {
  int getCurrentUserLoggedInMode(  );
  void setCurrentUserLoggedInMode( LoggedInMode mode );
  int getCurrentUserId(  );
  void setCurrentUserId( int userId );

  String getCurrentUserName(  );
  void setCurrentUserName( String userName );

  String getCurrentUserEmail(  );
  void setCurrentUserEmail( String email );

  String getCurrentUserPhone(  );
  void setCurrentUserPhone( String phone );

  String getCurrentUserPassword(  );
  void setCurrentUserPassword( String password );

  String getAccessToken(  );
  void setAccessToken( String accessToken );

   String getCurrentUserPhoto(  );
  void setCurrentUserPhoto( String imageUrl );

  String getCurrentUserFirstName(  );
  void setCurrentUserFirstName( String firstName );

  String getCurrentUserLastName(  );
  void setCurrentUserLastName( String lastName );

  String getCurrentUserGroupName(  );
  void setCurrentUserGroupName( String groupName );

  String getCurrentUserAddress(  );
  void setCurrentUserAddress( String address );

  String getCurrentIdentityPhoto(  );
  void setCurrentIdentityPhoto( String identityPhoto );

  String getCurrentMapPoint(  );
  void setCurrentMapPoint( String mapPoint );

  String getCurrentUserableType(  );
  void setCurrentUserableType( String userableType );

  int getCurrentUserableId(  );
  void setCurrentUserableId( int userableId );

  int getCurrentCustomerStatus(  );
  void setCurrentCustomerStatus( int status );
  
}