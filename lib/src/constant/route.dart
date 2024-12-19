enum RoutePath {
  login('/login','/login'),
  home('/', '/'),
  chart('/chart','/chart'),
  config('/config','/config'),
  alert('/alert','/alert');

  const RoutePath(this.relative, this.absolute);
  final String relative, absolute;
}
