class ApiRoutes{
  static const String _baseDomain = 'http://battle-in.ru/';

  static const String shopApiRoute = '${_baseDomain}api0.1/shops';
  static const String shopByIndexApiRoute = '$shopApiRoute?index=';

  static const String productApiRoute = '${_baseDomain}api0.1/products';
  static const String productByIndexApiRoute = '$productApiRoute?index=';

  static const String characteristicsApiRoute = '${_baseDomain}api0.1/characteristics';
  static const String characteristicsByIndexApiRoute = '$characteristicsApiRoute?index=';
}