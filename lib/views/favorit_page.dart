import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/kos_card.dart';
import '../widgets/loading_widget.dart';
import '../models/user_model.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  final DataService _dataService = DataService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final favoriteKos = _dataService.favoriteKos;
    final isLoggedIn = _dataService.currentUser.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (isLoggedIn && favoriteKos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteAllDialog,
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _buildBody(isLoggedIn, favoriteKos),
    );
  }

  Widget _buildBody(bool isLoggedIn, List<dynamic> favoriteKos) {
    if (!isLoggedIn) {
      return _buildLoginRequiredView();
    }

    if (favoriteKos.isEmpty) {
      return _buildEmptyFavoritesView();
    }

    return _buildFavoritesList(favoriteKos);
  }

  Widget _buildLoginRequiredView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada favorit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Login sebagai Pencari Kos untuk menyimpan kos favoritmu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _showLoginDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Login Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFavoritesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada kos favorit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan kos ke favorit dengan menekan tombol hati',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Kembali ke halaman beranda
              Navigator.pop(context);
            },
            icon: const Icon(Icons.search),
            label: const Text('Cari Kos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<dynamic> favoriteKos) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteKos.length,
      itemBuilder: (context, index) {
        final kos = favoriteKos[index];
        return KosCard(
          kos: kos,
          onFavoriteToggle: () {
            setState(() {
              _dataService.toggleFavorite(kos);
            });
          },
        );
      },
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pilih Jenis Akun'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_search, color: Colors.blue),
                title: const Text('Pencari Kos'),
                subtitle: const Text('Cari, simpan, dan beri rating kos'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _handleLogin(UserRole.pencariKos);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.business, color: Colors.green),
                title: const Text('Pemilik Kos'),
                subtitle: const Text('Kelola listing dan dashboard'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  _handleLogin(UserRole.pemilikKos);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin(UserRole role) async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 1));
    
    // Cek apakah widget masih mounted sebelum melakukan setState
    if (mounted) {
      setState(() {
        if (role == UserRole.pencariKos) {
          _dataService.login(UserRole.pencariKos);
        } else {
          _dataService.login(UserRole.pemilikKos);
        }
        _isLoading = false;
      });
      
      // Gunakan mounted check untuk ScaffoldMessenger
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
      }
    }
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Semua Favorit'),
          content: const Text('Apakah Anda yakin ingin menghapus semua kos favorit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  setState(() {
                    for (var kos in _dataService.favoriteKos.toList()) {
                      _dataService.removeFromFavorite(kos.id);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua favorit telah dihapus')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}