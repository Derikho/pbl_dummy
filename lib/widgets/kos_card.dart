import 'package:flutter/material.dart';
import '../models/kos_model.dart';
import '../views/detail_kos_page.dart';

class KosCard extends StatelessWidget {
  final KosModel kos;
  final VoidCallback? onFavoriteToggle;

  const KosCard({
    super.key,
    required this.kos,
    this.onFavoriteToggle,
  });

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
      return 'Rp ${(hargaDouble / 1000000).toStringAsFixed(1)}jt/bln';
    }
    return 'Rp ${hargaDouble.toStringAsFixed(0)}/bln';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKosPage(kos: kos),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getGenderColor(kos.gender),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          kos.gender, // Akan menampilkan 'Campur', 'Putra', atau 'Putri'
                          style: TextStyle(
                            color: _getGenderTextColor(kos.gender),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (onFavoriteToggle != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: Colors.red[400],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Body
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kos.nama,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kos.lokasi,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kos.fasilitas.join(' • '),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: kos.sisaKamar <= 2 ? Colors.red[50] : Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${kos.sisaKamar} sisa',
                          style: TextStyle(
                            color: kos.sisaKamar <= 2 ? Colors.red[700] : Colors.green[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGenderColor(String gender) {
    switch (gender) {
      case 'Putra':
        return Colors.blue[100]!;
      case 'Putri':
        return Colors.pink[100]!;
      case 'Campur':
      default:
        return Colors.purple[100]!;
    }
  }

  Color _getGenderTextColor(String gender) {
    switch (gender) {
      case 'Putra':
        return Colors.blue[800]!;
      case 'Putri':
        return Colors.pink[800]!;
      case 'Campur':
      default:
        return Colors.purple[800]!;
    }
  }
}