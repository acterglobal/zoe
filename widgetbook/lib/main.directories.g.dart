// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_workspace/common/widgets/glassy_container_widget.dart'
    as _widgetbook_workspace_common_widgets_glassy_container_widget;
import 'package:widgetbook_workspace/common/widgets/toolkit/zoe_toolkit_widgets.dart'
    as _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets;
import 'package:widgetbook_workspace/features/bullets/use_cases/bullet_use_cases.dart'
    as _widgetbook_workspace_features_bullets_use_cases_bullet_use_cases;
import 'package:widgetbook_workspace/features/documents/use_cases/document_use_cases.dart'
    as _widgetbook_workspace_features_documents_use_cases_document_use_cases;
import 'package:widgetbook_workspace/features/events/use_cases/event_use_cases.dart'
    as _widgetbook_workspace_features_events_use_cases_event_use_cases;
import 'package:widgetbook_workspace/features/home/home_screen.dart'
    as _widgetbook_workspace_features_home_home_screen;
import 'package:widgetbook_workspace/features/home/use_cases/use_cases.dart'
    as _widgetbook_workspace_features_home_use_cases_use_cases;
import 'package:widgetbook_workspace/features/link/use_cases/link_use_cases.dart'
    as _widgetbook_workspace_features_link_use_cases_link_use_cases;
import 'package:widgetbook_workspace/features/list/use_cases/list_use_cases.dart'
    as _widgetbook_workspace_features_list_use_cases_list_use_cases;
import 'package:widgetbook_workspace/features/polls/use_cases/poll_use_cases.dart'
    as _widgetbook_workspace_features_polls_use_cases_poll_use_cases;
import 'package:widgetbook_workspace/features/settings/use_cases/language_use_cases.dart'
    as _widgetbook_workspace_features_settings_use_cases_language_use_cases;
import 'package:widgetbook_workspace/features/settings/use_cases/settings_use_cases.dart'
    as _widgetbook_workspace_features_settings_use_cases_settings_use_cases;
import 'package:widgetbook_workspace/features/sheets/sheet_widgets.dart'
    as _widgetbook_workspace_features_sheets_sheet_widgets;
import 'package:widgetbook_workspace/features/sheets/use_cases/sheet_use_cases.dart'
    as _widgetbook_workspace_features_sheets_use_cases_sheet_use_cases;
import 'package:widgetbook_workspace/features/tasks/use_cases/task_use_cases.dart'
    as _widgetbook_workspace_features_tasks_use_cases_task_use_cases;
import 'package:widgetbook_workspace/features/text/use_cases/text_use_cases.dart'
    as _widgetbook_workspace_features_text_use_cases_text_use_cases;
