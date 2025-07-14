import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/models/content_block.dart';
import '../common/providers/app_state_provider.dart';
import '../common/providers/navigation_provider.dart';
import '../common/theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../screens/page_detail_screen.dart';

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
                  ? '${(tasksProgress * 100).round()}% complete'
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
              subtitle: totalEvents == 0
                  ? 'Free day ahead'
                  : totalEvents == 1
                  ? '1 event today'
                  : '$totalEvents events today',
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
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Add subtle haptic feedback
            // HapticFeedback.lightImpact();
          },
          child: Container(
            height: 160, // Reduced height to prevent overflow
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.getSurface(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.getBorder(context).withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon only
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimary(context),
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                const SizedBox(height: 1),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                const Spacer(),

                // Progress indicator (only for tasks)
                if (title == 'Tasks' && progress > 0) ...[
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.getTextSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: task.isCompleted ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: task.isCompleted ? Colors.green : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: task.isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 12)
                : null,
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
        color: AppTheme.getSurface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        children: [
          Text('🎉', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No tasks or events for today.\nTime to relax or create something new!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning! 🌅';
    if (hour < 17) return 'Good afternoon! ☀️';
    return 'Good evening! 🌙';
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
    if (widget.isEmbedded) {
      // Use navigation provider for embedded mode
      Provider.of<NavigationProvider>(
        context,
        listen: false,
      ).navigateToNewPage();
    } else {
      // Use traditional navigation for mobile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PageDetailScreen()),
      );
    }
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
