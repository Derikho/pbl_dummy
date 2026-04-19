import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/kos_card.dart';
import '../widgets/loading_widget.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
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

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose();
    super.dispose();
  }

  // Mendapatkan kos pilihan (rating tertinggi, max 4)
  List<dynamic> get _kosPilihan {
    final allKos = _dataService.allKos;
    final sorted = List.from(allKos);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(4).toList();
  }

  // Mendapatkan semua kos (dengan filter pencarian)
  List<dynamic> get _semuaKos {
    final allKos = _dataService.allKos;
    if (_searchQuery.isEmpty) {
      return allKos;
    }
    return allKos.where((kos) {
      final query = _searchQuery.toLowerCase();
      return kos.nama.toLowerCase().contains(query) ||
          kos.lokasi.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const LoadingWidget(message: 'Memuat data kos...')
            : CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Column(
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
                        
                        // Search Bar
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
                        
                        // University Chips
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
                        
                        // Map Promotion Card
                        _buildMapPromotionCard(),
                        
                        // Kos Pilihan Section Title
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Kos Pilihan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Kos Pilihan List (Horizontal)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 280,
                      child: _kosPilihan.isEmpty
                          ? const Center(child: Text('Tidak ada kos pilihan'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: _kosPilihan.length,
                              itemBuilder: (context, index) {
                                final kos = _kosPilihan[index];
                                return Container(
                                  width: 280,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  child: _buildKosCardHorizontal(kos),
                                );
                              },
                            ),
                    ),
                  ),
                  
                  // Semua Kos Section Title
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        'Semua Kos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Semua Kos List (Vertical)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final kos = _semuaKos[index];
                        return KosCard(
                          kos: kos,
                          onFavoriteToggle: () {
                            setState(() {
                              _dataService.toggleFavorite(kos);
                            });
                          },
                        );
                      },
                      childCount: _semuaKos.length,
                    ),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
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
  
  Widget _buildKosCardHorizontal(dynamic kos) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: kos);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        kos.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          kos.tag,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kos.gender,
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kos.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: Colors.grey),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                kos.lokasi,
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kos.fasilitas.take(2).join(' • '),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatHarga(kos.harga),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kos.sisaKamar <= 2 ? Colors.red[50] : Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${kos.sisaKamar} sisa',
                            style: TextStyle(
                              color: kos.sisaKamar <= 2 ? Colors.red[700] : Colors.green[700],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
  
  String _formatHarga(dynamic harga) {
    double hargaDouble;
    if (harga is int) {
      hargaDouble = harga.toDouble();
    } else if (harga is double) {
      hargaDouble = harga;
    } else {
      hargaDouble = 0.0;
    }
    
    if (hargaDouble >= 1000000) {
      return 'Rp${(hargaDouble / 1000000).toStringAsFixed(1)}jt';
    }
    return 'Rp${hargaDouble.toStringAsFixed(0)}';
  }
}