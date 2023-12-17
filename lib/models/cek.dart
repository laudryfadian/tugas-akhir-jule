class Cek {
  Cek({
    required this.status,
    required this.statusCode,
    required this.timestamp,
    required this.message,
    required this.result,
  });
  late final bool status;
  late final int statusCode;
  late final String timestamp;
  late final String message;
  late final Result result;

  Cek.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    timestamp = json['timestamp'];
    message = json['message'];
    result = Result.fromJson(json['result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['statusCode'] = statusCode;
    _data['timestamp'] = timestamp;
    _data['message'] = message;
    _data['result'] = result.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.data,
  });
  late final Data data;

  Result.fromJson(Map<String, dynamic> json) {
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.jam1,
    required this.jam2,
    required this.jam3,
    required this.jam4,
    required this.route,
  });
  late final bool jam1;
  late final bool jam2;
  late final bool jam3;
  late final bool jam4;
  late final String route;

  Data.fromJson(Map<String, dynamic> json) {
    jam1 = json['jam1'];
    jam2 = json['jam2'];
    jam3 = json['jam3'];
    jam4 = json['jam4'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jam1'] = jam1;
    _data['jam2'] = jam2;
    _data['jam3'] = jam3;
    _data['jam4'] = jam4;
    _data['route'] = route;
    return _data;
  }
}
