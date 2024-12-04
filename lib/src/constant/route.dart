enum RoutePath {
  splash('/splash', '/splash'),
  login('/login', '/login'),
  register('/register', '/register'),

  home('/', '/'),
  alert('/alert', '/alert'),
  alertDetail('detail', '/alert/detail'),

  assignment('/assignment', '/assignment'),

  messenger('/messenger', '/messenger'),
  chat('chat/:id', '/messenger/chat/');

  const RoutePath(this.relative, this.absolute);
  final String relative, absolute;
}
