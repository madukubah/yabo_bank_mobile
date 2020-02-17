import 'dart:io';

import 'package:yabo_bank/base/interactor/MVPInteractor.dart';
import 'package:yabo_bank/data/network/response/ApiResponse.dart';

abstract class RequestAddMVPInteractor extends MVPInteractor {
  Future<ApiResponse> doCreateRequests( dynamic formData, File image );
  Future<ApiResponse> doGetPriceLists(  );
  // Future<List<Group>> getGroups();
  
}