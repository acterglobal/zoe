import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/models/content_block.dart';
import '../common/providers/app_state_provider.dart';
import '../common/providers/navigation_provider.dart';
import '../common/theme/app_theme.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  final bool isEmbedded;

  const HomeScreen({super.key, this.isEmbedded = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);

    if (widget.isEmbedded) {
      // Embedded mode for responsive layout
      return Container(
        color: AppTheme.getBackground(context),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header without drawer button
                _buildEmbeddedHeader(context),

                // Greeting section
                _buildGreetingSection(context),

                const SizedBox(height: 24),

                // Quick stats cards
                _buildQuickStats(context, appStateProvider),

                // Today's priority section
                _buildTodaySection(context, appStateProvider),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }

    // Traditional mobile layout
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with app name and menu
              _buildHeader(context),

              // Greeting section
              _buildGreetingSection(context),

              const SizedBox(height: 24),

              // Quick stats cards
              _buildQuickStats(context, appStateProvider),

              // Today's priority section
              _buildTodaySection(context, appStateProvider),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: widget.isEmbedded
          ? null
          : FloatingActionButton(
              heroTag: "home_screen_fab",
              onPressed: () => _createNewPage(context),
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add_rounded),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.getBorder(context)),
                ),
                child: Icon(
                  Icons.menu_rounded,
                  color: AppTheme.getTextSecondary(context),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Zoey',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.getTextPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmbeddedHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const SizedBox.shrink(), // Just spacing without content
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getGreeting(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getFormattedDate(),
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    AppStateProvider appStateProvider,
  ) {
    // Overview: All tasks and events from all pages (not date-specific)
    final completedTasks = _getCompletedTasks(appStateProvider);
    final totalTasks = _getTotalTasks(appStateProvider);
    final totalEvents = _getTotalEvents(appStateProvider);
    final tasksProgress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildEnhancedStatCard(
              context,
              icon: Icons.task_alt_rounded,
              title: 'Tasks',
              value: totalTasks > 0 ? '$completedTasks/$totalTasks' : '0',
              subtitle: totalTasks > 0
                  ? '${(tasksProgress * 100).round()}% complete overall'
                  : 'No tasks yet',
              color: const Color(0xFF10B981),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              progress: tasksProgress,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildEnhancedStatCard(
              context,
              icon: Icons.event_available_rounded,
              title: 'Events',
              value: '$totalEvents',
              subtitle: totalEvents == 0 ? 'No events yet' : 'Across all pages',
              color: const Color(0xFF3B82F6),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              progress: totalEvents > 0 ? 1.0 : 0.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required LinearGradient gradient,
    required double progress,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Add subtle haptic feedback
            // HapticFeedback.lightImpact();
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 140),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Value with percentage badge for tasks (only when tasks exist)
                if (title == 'Tasks' &&
                    value.contains('/') &&
                    progress > 0) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main value
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: color,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Percentage badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${(progress * 100).round()}% complete',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Simple value for events or tasks with no progress
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: -1.0,
                      height: 1.0,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Progress bar for tasks or status indicator for events
                if (title == 'Tasks' && progress > 0) ...[
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySection(
    BuildContext context,
    AppStateProvider appStateProvider,
  ) {
    // Today's Focus: Only tasks and events specifically due/scheduled for today
    final todayTasks = appStateProvider.getTodaysTodos();
    final todayEvents = appStateProvider.getTodaysEvents();
    final totalItems = todayTasks.length + todayEvents.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header
          Row(
            children: [
              Text(
                'Today\'s Focus',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextPrimary(context),
                ),
              ),
              const Spacer(),
              if (totalItems > 0)
                Text(
                  '$totalItems ${totalItems == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          if (todayTasks.isEmpty && todayEvents.isEmpty)
            _buildEmptyState(context)
          else ...[
            // Today's tasks
            if (todayTasks.isNotEmpty) ...[
              _buildSectionHeader(context, 'Tasks', Icons.check_circle_outline),
              ...todayTasks
                  .take(3)
                  .map((taskWithPage) => _buildTaskItem(context, taskWithPage)),
              if (todayTasks.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '+ ${todayTasks.length - 3} more tasks',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getTextSecondary(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],

            // Today's events
            if (todayEvents.isNotEmpty) ...[
              _buildSectionHeader(context, 'Events', Icons.event_outlined),
              ...todayEvents.map(
                (eventWithPage) => _buildEventItem(context, eventWithPage),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: title == 'Tasks' ? Colors.green : Colors.blue,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, TodoWithPage taskWithPage) {
    final task = taskWithPage.todo;
    final page = taskWithPage.page;
    final appStateProvider = Provider.of<AppStateProvider>(
      context,
      listen: false,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Find the todo block containing this task and update it
              for (final block in page.contentBlocks) {
                if (block.type == ContentBlockType.todo) {
                  final todoBlock = block as TodoBlock;
                  final todoIndex = todoBlock.items.indexWhere(
                    (item) => item.id == task.id,
                  );

                  if (todoIndex != -1) {
                    // Create updated todo with toggled completion status
                    final updatedTodo = task.copyWith(
                      isCompleted: !task.isCompleted,
                    );

                    // Create updated items list
                    final updatedItems = List<TodoItem>.from(todoBlock.items);
                    updatedItems[todoIndex] = updatedTodo;

                    // Create updated block
                    final updatedBlock = todoBlock.copyWith(
                      items: updatedItems,
                    );

                    // Update the page
                    page.updateContentBlock(block.id, updatedBlock);

                    // Save the page
                    final updatedPage = page.copyWith(
                      updatedAt: DateTime.now(),
                    );
                    appStateProvider.updatePage(updatedPage);

                    break;
                  }
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(
                2,
              ), // Add padding for better tap area
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: task.isCompleted ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: task.isCompleted
                        ? Colors.green
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: task.isCompleted
                        ? AppTheme.getTextSecondary(context)
                        : AppTheme.getTextPrimary(context),
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${page.emoji ?? '📄'} ${page.title}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getTextSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• Due ${_formatDate(task.dueDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isOverdue(task.dueDate!)
                              ? Colors.red
                              : AppTheme.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (task.priority == TodoPriority.urgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Urgent',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, EventWithPage eventWithPage) {
    final event = eventWithPage.event;
    final page = eventWithPage.page;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${page.emoji ?? '📄'} ${page.title}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getTextSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatEventTime(event),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
                if (event.location?.physical?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    event.location!.physical!,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.getTextSecondary(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isEventSoon(event.startTime)
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _isEventSoon(event.startTime) ? 'Soon' : 'Today',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _isEventSoon(event.startTime)
                    ? Colors.orange
                    : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6366F1).withValues(alpha: 0.05),
            const Color(0xFF8B5CF6).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          // Animated emoji
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 32,
              color: Color(0xFF10B981), // Green color for completion/success
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'No tasks or events for today.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getTextSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Time to relax or create something new!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: 24),

          // Action suggestions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSuggestionChip(
                context,
                Icons.add_rounded,
                'Create Page',
                const Color(0xFF10B981), // Green for create action
                () => _createNewPage(context),
              ),
              const SizedBox(width: 12),
              _buildSuggestionChip(
                context,
                Icons.menu_book_rounded,
                'Browse Pages',
                const Color(0xFF3B82F6), // Blue for browse action
                () {
                  // Open drawer on mobile or navigate to first page on desktop
                  if (widget.isEmbedded) {
                    final appState = Provider.of<AppStateProvider>(
                      context,
                      listen: false,
                    );
                    if (appState.pages.isNotEmpty) {
                      Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      ).navigateToPage(appState.pages.first);
                    }
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '🌙 Good night!';
    if (hour < 12) return '☀️ Good morning!';
    if (hour < 17) return '☀️ Good afternoon!';
    if (hour < 21) return '🌇 Good evening!';
    return '🌙 Good night!';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  String _formatEventTime(EventItem event) {
    final start = _formatTime(event.startTime);
    final end = event.endTime != null ? _formatTime(event.endTime!) : null;
    return end != null ? '$start - $end' : start;
  }

  bool _isEventSoon(DateTime eventTime) {
    final now = DateTime.now();
    final difference = eventTime.difference(now).inHours;
    return difference >= 0 && difference <= 2;
  }

  bool _isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }

  void _createNewPage(BuildContext context) {
    // Always use NavigationProvider for consistent navigation
    Provider.of<NavigationProvider>(context, listen: false).navigateToNewPage();
  }

  // Helper methods
  int _getTotalTasks(AppStateProvider appStateProvider) {
    return appStateProvider.pages
        .expand((page) => page.todoBlocks)
        .expand((block) => block.items)
        .length;
  }

  int _getCompletedTasks(AppStateProvider appStateProvider) {
    return appStateProvider.pages
        .expand((page) => page.todoBlocks)
        .expand((block) => block.items)
        .where((todo) => todo.isCompleted)
        .length;
  }

  int _getTotalEvents(AppStateProvider appStateProvider) {
    return appStateProvider.pages
        .expand((page) => page.eventBlocks)
        .expand((block) => block.events)
        .length;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'today';
    if (dateOnly == tomorrow) return 'tomorrow';
    if (dateOnly.isBefore(today)) return 'overdue';
    return '${date.day}/${date.month}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
