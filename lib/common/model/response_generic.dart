/*
    Created by Shitab Mir on 7 September 2021
 */

class GenericResponse {
  int? code;
  String? message;
  String? data;

  GenericResponse({this.code, this.message, this.data});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data;
    }
    return data;
  }
}
