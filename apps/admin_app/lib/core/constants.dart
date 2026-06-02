class AppConstants {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );

  static const String appName = 'FNF Sports Admin';
  static const String currency = '৳';

  static String formatPrice(num price) {
    return '$currency${price.toStringAsFixed(2)}';
  }
}
