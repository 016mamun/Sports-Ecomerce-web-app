class Product {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? comparePrice;
  final List<String> images;
  final String? categoryId;
  final int stock;
  final bool isActive;
  final String? categoryName;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.comparePrice,
    required this.images,
    this.categoryId,
    required this.stock,
    required this.isActive,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      comparePrice: json['compare_price'] != null
          ? (json['compare_price'] as num).toDouble()
          : null,
      images: List<String>.from(json['images'] ?? []),
      categoryId: json['category_id'],
      stock: json['stock'] ?? 0,
      isActive: json['is_active'] ?? true,
      categoryName: json['category']?['name'],
    );
  }

  int get discountPercentage {
    if (comparePrice == null || comparePrice! <= price) return 0;
    return ((comparePrice! - price) / comparePrice! * 100).round();
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      imageUrl: json['image_url'],
    );
  }
}

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({required this.id, required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}

class Order {
  final String id;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String phone;
  final String? notes;
  final DateTime createdAt;
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.phone,
    this.notes,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      shippingAddress: json['shipping_address'],
      phone: json['phone'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
                .map((i) => OrderItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

class OrderItem {
  final String id;
  final String productId;
  final int quantity;
  final double unitPrice;
  final String? productName;
  final String? productSlug;

  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.productName,
    this.productSlug,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      productName: json['product']?['name'],
      productSlug: json['product']?['slug'],
    );
  }
}
