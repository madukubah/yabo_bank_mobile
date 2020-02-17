import 'package:yabo_bank/util/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PreferenceHelper.dart';

class AppPreferenceHelper extends PreferenceHelper
{
  static const PREF_KEY_USER_LOGGED_IN_MODE = "PREF_KEY_USER_LOGGED_IN_MODE";
  static const PREF_KEY_CURRENT_USER_ID = "PREF_KEY_CURRENT_USER_ID";
  static const PREF_KEY_ACCESS_TOKEN = "PREF_KEY_ACCESS_TOKEN";

  static const PREF_KEY_CURRENT_USER_NAME = "PREF_KEY_CURRENT_USER_NAME";
  static const PREF_KEY_CURRENT_USER_EMAIL = "PREF_KEY_CURRENT_USER_EMAIL";
  static const PREF_KEY_CURRENT_USER_PHONE = "PREF_KEY_CURRENT_USER_PHONE";
  static const PREF_KEY_CURRENT_USER_PASSWORD = "PREF_KEY_CURRENT_USER_PASSWORD";

  static const PREF_KEY_CURRENT_USER_PHOTO = "PREF_KEY_CURRENT_USER_PHOTO";
  static const PREF_KEY_CURRENT_USER_IDENTITY_PHOTO = "PREF_KEY_CURRENT_USER_IDENTITY_PHOTO";
  static const PREF_KEY_CURRENT_USER_MAP_POINT = "PREF_KEY_CURRENT_USER_MAP_POINT";
  static const PREF_KEY_CURRENT_USER_ABLE_TYPE = "PREF_KEY_CURRENT_USER_ABLE_TYPE";
  static const PREF_KEY_CURRENT_USER_ABLE_ID = "PREF_KEY_CURRENT_USER_ABLE_ID";

  static const PREF_KEY_CURRENT_USER_ADDRESS = "PREF_KEY_CURRENT_USER_ADDRESS";
  static const PREF_KEY_CURRENT_USER_FNAME = "PREF_KEY_CURRENT_USER_FNAME";
  static const PREF_KEY_CURRENT_USER_LNAME = "PREF_KEY_CURRENT_USER_LNAME";
  static const PREF_KEY_CURRENT_USER_GROUP_NAME = "PREF_KEY_CURRENT_USER_GROUP_NAME";

  static const PREF_KEY_CURRENT_CUSTOMER_STATUS = "PREF_KEY_CURRENT_CUSTOMER_STATUS";

  // Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
  SharedPreferences sharedPreferences;

  static  AppPreferenceHelper _singleton ;
  static AppPreferenceHelper getInstance()
  {
    if( _singleton == null )
    {
      return _singleton =  AppPreferenceHelper();
    }
    return _singleton;
  }

  AppPreferenceHelper()
  {
    _init(  ) ;
  }
  _init(  ) async {
    sharedPreferences = await SharedPreferences.getInstance();
    // this.setCurrentUserLoggedInMode(LoggedInMode.LOGGED_IN_MODE_LOGGED_OUT);
  }
  @override
  String getAccessToken() {
    return sharedPreferences.getString( PREF_KEY_ACCESS_TOKEN );
  }

  @override
  String getCurrentUserEmail() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_EMAIL );
  }

  @override
  int getCurrentUserId() {
      var userId = sharedPreferences.getInt( PREF_KEY_CURRENT_USER_ID );
      if( userId == AppConstants.NULL_INDEX ) return null;
      return userId;
  }

  @override
  int getCurrentUserLoggedInMode() {
    return sharedPreferences.getInt( PREF_KEY_USER_LOGGED_IN_MODE );
  }

  @override
  String getCurrentUserName() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_NAME );

  }

  @override
  void setAccessToken(String accessToken) {
    sharedPreferences.setString(PREF_KEY_ACCESS_TOKEN, accessToken);

  }

  @override
  void setCurrentUserEmail(String email) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_EMAIL, email);

  }

  @override
  void setCurrentUserId(int userId) {
    userId = ( userId == null ) ? AppConstants.NULL_INDEX : userId ;
    sharedPreferences.setInt(PREF_KEY_CURRENT_USER_ID, userId);
  }

  @override
  void setCurrentUserLoggedInMode(LoggedInMode mode) {
    sharedPreferences.setInt(PREF_KEY_USER_LOGGED_IN_MODE, mode.index );
  }

  @override
  void setCurrentUserName(String userName) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_NAME, userName);
  }

  @override
  String getCurrentUserPassword() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_PASSWORD );
  }

  @override
  String getCurrentUserPhone() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_PHONE );
  }

  @override
  void setCurrentUserPassword(String password) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_PASSWORD, password);
  }

  @override
  void setCurrentUserPhone(String phone) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_PHONE, phone);
  }

  @override
  String getCurrentUserPhoto() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_PHOTO );    
  }

  @override
  void setCurrentUserPhoto(String imageUrl) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_PHOTO, imageUrl);
  }

  @override
  String getCurrentUserAddress() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_ADDRESS );    
  }

  @override
  String getCurrentUserFirstName() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_FNAME );    
  }

  @override
  String getCurrentUserGroupName() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_GROUP_NAME );    
  }

  @override
  String getCurrentUserLastName() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_LNAME );    
  }

  @override
  void setCurrentUserAddress(String address) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_ADDRESS, address);
  }

  @override
  void setCurrentUserFirstName(String firstName) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_FNAME, firstName);
  }

  @override
  void setCurrentUserGroupName(String groupName) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_GROUP_NAME, groupName);
  }

  @override
  void setCurrentUserLastName(String lastName) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_LNAME, lastName);
  }

  @override
  String getCurrentIdentityPhoto() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_IDENTITY_PHOTO );    
  }

  @override
  void setCurrentIdentityPhoto(String identityPhoto) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_IDENTITY_PHOTO, identityPhoto);
  }

  @override
  String getCurrentMapPoint() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_MAP_POINT );    
  }

  @override
  void setCurrentMapPoint(String mapPoint) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_MAP_POINT, mapPoint);
    
  }

  @override
  String getCurrentUserableType() {
    return sharedPreferences.getString( PREF_KEY_CURRENT_USER_ABLE_TYPE );    
  }

  @override
  void setCurrentUserableType(String userableType) {
    sharedPreferences.setString(PREF_KEY_CURRENT_USER_ABLE_TYPE, userableType);
  }

  @override
  int getCurrentUserableId() {
    return sharedPreferences.getInt( PREF_KEY_CURRENT_USER_ABLE_ID );    
  }

  @override
  void setCurrentUserableId(int userableId) {
    sharedPreferences.setInt(PREF_KEY_CURRENT_USER_ABLE_ID, userableId);
  }

  @override
  int getCurrentCustomerStatus() {
      return sharedPreferences.getInt( PREF_KEY_CURRENT_CUSTOMER_STATUS );    

  }

  @override
  void setCurrentCustomerStatus(int status) {
    sharedPreferences.setInt(PREF_KEY_CURRENT_CUSTOMER_STATUS, status);
  }
  
}