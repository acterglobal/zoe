enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  page('/page/:pageId'),
  settings('/settings');

  final String route;
  const AppRoutes(this.route);
}
