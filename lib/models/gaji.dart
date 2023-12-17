class Gaji {
  Gaji({
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

  Gaji.fromJson(Map<String, dynamic> json) {
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
    required this.total,
    required this.tgl,
  });
  late final String id;
  late final Pegawais pegawais;
  late final int total;
  late final String tgl;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    pegawais = Pegawais.fromJson(json['pegawais']);
    total = json['total'];
    tgl = json['tgl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['pegawais'] = pegawais.toJson();
    _data['total'] = total;
    _data['tgl'] = tgl;
    return _data;
  }
}

class Pegawais {
  Pegawais({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.foto,
    required this.posisi,
  });
  late final String id;
  late final String nama;
  late final String alamat;
  late final String foto;
  late final String posisi;

  Pegawais.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    nama = json['nama'];
    alamat = json['alamat'];
    foto = json['foto'];
    posisi = json['posisi'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['nama'] = nama;
    _data['alamat'] = alamat;
    _data['foto'] = foto;
    _data['posisi'] = posisi;
    return _data;
  }
}
