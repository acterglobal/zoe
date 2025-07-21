enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  sheet('/sheet/:sheetId'),
  taskDetail('/task/:taskId'),
  eventDetail('/event/:eventId'),
  listItemDetail('/list-item/:listItemId'),
  settings('/settings');

  final String route;
  const AppRoutes(this.route);
}
