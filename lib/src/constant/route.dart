enum RoutePath {

  home('/', '/'),
  alert('/alert', '/alert'),
  alertDetail('detail', '/alert/detail'),
  chart('/chart','/chart');

  const RoutePath(this.relative, this.absolute);
  final String relative, absolute;
}
