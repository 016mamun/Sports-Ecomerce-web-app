import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;
  const ProductFormScreen({super.key, this.productId});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _comparePriceController = TextEditingController();
  final _stockController = TextEditingController();
  String? _categoryId;
  bool _isActive = true;
  bool _loading = false;
  List<Map<String, dynamic>> _categories = [];

  bool get isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (isEditing) _fetchProduct();
  }

  Future<void> _fetchCategories() async {
    final data = await Supabase.instance.client
        .from('categories')
        .select('*')
        .order('name');
    setState(() => _categories = List<Map<String, dynamic>>.from(data));
  }

  Future<void> _fetchProduct() async {
    final data = await Supabase.instance.client
        .from('products')
        .select('*')
        .eq('id', widget.productId!)
        .single();
    setState(() {
      _nameController.text = data['name'];
      _descriptionController.text = data['description'] ?? '';
      _priceController.text = data['price'].toString();
      _comparePriceController.text = data['compare_price']?.toString() ?? '';
      _stockController.text = data['stock'].toString();
      _categoryId = data['category_id'];
      _isActive = data['is_active'];
    });
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final slug = _nameController.text
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
      final productData = {
        'name': _nameController.text,
        'slug': slug,
        'description': _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        'price': double.parse(_priceController.text),
        'compare_price': _comparePriceController.text.isEmpty
            ? null
            : double.parse(_comparePriceController.text),
        'stock': int.parse(_stockController.text),
        'category_id': _categoryId,
        'is_active': _isActive,
      };

      if (isEditing) {
        await Supabase.instance.client
            .from('products')
            .update(productData)
            .eq('id', widget.productId!);
      } else {
        await Supabase.instance.client.from('products').insert(productData);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Product updated!' : 'Product created!'),
          ),
        );
        context.go('/products');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit Product' : 'Add Product',
              style: AppTheme.headingStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (৳) *'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _comparePriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Compare Price',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock *'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _categoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('No Category'),
                      ),
                      ..._categories.map(
                        (c) => DropdownMenuItem(
                          value: c['id'],
                          child: Text(c['name']),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditing ? 'Update Product' : 'Create Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
