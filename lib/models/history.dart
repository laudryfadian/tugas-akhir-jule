class History {
  History({
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

  History.fromJson(Map<String, dynamic> json) {
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
  late final List<Data> data;

  Result.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.pegawais,
    required this.loc,
    required this.lat,
    required this.long,
    required this.foto,
    required this.tgl,
    required this.jam,
    required this.status,
  });
  late final String id;
  late final String pegawais;
  late final String loc;
  late final String lat;
  late final String long;
  late final String foto;
  late final String tgl;
  late final String jam;
  late final String status;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    pegawais = json['pegawais'];
    loc = json['loc'];
    lat = json['lat'];
    long = json['long'];
    foto = json['foto'];
    tgl = json['tgl'];
    jam = json['jam'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['pegawais'] = pegawais;
    _data['loc'] = loc;
    _data['lat'] = lat;
    _data['long'] = long;
    _data['foto'] = foto;
    _data['tgl'] = tgl;
    _data['jam'] = jam;
    _data['status'] = status;
    return _data;
  }
}
