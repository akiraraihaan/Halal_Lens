import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../models/halal_product.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({Key? key}) : super(key: key);

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  HalalProduct? _product;
  String? _barcode;
  String? _error;
  bool _loading = false;

  Future<void> _scanBarcode() async {
    setState(() {
      _loading = true;
      _error = null;
      _product = null;
    });
    try {
      var result = await BarcodeScanner.scan();
      String barcode = result.rawContent;
      if (barcode.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Barcode tidak terdeteksi.';
        });
        return;
      }
      HalalProduct? product = await FirebaseService.getHalalProduct(barcode);
      setState(() {
        _barcode = barcode;
        _product = product;
        _loading = false;
        if (product == null) {
          _error = 'Produk tidak ditemukan.';
        }
      });
      // TODO: Integrasi TTS di sini
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Gagal scan barcode.';
      });
    }
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'halal':
        return Colors.green;
      case 'haram':
        return Colors.red;
      case 'syubhat':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _scanBarcode,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.green,
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Mulai Scan Barcode', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 32),
            if (_barcode != null) Text('Barcode: $_barcode'),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_product != null)
              Card(
                color: _statusColor(_product!.status).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_product!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Status: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(_product!.status, style: TextStyle(color: _statusColor(_product!.status), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('No. Sertifikat: ${_product!.certificateNumber}'),
                      Text('Expired: ${_product!.expiredDate.toString()}'),
                      const SizedBox(height: 8),
                      Text('Komposisi:', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ..._product!.manualComposition.map((e) => Text('- $e')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
