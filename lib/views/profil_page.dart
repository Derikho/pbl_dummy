import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/user_model.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final DataService _dataService = DataService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = _dataService.currentUser;
    final isLoggedIn = user.isLoggedIn;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        isLoggedIn ? user.nama : 'PoliKos',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[600]!,
                              Colors.blue[300]!,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.home_work,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLoggedIn)
                            _buildLoginSection()
                          else
                            _buildProfileSection(user),
                          
                          const SizedBox(height: 24),
                          _buildMenuSection(isLoggedIn),
                          
                          if (isLoggedIn)
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: _buildLogoutButton(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'Temukan kos impianmu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masuk Sebagai',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih jenis akun untuk melanjutkan',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildLoginCard(
                  icon: Icons.person_search,
                  title: 'Login sebagai Pencari Kos',
                  subtitle: 'Cari, simpan, dan beri rating kos',
                  color: Colors.blue,
                  onTap: () => _handleLogin(UserRole.pencariKos),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLoginCard(
                  icon: Icons.business,
                  title: 'Login sebagai Pemilik Kos',
                  subtitle: 'Kelola listing dan dashboard',
                  color: Colors.green,
                  onTap: () => _handleLogin(UserRole.pemilikKos),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1), // Perbaikan: denganValues instead of withOpacity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[100],
            child: Text(
              user.nama.isNotEmpty ? user.nama[0] : 'U',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: user.role == UserRole.pencariKos 
                  ? Colors.blue[50] 
                  : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role == UserRole.pencariKos 
                  ? 'Pencari Kos' 
                  : 'Pemilik Kos',
              style: TextStyle(
                color: user.role == UserRole.pencariKos 
                    ? Colors.blue[700] 
                    : Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(bool isLoggedIn) {
    final List<Map<String, dynamic>> menus = [
      {
        'icon': Icons.history,
        'title': 'Riwayat Pencarian',
        'subtitle': 'Lihat riwayat pencarian kos',
        'requiresLogin': true,
      },
      {
        'icon': Icons.star_border,
        'title': 'Rating & Review',
        'subtitle': 'Lihat rating dan review kos',
        'requiresLogin': true,
      },
      {
        'icon': Icons.notifications_none,
        'title': 'Notifikasi',
        'subtitle': 'Pengaturan notifikasi',
        'requiresLogin': false,
      },
      {
        'icon': Icons.settings,
        'title': 'Pengaturan',
        'subtitle': 'Pengaturan aplikasi',
        'requiresLogin': false,
      },
      {
        'icon': Icons.help_outline,
        'title': 'Bantuan',
        'subtitle': 'Pusat bantuan dan FAQ',
        'requiresLogin': false,
      },
      {
        'icon': Icons.info_outline,
        'title': 'Tentang Aplikasi',
        'subtitle': 'Versi 1.0.0',
        'requiresLogin': false,
      },
    ];

    final filteredMenus = isLoggedIn 
        ? menus 
        : menus.where((menu) => menu['requiresLogin'] == false).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...filteredMenus.map((menu) => _buildMenuItem(menu)),
      ],
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> menu) {
    return ListTile(
      leading: Icon(menu['icon'], color: Colors.blue[600]),
      title: Text(menu['title']),
      subtitle: Text(menu['subtitle']),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {
        if (menu['requiresLogin'] == true && !_dataService.currentUser.isLoggedIn) {
          _showLoginRequiredDialog();
        } else {
          _handleMenuTap(menu['title']);
        }
      },
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: _showLogoutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleLogin(UserRole role) async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _dataService.login(role);
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil login sebagai ${role == UserRole.pencariKos ? "Pencari Kos" : "Pemilik Kos"}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleLogout() async {
    setState(() {
      _isLoading = true;
    });

    // Simulasi proses logout
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _dataService.logout();
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil logout'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _handleLogout();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Login Diperlukan'),
          content: const Text('Silakan login terlebih dahulu untuk mengakses fitur ini.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Nanti Saja'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Scroll ke bagian login
                // Atau bisa juga panggil method untuk fokus ke login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Silakan pilih jenis akun di atas'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Login Sekarang'),
            ),
          ],
        );
      },
    );
  }

  void _handleMenuTap(String menuTitle) {
    // Handle menu tap berdasarkan title
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur $menuTitle akan segera hadir'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}