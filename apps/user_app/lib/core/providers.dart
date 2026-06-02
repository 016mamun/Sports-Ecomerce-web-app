import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models.dart';

// Auth Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user;
});

// Cart Provider
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final updated = List<CartItem>.from(state);
      updated[index] = CartItem(
        id: updated[index].id,
        product: product,
        quantity: updated[index].quantity + 1,
      );
      state = updated;
    } else {
      state = [...state, CartItem(id: DateTime.now().toString(), product: product, quantity: 1)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = state.map((item) {
      if (item.product.id == productId) {
        return CartItem(id: item.id, product: item.product, quantity: quantity);
      }
      return item;
    }).toList();
  }

  void clear() => state = [];

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

// Products Provider
final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final response = await Supabase.instance.client
      .from('products')
      .select('*, category:categories(name)')
      .eq('is_active', true)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Product.fromJson(json)).toList();
});

// Categories Provider
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final response = await Supabase.instance.client
      .from('categories')
      .select('*')
      .order('name');

  return (response as List).map((json) => Category.fromJson(json)).toList();
});

// Product by slug
final productBySlugProvider = FutureProvider.autoDispose.family<Product, String>((ref, slug) async {
  final response = await Supabase.instance.client
      .from('products')
      .select('*, category:categories(name)')
      .eq('slug', slug)
      .single();

  return Product.fromJson(response);
});

// Products by category
final productsByCategoryProvider = FutureProvider.autoDispose.family<List<Product>, String>((ref, categorySlug) async {
  // First get category id
  final catResponse = await Supabase.instance.client
      .from('categories')
      .select('id')
      .eq('slug', categorySlug)
      .single();

  final response = await Supabase.instance.client
      .from('products')
      .select('*, category:categories(name)')
      .eq('is_active', true)
      .eq('category_id', catResponse['id'])
      .order('created_at', ascending: false);

  return (response as List).map((json) => Product.fromJson(json)).toList();
});

// Orders Provider
final ordersProvider = FutureProvider.autoDispose<List<Order>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final response = await Supabase.instance.client
      .from('orders')
      .select('*, order_items(*, product:products(name, slug))')
      .eq('user_id', user.id)
      .order('created_at', ascending: false);

  return (response as List).map((json) => Order.fromJson(json)).toList();
});

// Profile Provider
final profileProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;

  final response = await Supabase.instance.client
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single();

  return response;
});
