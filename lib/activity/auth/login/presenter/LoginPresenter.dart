import 'dart:async';

import 'package:yabo_bank/activity/auth/login/interactor/LoginMVPInteractor.dart';
import 'package:yabo_bank/activity/auth/login/view/LoginMVPView.dart';
import 'package:yabo_bank/base/presenter/BasePresenter.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';
import 'package:yabo_bank/data/network/response/LoginResponse.dart';
import 'package:yabo_bank/util/AppConstants.dart';

import 'LoginMVPPresenter.dart';

class LoginPresenter< V extends LoginMVPView , I extends LoginMVPInteractor > extends BasePresenter< V, I > implements LoginMVPPresenter< V, I >
{
  LoginPresenter(I interactor) : super(interactor)
  {
    
  }

  @override
  void onServerLoginClicked(String email, String password) {
      this.getView().showProgress();  

      interactor.doServerLoginApiCall( 
           email,  password
      ).then(( ApiResponse loginResponse ){
        print( loginResponse );
        
        if( loginResponse == null ) return;
        this.getView().hideProgress();  
        if( loginResponse.success )
        {
            interactor.updateUserInSharedPref( loginResponse, LoggedInMode.LOGGED_IN_MODE_SERVER );
            this.getView().openMainAvtivity();  
            return;
        }
        this.getView().showMessage( loginResponse.message, loginResponse.success );
      });
  }

  @override
  Future start() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, (){
        interactor.isUserLoggedIn().then( ( bool loggedIn ){
          print( "isUserLoggedIn ${ loggedIn }" );
          if( loggedIn ) this.getView().openMainAvtivity(  );
        } );
    });
  }
  
}