import 'package:widgetbook_workspace/features/whatsapp/use_cases/whatsapp_use_cases.dart'
    as _widgetbook_workspace_features_whatsapp_use_cases_whatsapp_use_cases;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'common',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'widgets',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'GlassyContainer',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _widgetbook_workspace_common_widgets_glassy_container_widget
                        .buildGlassyContainerUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With Custom Blur',
                builder:
                    _widgetbook_workspace_common_widgets_glassy_container_widget
                        .buildGlassyContainerWithBlurUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'StyledContentContainer',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_features_sheets_sheet_widgets
                    .buildStyledContentContainerUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Large Container',
                builder: _widgetbook_workspace_features_sheets_sheet_widgets
                    .buildLargeStyledContentContainerUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Small Container',
                builder: _widgetbook_workspace_features_sheets_sheet_widgets
                    .buildSmallStyledContentContainerUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'toolkit',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'ZoeAppBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeAppBarUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Actions',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeAppBarWithActionsUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeFloatingActionButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeFloatingActionButtonUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Custom Icon',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeFloatingActionButtonWithCustomIconUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeGlassyTabWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeGlassyTabWidgetUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With More Tabs',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeGlassyTabWidgetWithMoreTabsUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeIconButtonWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeIconButtonWidgetUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Large',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeIconButtonWidgetLargeUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeIconContainer',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_glassy_container_widget
                            .buildZoeIconContainerUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Color',
                    builder:
                        _widgetbook_workspace_common_widgets_glassy_container_widget
                            .buildZoeIconContainerWithColorUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoePrimaryButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoePrimaryButtonUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Disabled',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoePrimaryButtonDisabledUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoePrimaryButtonLoadingUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeSearchBarWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeSearchBarWidgetUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Callback',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeSearchBarWidgetWithCallbackUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'ZoeSecondaryButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeSecondaryButtonUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Disabled',
                    builder:
                        _widgetbook_workspace_common_widgets_toolkit_zoe_toolkit_widgets
                            .buildZoeSecondaryButtonDisabledUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'features',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'bullets',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'BulletDetailScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Bullet Detail Screen',
                  builder:
                      _widgetbook_workspace_features_bullets_use_cases_bullet_use_cases
                          .buildBulletDetailScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'BulletListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Bullet List Screen',
                  builder:
                      _widgetbook_workspace_features_bullets_use_cases_bullet_use_cases
                          .buildBulletListScreenUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'documents',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'DocumentPreviewScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Document Detail Screen',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildDocumentPreviewScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'DocumentsListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Documents List Screen',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildDocumentsListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'DocumentActionButtons',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Document Action Button Widget',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildDocumentActionButtonWidgetUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'DocumentListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Document List Screen',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildDocumentListScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'DocumentWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Document Widget',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildDocumentWidgetUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'UnsupportedPreviewWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Unsupported Preview Widget',
                  builder:
                      _widgetbook_workspace_features_documents_use_cases_document_use_cases
                          .buildUnsupportedPreviewWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'events',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'EventDetailScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Event Detail Screen',
                  builder:
                      _widgetbook_workspace_features_events_use_cases_event_use_cases
                          .buildEventDetailScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'EventsListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Event List Screen',
                  builder:
                      _widgetbook_workspace_features_events_use_cases_event_use_cases
                          .buildEventsListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'EventListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Event List Widget',
                  builder:
                      _widgetbook_workspace_features_events_use_cases_event_use_cases
                          .buildEventListWidgetUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'EventWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Event Widget',
                  builder:
                      _widgetbook_workspace_features_events_use_cases_event_use_cases
                          .buildEventWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'home',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'HomeScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Zoe Home Screen',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildZoeHomeScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'stats_section',
                children: [
                  _widgetbook.WidgetbookLeafComponent(
                    name: 'StatsSectionWidget',
                    useCase: _widgetbook.WidgetbookUseCase(
                      name: 'Stats Section',
                      builder:
                          _widgetbook_workspace_features_home_use_cases_use_cases
                              .buildStatsSectionUseCase,
                    ),
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'today_focus',
                children: [
                  _widgetbook.WidgetbookLeafComponent(
                    name: 'TodaysFocusWidget',
                    useCase: _widgetbook.WidgetbookUseCase(
                      name: 'Today\'s Focus',
                      builder:
                          _widgetbook_workspace_features_home_use_cases_use_cases
                              .buildTodaysFocusUseCase,
                    ),
                  ),
                ],
              ),
              _widgetbook.WidgetbookFolder(
                name: 'welcome_section',
                children: [
                  _widgetbook.WidgetbookLeafComponent(
                    name: 'WelcomeSectionWidget',
                    useCase: _widgetbook.WidgetbookUseCase(
                      name: 'Welcome Section',
                      builder:
                          _widgetbook_workspace_features_home_use_cases_use_cases
                              .buildWelcomeSectionUseCase,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'link',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'LinksListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Links List Screen',
                  builder:
                      _widgetbook_workspace_features_link_use_cases_link_use_cases
                          .buildLinksListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'LinkListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Link List Screen',
                  builder:
                      _widgetbook_workspace_features_link_use_cases_link_use_cases
                          .buildLinkListScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'LinkWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Link Widget',
                  builder:
                      _widgetbook_workspace_features_link_use_cases_link_use_cases
                          .buildLinkWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'list',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'ListDetailsScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'List Details Screen',
                  builder:
                      _widgetbook_workspace_features_list_use_cases_list_use_cases
                          .buildListDetailsScreenUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'polls',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'PollDetailsScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Poll Detail Screen',
                  builder:
                      _widgetbook_workspace_features_polls_use_cases_poll_use_cases
                          .buildPollDetailScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'PollsListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Polls List Screen',
                  builder:
                      _widgetbook_workspace_features_polls_use_cases_poll_use_cases
                          .buildPollsListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'PollListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Poll List Screen',
                  builder:
                      _widgetbook_workspace_features_polls_use_cases_poll_use_cases
                          .buildPollListScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'PollWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Poll Widget',
                  builder:
                      _widgetbook_workspace_features_polls_use_cases_poll_use_cases
                          .buildPollWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'quick-search',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'QuickSearchScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Quick Search Screen',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildQuickSearchScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'QuickSearchTabSectionHeaderWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Quick Search Tab Section Header Widget',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildQuickSearchTabSectionHeaderWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'settings',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'LanguageSelectionScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Language Selection Screen',
                  builder:
                      _widgetbook_workspace_features_settings_use_cases_language_use_cases
                          .buildLanguageSelectionScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookComponent(
                name: 'SettingsScreen',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Settings Screen',
                    builder:
                        _widgetbook_workspace_features_settings_use_cases_settings_use_cases
                            .buildSettingsScreenUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Theme Dialog',
                    builder:
                        _widgetbook_workspace_features_settings_use_cases_settings_use_cases
                            .buildThemeDialogUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'sheet',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'SheetDetailScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Sheet Detail Screen',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildSheetDetailScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'SheetListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Sheet List Screen',
                  builder:
                      _widgetbook_workspace_features_sheets_use_cases_sheet_use_cases
                          .buildSheetListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'SheetListItemWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Compact Sheet Item',
                    builder: _widgetbook_workspace_features_sheets_sheet_widgets
                        .buildCompactSheetListItemUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sheet List Item',
                    builder: _widgetbook_workspace_features_sheets_sheet_widgets
                        .buildSheetListItemUseCase,
                  ),
                ],
              ),
              _widgetbook.WidgetbookComponent(
                name: 'SheetListWidget',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sheet List',
                    builder:
                        _widgetbook_workspace_features_home_use_cases_use_cases
                            .buildSheetListUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sheet List Widget',
                    builder:
                        _widgetbook_workspace_features_sheets_use_cases_sheet_use_cases
                            .buildSheetListWidgetUseCase,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'task',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'TaskDetailScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Task Detail Screen',
                  builder:
                      _widgetbook_workspace_features_tasks_use_cases_task_use_cases
                          .buildTaskDetailScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'TasksListScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Tasks List Screen',
                  builder:
                      _widgetbook_workspace_features_tasks_use_cases_task_use_cases
                          .buildTasksListScreenUseCase,
                ),
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'TaskListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Task List Screen',
                  builder:
                      _widgetbook_workspace_features_tasks_use_cases_task_use_cases
                          .buildTaskListScreenUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'TaskWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Task Widget',
                  builder:
                      _widgetbook_workspace_features_tasks_use_cases_task_use_cases
                          .buildTaskWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'text',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'TextBlockDetailsScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'Text Block Details Screen',
                  builder:
                      _widgetbook_workspace_features_text_use_cases_text_use_cases
                          .buildTextBlockDetailsScreenUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'users',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'widgets',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'UserListWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'User List Widget',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildUserListWidgetUseCase,
                ),
              ),
              _widgetbook.WidgetbookLeafComponent(
                name: 'UserWidget',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'User Widget',
                  builder: _widgetbook_workspace_features_home_home_screen
                      .buildUserWidgetUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'whatsapp',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'screens',
            children: [
              _widgetbook.WidgetbookLeafComponent(
                name: 'WhatsAppGroupConnectScreen',
                useCase: _widgetbook.WidgetbookUseCase(
                  name: 'WhatsApp Group Connect Screen',
                  builder:
                      _widgetbook_workspace_features_whatsapp_use_cases_whatsapp_use_cases
                          .buildWhatsAppGroupConnectScreenUseCase,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookLeafComponent(
        name: 'Widget',
        useCase: _widgetbook.WidgetbookUseCase(
          name: 'Text Block List',
          builder: _widgetbook_workspace_features_text_use_cases_text_use_cases
              .buildTextBlockListUseCase,
        ),
      ),
    ],
  ),
];
