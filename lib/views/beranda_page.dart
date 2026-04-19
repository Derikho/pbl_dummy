import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/kos_card.dart';
import '../widgets/loading_widget.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGender = 'Semua';
  final DataService _dataService = DataService();
  bool _isLoading = false;
  
  final List<String> _universitas = [
    'ITB',
    'UGM',
    'UI',
    'ITS',
    'Unpad',
    'Universitas Brawijaya'
  ];
  
  final List<String> _genderOptions = ['Semua', 'Putra', 'Putri', 'Kampur', 'Campur'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _getFilteredKos(String tag) {
    final allKos = _dataService.allKos;
    return allKos.where((kos) {
      if (kos.tag != tag) return false;
      
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!kos.nama.toLowerCase().contains(query) &&
            !kos.lokasi.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      if (_selectedGender != 'Semua' && kos.gender != _selectedGender) {
        return false;
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const LoadingWidget(message: 'Memuat data kos...')
            : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Selamat datang di PoliKos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '🔍 Cari kos, kampus, atau kota...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _universitas.length,
                      itemBuilder: (context, index) {
                        return _buildUniversityChip(_universitas[index]);
                      },
                    ),
                  ),
                  
                  _buildMapPromotionCard(),
                  
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Featured'),
                              Tab(text: 'Favorit'),
                            ],
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        
                        SizedBox(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: _genderOptions.length,
                            itemBuilder: (context, index) {
                              final gender = _genderOptions[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(gender),
                                  selected: _selectedGender == gender,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedGender = gender;
                                    });
                                  },
                                  selectedColor: Colors.blue[100],
                                  backgroundColor: Colors.grey[200],
                                  labelStyle: TextStyle(
                                    color: _selectedGender == gender ? Colors.blue[800] : Colors.grey[600],
                                    fontWeight: _selectedGender == gender ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildKosList('Featured'),
                              _buildKosList('Favorit'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildUniversityChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchQuery = label;
          _searchController.text = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(label),
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMapPromotionCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[300]!],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kos lewat peta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Cari kos sesuai lokasi pilihanmu',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.map, color: Colors.blue),
          ),
        ],
      ),
    );
  }
  
  Widget _buildKosList(String tag) {
    final kosList = _getFilteredKos(tag);
    
    if (kosList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada kos yang ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kosList.length,
      itemBuilder: (context, index) {
        final kos = kosList[index];
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
}