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
          const Divider(height: 32),
          // READ & EDIT INGREDIENTS (dengan search & delete)
          Text('Data Ingredients', style: Theme.of(context).textTheme.titleMedium),
          _IngredientSearchAndList(),
          const Divider(height: 32),
          // READ & EDIT PRODUCTS (dengan search & delete)
          Text('Data Produk', style: Theme.of(context).textTheme.titleMedium),
          _ProductSearchAndList(),
        ],
      ),
    );
  }
}

// Dialog untuk edit ingredient
class _EditIngredientDialog extends StatefulWidget {
  final Ingredient ingredient;
  const _EditIngredientDialog({required this.ingredient});

  @override
  State<_EditIngredientDialog> createState() => _EditIngredientDialogState();
}

class _EditIngredientDialogState extends State<_EditIngredientDialog> {
  late String name;
  late String status;
  late String description;
  late String justification;
  late String alternativeNames;

  @override
  void initState() {
    super.initState();
    name = widget.ingredient.name;
    status = widget.ingredient.status;
    description = widget.ingredient.description;
    justification = widget.ingredient.justification;
    alternativeNames = widget.ingredient.alternativeNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Ingredient'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Nama'),
              onChanged: (v) => name = v,
            ),
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'halal', child: Text('Halal')),
                DropdownMenuItem(value: 'haram', child: Text('Haram')),
                DropdownMenuItem(value: 'meragukan', child: Text('Meragukan')),
              ],
              onChanged: (v) => setState(() => status = v ?? 'halal'),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              onChanged: (v) => description = v,
            ),
            TextFormField(
              initialValue: justification,
              decoration: const InputDecoration(labelText: 'Justifikasi'),
              onChanged: (v) => justification = v,
            ),
            TextFormField(
              initialValue: alternativeNames,
              decoration: const InputDecoration(labelText: 'Alternative Names (pisahkan koma)'),
              onChanged: (v) => alternativeNames = v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            final updatedIngredient = Ingredient(
              name: name.trim(),
              status: status,
              description: description,
              justification: justification,
              alternativeNames: alternativeNames.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
            );
            final oldName = widget.ingredient.name.trim();
            final newName = name.trim();
            if (oldName != newName) {
              // Buat dokumen baru, hapus yang lama
              await FirebaseService.addIngredient(updatedIngredient);
              await FirebaseService.deleteIngredient(oldName);
            } else {
              await FirebaseService.updateIngredient(oldName, updatedIngredient);
            }
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Dialog untuk edit produk
class _EditProductDialog extends StatefulWidget {
  final Product product;
  const _EditProductDialog({required this.product});

  @override
  State<_EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<_EditProductDialog> {
  late String barcode;
  late String name;
  late String certificateNumber;
  late String expiredDate;
  late String compositions;

  @override
  void initState() {
    super.initState();
    barcode = widget.product.barcode;
    name = widget.product.name;
    certificateNumber = widget.product.certificateNumber;
    expiredDate = widget.product.expiredDate.toIso8601String().split('T').first;
    compositions = widget.product.compositions.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Produk'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: barcode,
              decoration: const InputDecoration(labelText: 'Barcode'),
              onChanged: (v) => barcode = v,
            ),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              onChanged: (v) => name = v,
            ),
            TextFormField(
              initialValue: certificateNumber,
              decoration: const InputDecoration(labelText: 'Nomor Sertifikat'),
              onChanged: (v) => certificateNumber = v,
            ),
            TextFormField(
              initialValue: expiredDate,
              decoration: const InputDecoration(labelText: 'Expired Date (yyyy-MM-dd)'),
              onChanged: (v) => expiredDate = v,
            ),
            TextFormField(
              initialValue: compositions,
              decoration: const InputDecoration(labelText: 'Komposisi (pisahkan koma)'),
              onChanged: (v) => compositions = v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            final updatedProduct = Product(
              barcode: barcode.trim(),
              name: name.trim(),
              certificateNumber: certificateNumber.trim(),
              expiredDate: DateTime.tryParse(expiredDate.trim()) ?? DateTime.now(),
              compositions: compositions.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
            );
            await FirebaseService.updateProduct(widget.product.barcode, updatedProduct);
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Widget pencarian dan list ingredient
class _IngredientSearchAndList extends StatefulWidget {
  @override
  State<_IngredientSearchAndList> createState() => _IngredientSearchAndListState();
}

class _IngredientSearchAndListState extends State<_IngredientSearchAndList> {
  String _search = '';
  bool _showAll = false;
  static const int _maxShow = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Cari Ingredient',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
        ),
        FutureBuilder<List<Ingredient>>(
          future: FirebaseService.getAllIngredients(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final all = snapshot.data!;
            final filtered = _search.isEmpty
                ? all
                : all.where((i) => i.name.toLowerCase().contains(_search) || i.alternativeNames.any((alt) => alt.toLowerCase().contains(_search))).toList();
            if (filtered.isEmpty) return const Text('Tidak ditemukan.');
            final showList = _showAll || filtered.length <= _maxShow ? filtered : filtered.take(_maxShow).toList();
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: showList.length,
                  itemBuilder: (context, idx) {
                    final ing = showList[idx];
                    return ListTile(
                      title: Text(ing.name),
                      subtitle: Text('Status: ${ing.status}\n${ing.description}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => _EditIngredientDialog(ingredient: ing),
                              );
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Ingredient?'),
                                  content: Text('Yakin ingin menghapus ${ing.name}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await FirebaseService.deleteIngredient(ing.name);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (filtered.length > _maxShow)
                  TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    child: Text(_showAll ? 'Show Less' : 'Show All'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Widget pencarian dan list produk
class _ProductSearchAndList extends StatefulWidget {
  @override
  State<_ProductSearchAndList> createState() => _ProductSearchAndListState();
}

class _ProductSearchAndListState extends State<_ProductSearchAndList> {
  String _search = '';
  bool _showAll = false;
  static const int _maxShow = 5;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Cari Produk',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
        ),
        FutureBuilder<List<Product>>(
          future: FirebaseService.getAllProducts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final all = snapshot.data!;
            final filtered = _search.isEmpty
                ? all
                : all.where((p) => p.name.toLowerCase().contains(_search) || p.barcode.toLowerCase().contains(_search)).toList();
            if (filtered.isEmpty) return const Text('Tidak ditemukan.');
            final showList = _showAll || filtered.length <= _maxShow ? filtered : filtered.take(_maxShow).toList();
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: showList.length,
                  itemBuilder: (context, idx) {
                    final prod = showList[idx];
                    return ListTile(
                      title: Text(prod.name),
                      subtitle: Text('Barcode: ${prod.barcode}\nSertifikat: ${prod.certificateNumber}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => _EditProductDialog(product: prod),
                              );
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Produk?'),
                                  content: Text('Yakin ingin menghapus ${prod.name}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                    ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await FirebaseService.deleteProduct(prod.barcode);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (filtered.length > _maxShow)
                  TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    child: Text(_showAll ? 'Show Less' : 'Show All'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
