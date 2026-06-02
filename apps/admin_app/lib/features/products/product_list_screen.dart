import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final data = await Supabase.instance.client
        .from('products')
        .select('*, category:categories(name)')
        .order('created_at', ascending: false);
    setState(() {
      _products = List<Map<String, dynamic>>.from(data);
      _loading = false;
    });
  }

  Future<void> _deleteProduct(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    await Supabase.instance.client.from('products').delete().eq('id', id);
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No products yet'))
              : RefreshIndicator(
                  onRefresh: _fetchProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final p = _products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                          ),
                          title: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${p['category']?['name'] ?? 'No category'} | Stock: ${p['stock']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppConstants.formatPrice((p['price'] as num).toDouble()), style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => context.go('/products/${p['id']}/edit')),
                              IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red), onPressed: () => _deleteProduct(p['id'])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/products/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
