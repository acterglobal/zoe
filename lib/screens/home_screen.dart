import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../common/providers/app_state_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/todo_item_widget.dart';
import '../widgets/event_item_widget.dart';
import 'page_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FE),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: const Color(0xFFF8F9FE),
              elevation: 0,
              floating: true,
              leading: IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFF1F2937)),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF1F2937),
                  ),
                  onPressed: () {
                    // TODO: Implement search
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Greeting Section
                  _buildGreetingSection(),
                  const SizedBox(height: 32),

                  // Today's Tasks Section
                  _buildTodaysTasksSection(),
                  const SizedBox(height: 24),

                  // Today's Events Section
                  _buildTodaysEventsSection(),
                  const SizedBox(height: 24),

                  // Upcoming Events Section
                  _buildUpcomingEventsSection(),
                  const SizedBox(height: 24),

                  // Quick Actions Section
                  _buildQuickActionsSection(),
                  const SizedBox(height: 100), // Bottom padding
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewPage(context),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final hour = DateTime.now().hour;
        String greeting;
        String emoji;

        if (hour < 12) {
          greeting = 'Good morning';
          emoji = '🌅';
        } else if (hour < 17) {
          greeting = 'Good afternoon';
          emoji = '☀️';
        } else {
          greeting = 'Good evening';
          emoji = '🌙';
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, ${appState.userName}!',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, MMMM d').format(DateTime.now()),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Ready to be productive?',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildTodaysTasksSection() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final todaysTodos = appState.getTodaysTodos();
        final completedCount = todaysTodos
            .where((todo) => todo.isCompleted)
            .length;
        final totalCount = todaysTodos.length;

        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Today\'s Tasks',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const Spacer(),
                    if (totalCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$completedCount/$totalCount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (todaysTodos.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 48,
                          color: const Color(0xFF10B981).withOpacity(0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'All caught up!',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No tasks for today. Time to relax!',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: todaysTodos.take(3).map((todo) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TodoItemWidget(todo: todo),
                      );
                    }).toList(),
                  ),
                if (todaysTodos.length > 3)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all tasks view
                    },
                    child: Text(
                      'View all ${todaysTodos.length} tasks',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
              ],
            )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildTodaysEventsSection() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final todaysEvents = appState.getTodaysEvents();

        if (todaysEvents.isEmpty) return const SizedBox.shrink();

        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Events',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: todaysEvents.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EventItemWidget(event: event),
                    );
                  }).toList(),
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final upcomingEvents = appState.getUpcomingEvents();

        if (upcomingEvents.isEmpty) return const SizedBox.shrink();

        return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Week',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: upcomingEvents.take(3).map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: EventItemWidget(event: event),
                    );
                  }).toList(),
                ),
                if (upcomingEvents.length > 3)
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all events view
                    },
                    child: Text(
                      'View all upcoming events',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
              ],
            )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add_task_rounded,
                    title: 'Add Task',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      // TODO: Add quick task
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.event_rounded,
                    title: 'Schedule Event',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      // TODO: Add quick event
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.note_add_rounded,
                    title: 'New Page',
                    color: const Color(0xFF6366F1),
                    onTap: () => _createNewPage(context),
                  ),
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  void _createNewPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PageDetailScreen()));
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
