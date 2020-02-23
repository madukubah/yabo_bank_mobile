import 'dart:convert';
import 'dart:io';

import 'package:yabo_bank/model/Account.dart';
import 'package:yabo_bank/model/Mutation.dart';
import 'package:yabo_bank/model/PriceList.dart';
import 'package:yabo_bank/model/ProcessedRequest.dart';
import 'package:yabo_bank/model/Request.dart';
import 'package:yabo_bank/util/fetch_data_exception.dart';
import 'package:mime/mime.dart';

import '../preferences/AppPreferenceHelper.dart';
import 'ApiEndPoint.dart';
import 'ApiHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

import 'response/ApiResponse.dart';

class AppApiHelper extends ApiHelper {
  static final AppApiHelper _singleton = AppApiHelper._internal();
  AppApiHelper._internal();
  static AppApiHelper getInstance() {
    if (_singleton == null) {
      return new AppApiHelper._internal();
    }
    return _singleton;
  }

  Map<String, String> headers = {"Content-type": "application/json"};
  @override
  Future<ApiResponse> performServerLogin(loginRequest) async {
    ////print( loginRequest );
    return http
        .post(ApiEndPoint.LOGIN, body: loginRequest.toJson())
        .then((http.Response response) {
      final String jsonBody = response.body;
      // ////print( jsonBody );
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
      final loginContainer = JsonDecoder().convert(jsonBody);
      ////print( loginContainer['data']['user']['token'] );
      // return null;
      return ApiResponse.fromMap(loginContainer);
    });
  }

  @override
  Future<ApiResponse> performServerRegister(Object registerData) async {
    //print('performServerRegister');
    return http
        .post(ApiEndPoint.REGISTER, body: registerData)
        .then((http.Response response) {
      final String jsonBody = response.body;
      //print(jsonBody);
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      final container = JsonDecoder().convert(jsonBody);

      return ApiResponse.fromMap(container);
    });
  }

  @override
  Future<ApiResponse> performServerUpdateUser(dynamic userData) async {
    userData['_method'] = 'PUT';
    Object dataBody = userData;
    //print(dataBody);
    Map<String, String> requestHeaders = {
      //  'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };

    return http
        .post(
      ApiEndPoint.UPDATE_USER + "/${userData['user_id']}",
      body: dataBody,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // //print( jsonBody );
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      final container = JsonDecoder().convert(jsonBody);

      return ApiResponse.fromMap(container);
    });
  }

  @override
  Future<ApiResponse> performUserUploadImage(File image) async {
    Map<String, String> requestHeaders = {
      //  'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    //print(mimeTypeData);
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse(ApiEndPoint.USER_UPLOAD_PROFILE));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('photo', image.path,
        // contentType: MediaType  );
        contentType: http_parser.MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.headers.addAll(requestHeaders);
    // return null;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }

      final String jsonBody = response.body;
      //////print( jsonBody );
      final container = JsonDecoder().convert(jsonBody);
      // _resetState();
      // return responseData;
      return ApiResponse.fromMap(container);
    } catch (e) {
      ////print(e);
      return null;
    }
  }

