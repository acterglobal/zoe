enum AppRoutes {
  welcome('/welcome'),
  home('/'),
  sheetsList('/sheets-list'),
  sheet('/sheet/:sheetId'),
  tasksList('/tasks-list'),
  taskDetail('/task/:taskId'),
  eventsList('/events-list'),
  eventDetail('/event/:eventId'),
  bulletDetail('/bullet/:bulletId'),
  linksList('/links-list'),
  documentsList('/documents-list'),
  pollsList('/polls-list'),
  pollDetails('/poll/:pollId'),
  settings('/settings'),
  settingLanguage('/settings/language');

  final String route;
  const AppRoutes(this.route);
}
