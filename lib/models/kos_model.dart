class KosModel {
  final String id;
  final String nama;
  final String lokasi;
  final List<String> fasilitas;
  final double harga;
  final double rating;
  final int sisaKamar;
  final String tag;
  final String gender;
  final double latitude;
  final double longitude;

  KosModel({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.fasilitas,
    required this.harga,
    required this.rating,
    required this.sisaKamar,
    required this.tag,
    required this.gender,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      lokasi: json['lokasi'] ?? '',
      fasilitas: List<String>.from(json['fasilitas'] ?? []),
      harga: (json['harga'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      sisaKamar: json['sisaKamar'] ?? 0,
      tag: json['tag'] ?? 'Featured',
      gender: json['gender'] ?? 'Kampur',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'lokasi': lokasi,
      'fasilitas': fasilitas,
      'harga': harga,
      'rating': rating,
      'sisaKamar': sisaKamar,
      'tag': tag,
      'gender': gender,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}