  @override
  Future<ApiResponse> performGetMutations( String startDate, String endDate ) {
    ////print( "getMutations " );
    // Map<String, String> form = {'info': formData['info']};

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };
    return http
        .get(
      ApiEndPoint.GET_MUTATIONS + "?start=$startDate&end=$endDate",
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // ////print( jsonBody );
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        return new ApiResponse(
            success: false, message: '${response.reasonPhrase}', data: null);
        // throw new FetchDataException(
        //     "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
      // return null;
      final container = JsonDecoder().convert(jsonBody);
      final List<dynamic> mutations = container['data']['mutations'];
      return new ApiResponse(
          success: container['success'],
          message: container['message'],
          data: Account(
            balance: container['data']['balance'],
            credit: container['data']['credit'],
            debit: container['data']['debit'],
            mutations: mutations.map((raw) {
              return Mutation.fromMap(raw);
            }).toList(),
          ));
    });
  }

  @override
  Future<ApiResponse> performGetRequests() {
    ////print( "performGetRequests " );

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };
    return http
        .get(
      ApiEndPoint.GET_REQUEST,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // ////print( jsonBody );
      // return null;
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        return new ApiResponse(
            success: false, message: '${response.reasonPhrase}', data: null);
        // throw new FetchDataException(
        //     "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
      // return null;
      final container = JsonDecoder().convert(jsonBody);
      final List<dynamic> requests = container['data']['unprocess_request'];
      final List<dynamic> processedRequests =
          container['data']['processed_request'];
      return new ApiResponse(
          success: container['success'],
          message: container['message'],
          data: [
            requests.map((raw) {
              return Request.fromMap(raw);
            }).toList(),
            processedRequests.map((raw) {
              return ProcessedRequest.fromMap(raw);
            }).toList()
          ]);
    });
  }

  @override
  Future<ApiResponse> performServerLogOut() {
    //print("performGetRequests ");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };
    return http
        .get(
      ApiEndPoint.LOGOUT,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // //print( jsonBody );
      // return null;
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        return new ApiResponse(
            success: false, message: '${response.reasonPhrase}', data: null);
        // throw new FetchDataException(
        //     "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }
      return null;
    });
  }

  @override
  Future<ApiResponse> performCreateRequests(
      Map<String, String> formData, File image) async {
    // Map<String, String> form = {'info': formData['info']};
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(ApiEndPoint.CREATE_REQUEST));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('photo', image.path,
        // contentType: MediaType  );
        contentType: http_parser.MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.headers.addAll(requestHeaders);
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields.addAll(formData);

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }

      final String jsonBody = response.body;
      final container = JsonDecoder().convert(jsonBody);

      return ApiResponse(
        success: container['success'],
        message: container['message'],
        data: null,
      );
    } catch (e) {
      ////print(e);
      return null;
    }

  }

  @override
  Future<ApiResponse> performDeleteRequests(int requestId) {
    Object form = {'_method': "DELETE"};
    //print(requestId);
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };

    return http
        .post(
      ApiEndPoint.DELETE_REQUEST + "/$requestId",
      body: form,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // //print( jsonBody );
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        throw new FetchDataException(
            "Error while getting contacts [StatusCode:$statusCode, Error:${response.reasonPhrase}]");
      }

      final container = JsonDecoder().convert(jsonBody);

      return ApiResponse(
        success: container['success'],
        message: container['message'],
        data: null,
      );
    });
  }

  @override
  Future<ApiResponse> performUserUploadIdentityPhoto(File image) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    //print(mimeTypeData);
    final imageUploadRequest = http.MultipartRequest(
        'POST', Uri.parse(ApiEndPoint.USER_UPLOAD_IDENTITY_PHOTO));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('photo', image.path,
        // contentType: MediaType  );
        contentType: http_parser.MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.files.add(file);
    imageUploadRequest.headers.addAll(requestHeaders);
    // return null;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }

      final String jsonBody = response.body;
      final container = JsonDecoder().convert(jsonBody);

      return ApiResponse.fromMap(container);
    } catch (e) {
      ////print(e);
      return null;
    }
  }

  @override
  Future<ApiResponse> performGetUser() {
    
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };
    return http
        .get(
      ApiEndPoint.USER_PROFILE,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      // return null;
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        return new ApiResponse(
            success: false, message: '${response.reasonPhrase}', data: null);
        }
      final container = JsonDecoder().convert(jsonBody);
      return ApiResponse.fromMap(container);

    });
  }

  @override
  Future<ApiResponse> performGetPriceLists() {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${AppPreferenceHelper.getInstance().getAccessToken()}'
    };
    return http
        .get(
      ApiEndPoint.GET_PRICELIST,
      headers: requestHeaders,
    )
        .then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;
      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        return new ApiResponse(
            success: false, message: '${response.reasonPhrase}', data: null);
      }
      // return null;
      final container = JsonDecoder().convert(jsonBody);
      List<dynamic> priceLists = container['data'];

      return new ApiResponse(
        success: container['success'],
        message: container['message'],
        data: priceLists.map((raw) {
          return PriceList.fromMap(raw);
        }).toList(),
      );
    });
  }
  
}
