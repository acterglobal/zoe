import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/zoe_native.dart';

class SystemsTestScreen extends ConsumerWidget {
  const SystemsTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemsTestState = ref.watch(enhancedSystemsTestProvider);

    return systemsTestState.when(
      data: (result) => _buildTabsWithRelayServers(context, ref, result),
      loading: () => _buildLoadingScreen(context),
      error: (error, stackTrace) => _buildErrorScreen(context, error),
    );
  }

  Widget _buildTabsWithRelayServers(
    BuildContext context,
    WidgetRef ref,
    EnhancedSystemsTestResult result,
  ) {
    final relayServers = result.clientInfo.relayServers;
    final allServers = [
      // Default server first
      RelayServerInfo(
        address: defaultServerAddr,
        keyHex: defaultServerKey,
        keyId: 'default',
        isConnected: false,
        isDefault: true,
      ),
      // Then configured relay servers (excluding default)
      ...relayServers.where((server) => !server.isDefault),
    ];

    return DefaultTabController(
      length: allServers.length,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              // Client Information Section (always visible)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildClientInfoSection(
                  context,
                  AsyncValue.data(result),
                ),
              ),

              // Tab Bar for relay servers
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassyContainer(
                  child: TabBar(
                    isScrollable: allServers.length > 3,
                    tabs: allServers.map((server) {
                      return Tab(
                        icon: Icon(
                          server.isDefault
                              ? Icons.settings_ethernet
                              : Icons.router,
                        ),
                        text: server.isDefault
                            ? 'Default Server'
                            : server.address,
                      );
                    }).toList(),
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    indicatorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // Tab Views for each relay server
              Expanded(
                child: TabBarView(
                  children: allServers.map((server) {
                    return _buildServerTestTab(context, ref, server, result);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading client information...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context, Object error) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Failed to load client information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const ZoeAppBar(title: 'Systems Test'),
    );
  }

  Widget _buildServerTestTab(
    BuildContext context,
    WidgetRef ref,
    RelayServerInfo server,
    EnhancedSystemsTestResult currentResult,
  ) {
    final systemsTestState = ref.watch(enhancedSystemsTestProvider);

    return Center(
      child: MaxWidthWidget(
        isScrollable: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Server Information Section
            _buildServerInfoSection(context, server),
            const SizedBox(height: 20),

            // Test Control Section for this server
            _buildServerTestControlSection(
              context,
              ref,
              server,
              systemsTestState,
            ),
            const SizedBox(height: 20),

            // Results Section - show live results as they come in
            if (systemsTestState.hasValue || systemsTestState.hasError)
              _buildResultsSection(context, systemsTestState),
          ],
        ),
      ),
    );
  }

  Widget _buildServerInfoSection(BuildContext context, RelayServerInfo server) {
    return GlassyContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  server.isDefault ? Icons.settings_ethernet : Icons.router,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  server.isDefault
                      ? 'Default Server Information'
                      : 'Relay Server Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildInfoRow(context, 'Address', server.address),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Server Key', server.keyHex),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Status',
              server.isConnected ? 'Connected' : 'Disconnected',
              statusColor: server.isConnected ? Colors.green : Colors.red,
            ),
            if (server.isDefault) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                'Purpose',
                'Development server for testing connectivity',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServerTestControlSection(
    BuildContext context,
    WidgetRef ref,
    RelayServerInfo server,
    AsyncValue<EnhancedSystemsTestResult> state,
  ) {
    final isRunning =
        state.isLoading || (state.hasValue && state.value!.progress != null);

    return GlassyContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Systems Test for ${server.isDefault ? 'Default Server' : server.address}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isRunning
                    ? null
                    : () => ref
                          .read(enhancedSystemsTestProvider.notifier)
                          .runSystemsTestForServer(
                            server.isDefault ? null : server,
                          ),
                icon: isRunning
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.health_and_safety),
                label: Text(
                  isRunning ? 'Running Tests...' : 'Start Systems Test',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: server.isDefault
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // Show live progress or loading state
            if (isRunning) ...[
              const SizedBox(height: 12),
              _buildProgressIndicator(context, state),
              const SizedBox(height: 8),
              _buildProgressText(context, state, server),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    AsyncValue<EnhancedSystemsTestResult> state,
  ) {
    if (state.hasValue && state.value!.progress != null) {
      final progress = state.value!.progress!;
      return Column(
        children: [
          LinearProgressIndicator(
            value: progress.progressPercent,
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.completedTests}/${progress.totalTests} tests',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${progress.elapsed.inSeconds}s',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      );
    } else {
      return const LinearProgressIndicator();
    }
  }

  Widget _buildProgressText(
    BuildContext context,
    AsyncValue<EnhancedSystemsTestResult> state,
    RelayServerInfo server,
  ) {
    String progressText;

    if (state.hasValue && state.value!.progress != null) {
      final progress = state.value!.progress!;
      progressText = 'Testing ${progress.currentTest}: ${progress.status}';
    } else {
      progressText =
          'Running comprehensive system diagnostics against ${server.isDefault ? 'default server' : server.address}...';
    }

    return Text(
      progressText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildClientInfoSection(
    BuildContext context,
    AsyncValue<EnhancedSystemsTestResult> state,
  ) {
    return GlassyContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Client Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            state.when(
              data: (result) =>
                  _buildClientInfoContent(context, result.clientInfo),
              loading: () => _buildClientInfoPlaceholder(context),
              error: (error, stackTrace) =>
                  _buildClientInfoPlaceholder(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoContent(BuildContext context, ClientInfo clientInfo) {
    return Column(
      children: [
        _buildInfoRow(context, 'Client ID', clientInfo.clientId),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Server Address', clientInfo.serverAddress),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Server Key', clientInfo.serverKey),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          'Connection Status',
          clientInfo.isConnected ? 'Connected' : 'Disconnected',
          statusColor: clientInfo.isConnected ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildClientInfoPlaceholder(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, 'Client ID', 'Loading...'),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Server Address', 'a.dev.hellozoe.app:13918'),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Server Key', '00201f12...'),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Connection Status', 'Unknown'),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection(
    BuildContext context,
    AsyncValue<EnhancedSystemsTestResult> state,
  ) {
    return state.when(
      data: (result) => _buildTestResults(context, result),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => _buildErrorResults(context, error),
    );
  }

  Widget _buildTestResults(
    BuildContext context,
    EnhancedSystemsTestResult result,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Status (only show if testing is complete)
        if (result.progress == null)
          Column(
            children: [
              _buildOverallStatus(context, result),
              const SizedBox(height: 20),
            ],
          ),

        // Category Results - show all categories with live status
        ...result.categories.map((streamingCategory) {
          return Column(
            children: [
              _buildStreamingCategoryResult(context, streamingCategory),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildOverallStatus(
    BuildContext context,
    EnhancedSystemsTestResult result,
  ) {
    return GlassyContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.success
                            ? 'All Systems Operational'
                            : 'Issues Detected',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: result.success ? Colors.green : Colors.red,
                            ),
                      ),
                      Text(
                        'Completed at ${result.timestamp.toLocal().toString().split('.')[0]}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Duration: ${result.totalDuration.inMilliseconds}ms',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamingCategoryResult(
    BuildContext context,
    StreamingTestCategory category,
  ) {
    // Determine icon and color based on status
    IconData icon;
    Color iconColor;
    String statusText;

    if (category.isCurrentlyTesting) {
      icon = Icons.hourglass_empty;
      iconColor = Colors.orange;
      statusText = 'Testing in progress...';
    } else if (!category.isCompleted) {
      icon = Icons.schedule;
      iconColor = Colors.grey;
      statusText = 'Pending';
    } else {
      icon = category.hasFailures ? Icons.error : Icons.check_circle;
      iconColor = category.hasFailures ? Colors.red : Colors.green;
      statusText = category.hasFailures ? 'Failed' : 'Passed';
    }

    return GlassyContainer(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: category.isCurrentlyTesting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  ),
                )
              : Icon(icon, color: iconColor, size: 20),
          title: Text(
            category.displayName,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            category.isCurrentlyTesting || !category.isCompleted
                ? statusText
                : category.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: category.isCurrentlyTesting ? Colors.orange : null,
            ),
          ),
          children: [
            if (category.isCompleted && category.tests.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Results',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...category.tests.map(
                      (test) => _buildTestInfoItem(context, test),
                    ),
                  ],
                ),
              ),
            ] else if (category.isCompleted) ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No detailed test information available.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ] else if (category.isCurrentlyTesting) ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Test is currently running...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Test has not been run yet.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestInfoItem(BuildContext context, dynamic test) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getTestInfoData(test),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading test info...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        final testData = snapshot.data!;
        final name = testData['name'] as String;
        final isPassed = testData['isPassed'] as bool;
        final isFailed = testData['isFailed'] as bool;
        final error = testData['error'] as String?;
        final details = testData['details'] as List<String>;
        final durationMs = testData['durationMs'] as int;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPassed
                ? Colors.green.withValues(alpha: 0.1)
                : isFailed
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPassed
                  ? Colors.green.withValues(alpha: 0.3)
                  : isFailed
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isPassed
                        ? Icons.check_circle
                        : isFailed
                        ? Icons.error
                        : Icons.help_outline,
                    color: isPassed
                        ? Colors.green
                        : isFailed
                        ? Colors.red
                        : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${durationMs}ms',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: $error',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (details.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details
                        .map(
                          (detail) => Text(
                            detail,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getTestInfoData(dynamic test) async {
    try {
      final name = await testInfoGetName(test: test);
      final isPassed = await testInfoIsPassed(test: test);
      final isFailed = await testInfoIsFailed(test: test);
      final error = await testInfoGetError(test: test);
      final details = await testInfoGetDetails(test: test);
      final durationMs = await testInfoDurationMs(test: test);

      return {
        'name': name,
        'isPassed': isPassed,
        'isFailed': isFailed,
        'error': error,
        'details': details,
        'durationMs': durationMs.toInt(),
      };
    } catch (e) {
      return {
        'name': 'Unknown Test',
        'isPassed': false,
        'isFailed': true,
        'error': 'Failed to load test info: $e',
        'details': <String>[],
        'durationMs': 0,
      };
    }
  }

  Widget _buildErrorResults(BuildContext context, Object error) {
    return GlassyContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Test Failed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
