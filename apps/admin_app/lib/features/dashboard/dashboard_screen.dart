import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalOrders = 0;
  int _totalProducts = 0;
  int _totalUsers = 0;
  double _totalRevenue = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final supabase = Supabase.instance.client;

      final orders = await supabase.from('orders').select('total_amount, status').neq('status', 'cancelled');
      final products = await supabase.from('products').select('id');
      final users = await supabase.from('profiles').select('id').eq('role', 'user');

      setState(() {
        _totalOrders = orders.length;
        _totalProducts = products.length;
        _totalUsers = users.length;
        _totalRevenue = orders.fold(0.0, (sum, o) => sum + (o['total_amount'] as num).toDouble());
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: AppTheme.headingStyle.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text('Welcome back to FNF Sports Admin', style: AppTheme.bodyStyle),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(title: 'Revenue', value: AppConstants.formatPrice(_totalRevenue), icon: Icons.attach_money, color: Colors.green),
              _StatCard(title: 'Orders', value: '$_totalOrders', icon: Icons.shopping_cart, color: Colors.blue),
              _StatCard(title: 'Products', value: '$_totalProducts', icon: Icons.inventory_2, color: Colors.purple),
              _StatCard(title: 'Users', value: '$_totalUsers', icon: Icons.people, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
