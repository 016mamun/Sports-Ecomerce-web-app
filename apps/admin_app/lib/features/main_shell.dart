import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'F',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FNF Sports',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Admin Panel',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            _drawerItem(context, Icons.dashboard, 'Dashboard', '/', location),
            _drawerItem(
              context,
              Icons.inventory_2_outlined,
              'Products',
              '/products',
              location,
            ),
            _drawerItem(
              context,
              Icons.shopping_cart_outlined,
              'Orders',
              '/orders',
              location,
            ),
            _drawerItem(
              context,
              Icons.category_outlined,
              'Categories',
              '/categories',
              location,
            ),
            _drawerItem(
              context,
              Icons.people_outline,
              'Users',
              '/users',
              location,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text(_getTitle(location))),
      body: child,
    );
  }

  String _getTitle(String location) {
    if (location == '/') return 'Dashboard';
    if (location.startsWith('/products')) return 'Products';
    if (location.startsWith('/orders')) return 'Orders';
    if (location.startsWith('/categories')) return 'Categories';
    if (location.startsWith('/users')) return 'Users';
    return 'Admin';
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String path,
    String currentPath,
  ) {
    final isActive =
        currentPath == path || (path != '/' && currentPath.startsWith(path));
    return ListTile(
      leading: Icon(icon, color: isActive ? AppTheme.accentColor : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppTheme.accentColor : null,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppTheme.accentColor.withOpacity(0.1),
      onTap: () {
        context.go(path);
        Navigator.pop(context);
      },
    );
  }
}
