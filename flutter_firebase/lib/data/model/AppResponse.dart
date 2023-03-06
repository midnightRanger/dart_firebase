import '../utils/exception_codes.dart';

enum StatusCode {
  SUCCESS, 
  ERROR
}

class AppResponse{
     int? id;
     StatusCode? statucCode;
     dynamic data;

     AppResponse(this.id, this.statucCode,{ this.data}); 
}