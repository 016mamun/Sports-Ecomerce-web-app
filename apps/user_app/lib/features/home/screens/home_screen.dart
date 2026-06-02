import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Color(0xFF243B53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Text('F', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                        ),
                        const SizedBox(width: 12),
                        const Text('FNF Sports', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        children: [
                          const TextSpan(text: 'Gear Up for '),
                          TextSpan(text: 'Victory', style: TextStyle(color: AppTheme.accentColor)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Premium sports equipment for every athlete',
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/products'),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Shop Now'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories', style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                      TextButton(onPressed: () => context.go('/products'), child: const Text('View All')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: categoriesAsync.when(
                      data: (categories) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          return GestureDetector(
                            onTap: () => context.go('/products?category=${cat.slug}'),
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    width: 56, height: 56,
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(cat.name[0], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(cat.name, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('Error loading categories')),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // New Arrivals
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('New Arrivals', style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                  TextButton(onPressed: () => context.go('/products'), child: const Text('View All')),
                ],
              ),
            ),
          ),

          productsAsync.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= products.length) return null;
                    return _ProductCard(product: products[index]);
                  },
                  childCount: products.length > 8 ? 8 : products.length,
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))),
            error: (_, __) => const SliverToBoxAdapter(child: Center(child: Text('Error loading products'))),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go('/products/${product.slug}'),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: product.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.images[0],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: Colors.grey[200]),
                        errorWidget: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                      )
                    : Container(color: Colors.grey[200], child: const Icon(Icons.sports_basketball, color: Colors.grey, size: 40)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(AppConstants.formatPrice(product.price), style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 15)),
                      if (product.comparePrice != null && product.comparePrice! > product.price) ...[
                        const SizedBox(width: 6),
                        Text(AppConstants.formatPrice(product.comparePrice!), style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[400], fontSize: 12)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (product.stock > 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(seconds: 1)),
                          );
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), textStyle: const TextStyle(fontSize: 12)),
                        child: const Text('Add to Cart'),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: const Text('Out of Stock', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
