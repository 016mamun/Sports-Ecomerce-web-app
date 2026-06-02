import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers.dart';
import '../../../core/constants.dart';
import '../../../core/theme.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String slug;
  const ProductDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productBySlugProvider(slug));

    return productAsync.when(
      data: (product) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: product.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.images[0],
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey[200]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.categoryName != null)
                      Text(
                        product.categoryName!.toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: AppTheme.headingStyle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          AppConstants.formatPrice(product.price),
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        if (product.comparePrice != null &&
                            product.comparePrice! > product.price) ...[
                          const SizedBox(width: 12),
                          Text(
                            AppConstants.formatPrice(product.comparePrice!),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${product.discountPercentage}%',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          product.stock > 0 ? Icons.check_circle : Icons.cancel,
                          color: product.stock > 0 ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.stock > 0
                              ? 'In Stock (${product.stock} available)'
                              : 'Out of Stock',
                          style: TextStyle(
                            color: product.stock > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (product.description != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: AppTheme.headingStyle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description!,
                        style: TextStyle(color: Colors.grey[600], height: 1.6),
                      ),
                    ],
                    const SizedBox(height: 24),
                    if (product.stock > 0)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}
