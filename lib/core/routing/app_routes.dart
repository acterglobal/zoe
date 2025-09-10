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
  listDetail('/list/:listId'),
  linksList('/links-list'),
  documentsList('/documents-list'),
  documentPreview('/document/:documentId'),
  pollsList('/polls-list'),
  pollDetails('/poll/:pollId'),
  pollResults('/poll-results/:pollId'),
  textBlockDetails('/text-block/:textBlockId'),
  quickSearch('/quick-search'),
  settings('/settings'),
  settingLanguage('/settings/language'),
  developerTools('/developer-tools'),
  systemsTest('/developer-tools/systems-test'),
  whatsappGroupConnect('/whatsapp-group-connect/:sheetId');

  final String route;
  const AppRoutes(this.route);
}
