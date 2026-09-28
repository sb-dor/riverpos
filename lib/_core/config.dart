abstract class Config {
  static const String apiAdminBaseUrl = String.fromEnvironment(
    'API_ADMIN_URL',
    defaultValue: 'https://api.domain.tld',
  );
}
