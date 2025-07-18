enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  sheet('/sheet/:sheetId'),
  settings('/settings');

  final String route;
  const AppRoutes(this.route);
}
