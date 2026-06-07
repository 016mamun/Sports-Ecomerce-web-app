import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    final data = await Supabase.instance.client
        .from('orders')
        .select(
          '*, order_items(*, product:products(name)), profile:profiles(full_name, phone)',
        )
        .eq('id', widget.orderId)
        .single();
    setState(() {
      _order = data;
      _loading = false;
    });
  }

  Future<void> _updateStatus(String status) async {
    await Supabase.instance.client
        .from('orders')
        .update({'status': status})
        .eq('id', widget.orderId);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Status updated!')));
    _fetchOrder();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_order == null) {
      return const Scaffold(body: Center(child: Text('Order not found')));
    }

    final items = List<Map<String, dynamic>>.from(_order!['order_items'] ?? []);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Update
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status: ${_order!['status']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _statusColor(_order!['status']),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: _updateStatus,
                          itemBuilder: (ctx) =>
                              [
                                    'pending',
                                    'confirmed',
                                    'shipped',
                                    'delivered',
                                    'cancelled',
                                  ]
                                  .map(
                                    (s) => PopupMenuItem(
                                      value: s,
                                      child: Text(
                                        s[0].toUpperCase() + s.substring(1),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          child: const Chip(label: Text('Update Status')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order #${widget.orderId.substring(0, 8).toUpperCase()}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Customer Info
            Text(
              'Customer',
              style: AppTheme.headingStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(_order!['profile']?['full_name'] ?? 'N/A'),
                subtitle: Text(
                  _order!['profile']?['phone'] ?? _order!['phone'],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Shipping
            Text(
              'Shipping Address',
              style: AppTheme.headingStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(_order!['shipping_address']),
              ),
            ),
            const SizedBox(height: 16),

            // Items
            Text(
              'Order Items',
              style: AppTheme.headingStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item['product']?['name'] ?? 'Product'),
                  subtitle: Text(
                    'Qty: ${item['quantity']} x ${AppConstants.formatPrice((item['unit_price'] as num).toDouble())}',
                  ),
                  trailing: Text(
                    AppConstants.formatPrice(
                      (item['unit_price'] as num).toDouble() * item['quantity'],
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Total
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppConstants.formatPrice(
                        (_order!['total_amount'] as num).toDouble(),
                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentColor,
                      ),
                    ),
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
