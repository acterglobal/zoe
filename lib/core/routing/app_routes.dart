enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  sheet('/sheet/:sheetId'),
  taskDetail('/task/:taskId'),
  eventDetail('/event/:eventId'),
  bulletDetail('/bullet/:bulletId'),
  settings('/settings'),
  languageSelection('/language-selection');

  final String route;
  const AppRoutes(this.route);
}
