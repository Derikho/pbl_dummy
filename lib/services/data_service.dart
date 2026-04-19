import '../models/kos_model.dart';
import '../models/user_model.dart';

class DataService {
  List<KosModel> _allKos = [];
  List<KosModel> _favoriteKos = [];
  UserModel _currentUser = UserModel.guest();

  List<KosModel> get allKos => _allKos;
  List<KosModel> get favoriteKos => _favoriteKos;
  UserModel get currentUser => _currentUser;

  // Constructor
  DataService() {
    _loadDummyData();
  }

  void _loadDummyData() {
    _allKos = [
      KosModel(
        id: '1',
        nama: 'Kos Harmoni Residence',
        lokasi: 'Jl. Dipatiukur No. 45, Bandung',
        fasilitas: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Parkir'],
        harga: 1200000,
        rating: 4.8,
        sisaKamar: 5,
        tag: 'Featured',
        gender: 'Kampur',
        latitude: -6.8912,
        longitude: 107.6106,
      ),
      KosModel(
        id: '2',
        nama: 'Kos Putri Sakura',
        lokasi: 'Jl. Kaliurang Km 5, Yogyakarta',
        fasilitas: ['WiFi', 'Kamar Mandi Dalam', 'Laundry'],
        harga: 900000,
        rating: 4.9,
        sisaKamar: 4,
        tag: 'Favorit',
        gender: 'Putri',
        latitude: -7.7681,
        longitude: 110.3775,
      ),
      KosModel(
        id: '3',
        nama: 'Kos Elite Menteng',
        lokasi: 'Jl. Menteng Raya No. 88, Jakarta',
        fasilitas: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Parkir'],
        harga: 2500000,
        rating: 4.7,
        sisaKamar: 1,
        tag: 'Featured',
        gender: 'Kampur',
        latitude: -6.1989,
        longitude: 106.8323,
      ),
      KosModel(
        id: '4',
        nama: 'Kos Cendana Premium',
        lokasi: 'Jl. Cihampelas No. 77, Bandung',
        fasilitas: ['WiFi', 'AC', 'Kamar Mandi Dalam', 'Gym'],
        harga: 1500000,
        rating: 4.7,
        sisaKamar: 5,
        tag: 'Featured',
        gender: 'Campur',
        latitude: -6.8912,
        longitude: 107.6106,
      ),
      KosModel(
        id: '5',
        nama: 'Kos Putra Mandiri',
        lokasi: 'Jl. Keputih No. 12, Surabaya',
        fasilitas: ['WiFi', 'Parkir Motor', 'Dapur Bersama'],
        harga: 750000,
        rating: 4.2,
        sisaKamar: 5,
        tag: 'Favorit',
        gender: 'Putra',
        latitude: -7.2575,
        longitude: 112.7521,
      ),
      KosModel(
        id: '6',
        nama: 'Kos Sejahtera',
        lokasi: 'Jl. Sumberasri No. 20, Malang',
        fasilitas: ['WiFi', 'Parkir Motor', 'Kamar Mandi Dalam'],
        harga: 600000,
        rating: 4.0,
        sisaKamar: 2,
        tag: 'Favorit',
        gender: 'Putra',
        latitude: -7.9797,
        longitude: 112.6304,
      ),
    ];

    _favoriteKos = [_allKos[1]];
  }

  void addToFavorite(KosModel kos) {
    if (!_favoriteKos.any((k) => k.id == kos.id)) {
      _favoriteKos.add(kos);
    }
  }

  void removeFromFavorite(String kosId) {
    _favoriteKos.removeWhere((kos) => kos.id == kosId);
  }

  bool isFavorite(String kosId) {
    return _favoriteKos.any((kos) => kos.id == kosId);
  }

  void toggleFavorite(KosModel kos) {
    if (isFavorite(kos.id)) {
      removeFromFavorite(kos.id);
    } else {
      addToFavorite(kos);
    }
  }

  void login(UserRole role) {
    _currentUser = UserModel(
      id: 'user_123',
      nama: role == UserRole.pencariKos ? 'John Doe' : 'Jane Smith',
      email: role == UserRole.pencariKos ? 'pencari@email.com' : 'pemilik@email.com',
      role: role,
      isLoggedIn: true,
    );
  }

  void logout() {
    _currentUser = UserModel.guest();
    _favoriteKos.clear();
  }
  
  KosModel? getKosById(String id) {
    try {
      return _allKos.firstWhere((kos) => kos.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<KosModel> searchKos(String query) {
    if (query.isEmpty) return _allKos;
    
    return _allKos.where((kos) {
      return kos.nama.toLowerCase().contains(query.toLowerCase()) ||
          kos.lokasi.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}