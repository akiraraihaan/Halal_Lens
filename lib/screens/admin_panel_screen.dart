import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../models/product.dart';
import '../services/firebase_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool isLoggedIn = false;
  final _adminUser = 'admin';
  final _adminPass = 'admin123';
  final _loginFormKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  // Ingredient fields
  final _ingredientFormKey = GlobalKey<FormState>();
  String _ingredientName = '';
  String _ingredientStatus = 'halal';
  String _ingredientDescription = '';
  String _ingredientJustification = '';
  String _ingredientAlternativeNames = '';

  // Product fields
  final _productFormKey = GlobalKey<FormState>();
  String _productBarcode = '';
  String _productName = '';
  String _productCertificate = '';
  String _productExpired = '';
  String _productCompositions = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: isLoggedIn ? _buildAdminPanel() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Login Admin', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (v) => _username = v,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (v) => _password = v,
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    if (_username == _adminUser && _password == _adminPass) {
                      setState(() => isLoggedIn = true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login gagal')));
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tambah Ingredient', style: Theme.of(context).textTheme.titleMedium),
          Form(
            key: _ingredientFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama'),
                  onChanged: (v) => _ingredientName = v,
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _ingredientStatus,
                  items: const [
                    DropdownMenuItem(value: 'halal', child: Text('Halal')),
                    DropdownMenuItem(value: 'haram', child: Text('Haram')),
                    DropdownMenuItem(value: 'meragukan', child: Text('Meragukan')),
                  ],
                  onChanged: (v) => setState(() => _ingredientStatus = v ?? 'halal'),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  onChanged: (v) => _ingredientDescription = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Justifikasi'),
                  onChanged: (v) => _ingredientJustification = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Alternative Names (pisahkan koma)'),
                  onChanged: (v) => _ingredientAlternativeNames = v,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_ingredientFormKey.currentState!.validate()) {
                      final ingredient = Ingredient(
                        name: _ingredientName.trim(),
                        status: _ingredientStatus,
                        description: _ingredientDescription,
                        justification: _ingredientJustification,
                        alternativeNames: _ingredientAlternativeNames.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                      );
                      await FirebaseService.addIngredient(ingredient);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingredient berhasil disimpan!')));
                      _ingredientFormKey.currentState!.reset();
                    }
                  },
                  child: const Text('Simpan Ingredient'),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          Text('Tambah Produk', style: Theme.of(context).textTheme.titleMedium),
          Form(
            key: _productFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Barcode'),
                  onChanged: (v) => _productBarcode = v,
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                  onChanged: (v) => _productName = v,
                  validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nomor Sertifikat'),
                  onChanged: (v) => _productCertificate = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Expired Date (yyyy-MM-dd)'),
                  onChanged: (v) => _productExpired = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Komposisi (pisahkan koma)'),
                  onChanged: (v) => _productCompositions = v,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_productFormKey.currentState!.validate()) {
                      final product = Product(
                        barcode: _productBarcode.trim(),
                        name: _productName.trim(),
                        certificateNumber: _productCertificate.trim(),
                        expiredDate: DateTime.tryParse(_productExpired.trim()) ?? DateTime.now(),
                        compositions: _productCompositions.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                      );
                      await FirebaseService.addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil disimpan!')));
                      _productFormKey.currentState!.reset();
                    }
                  },
                  child: const Text('Simpan Produk'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
