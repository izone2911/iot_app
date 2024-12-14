enum RoutePath {

  home('/', '/'),
  chart('/chart','/chart'),
  config('/config','/config');

  const RoutePath(this.relative, this.absolute);
  final String relative, absolute;
}
