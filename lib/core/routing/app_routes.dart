enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  sheet('/sheet/:sheetId'),
  taskDetail('/task/:taskId'),
  eventDetail('/event/:eventId'),
  listBlockDetail('/list-block/:listBlockId'),
  settings('/settings');

  final String route;
  const AppRoutes(this.route);
}
