import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/products/product_list_screen.dart';
import '../features/products/product_form_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/categories/category_list_screen.dart';
import '../features/users/user_list_screen.dart';
import '../features/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: '/products/new',
          builder: (context, state) => const ProductFormScreen(),
        ),
        GoRoute(
          path: '/products/:id/edit',
          builder: (context, state) =>
              ProductFormScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrderListScreen(),
        ),
        GoRoute(
          path: '/orders/:id',
          builder: (context, state) =>
              OrderDetailScreen(orderId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoryListScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const UserListScreen(),
        ),
      ],
    ),
  ],
);
