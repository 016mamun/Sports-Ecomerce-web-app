class AppConstants {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );

  // Site Info
  static const String appName = 'FNF Sports';
  static const String appTagline = 'Your Ultimate Sports Destination';
  static const String currency = '৳';

  // Format price
  static String formatPrice(num price) {
    return '$currency${price.toStringAsFixed(2)}';
  }
}
