import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/kos_card.dart';

class PetaPage extends StatefulWidget {
  const PetaPage({super.key});

  @override
  State<PetaPage> createState() => _PetaPageState();
}

class _PetaPageState extends State<PetaPage> {
  final DataService _dataService = DataService();
  String _selectedKota = 'Semua';
  
  final List<String> _kotaList = [
    'Semua',
    'Bandung',
    'Yogyakarta',
    'Jakarta',
    'Surabaya',
    'Malang',
  ];

  List<dynamic> get _filteredKos {
    if (_selectedKota == 'Semua') {
      return _dataService.allKos;
    }
    return _dataService.allKos.where((kos) {
      return kos.lokasi.contains(_selectedKota);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Kos'),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _showCurrentLocation,
            tooltip: 'Lokasi saya saat ini',
          ),
        ],
      ),
      body: Column(
        children: [
          // Map promotion card
          _buildMapPromotionCard(),
          
          // City filter
          _buildCityFilter(),
          
          // Map placeholder and kos list
          Expanded(
            child: _buildMapAndList(),
          ),
        ],
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

  Widget _buildCityFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _kotaList.length,
        itemBuilder: (context, index) {
          final kota = _kotaList[index];
          final isSelected = _selectedKota == kota;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(kota),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedKota = kota;
                });
              },
              selectedColor: Colors.blue[100],
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[800] : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapAndList() {
    return Column(
      children: [
        // Map placeholder (simulasi Google Maps)
        Container(
          height: 250,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              // Placeholder map
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://maps.googleapis.com/maps/api/staticmap?'
                      'center=-6.200000,106.816666&zoom=5&size=400x200&'
                      'markers=color:red%7C-6.8912,107.6106&'
                      'markers=color:blue%7C-7.7681,110.3775&'
                      'markers=color:green%7C-6.1989,106.8323&'
                      'key=YOUR_API_KEY_HERE',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Overlay text
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              
              // Info overlay
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Map data ©2026 Google, INEGI',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Location markers (simulasi)
              Positioned(
                top: 80,
                left: 100,
                child: _buildMapMarker('Kos Elite', Colors.red),
              ),
              Positioned(
                top: 120,
                left: 200,
                child: _buildMapMarker('Kos Putra', Colors.blue),
              ),
              Positioned(
                top: 150,
                left: 50,
                child: _buildMapMarker('Kos Harmoni', Colors.green),
              ),
            ],
          ),
        ),
        
        // Kos list near location
        Expanded(
          child: _buildKosList(),
        ),
      ],
    );
  }

  Widget _buildMapMarker(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKosList() {
    final kosList = _filteredKos;
    
    if (kosList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada kos di lokasi ini',
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

  void _showCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mendeteksi lokasi Anda saat ini...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulasi deteksi lokasi
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi: Indonesia (Jakarta)'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}