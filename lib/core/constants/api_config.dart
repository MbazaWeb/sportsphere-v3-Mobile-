/// Environment-aware API config.
/// Base path mirrors NEXT_PUBLIC_BASE_PATH (/sportsphere on web).
class ApiConfig {
  ApiConfig._();

  /// Change this for staging/production.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://your-sportsphere-host.com',
  );

  /// Sub-path prefix used by the Next.js app.
  static const String basePath = String.fromEnvironment(
    'API_BASE_PATH',
    defaultValue: '/sportsphere',
  );

  static String url(String path) {
    final p = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$basePath$p';
  }
}
