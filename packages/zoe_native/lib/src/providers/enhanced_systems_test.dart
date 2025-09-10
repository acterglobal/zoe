import 'dart:async';
import 'package:riverpod/riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/src/rust/api/system_test.dart';
import 'package:zoe_native/src/rust/third_party/zoe_client/frb_api.dart';
import 'package:zoe_native/src/rust/third_party/zoe_client/system_check.dart';
import 'package:zoe_native/src/support.dart';

/// Enhanced systems test result with streaming updates
class EnhancedSystemsTestResult {
  final bool success;
  final DateTime timestamp;
  final Duration totalDuration;
  final SystemCheckResults? currentResults;
  final List<StreamingTestCategory> categories;
  final ClientInfo clientInfo;
  final TestProgress? progress;
  final bool isRunning;

  const EnhancedSystemsTestResult({
    required this.success,
    required this.timestamp,
    required this.totalDuration,
    required this.currentResults,
    required this.categories,
    required this.clientInfo,
    this.progress,
    required this.isRunning,
  });

  EnhancedSystemsTestResult copyWith({
    bool? success,
    DateTime? timestamp,
    Duration? totalDuration,
    SystemCheckResults? currentResults,
    List<StreamingTestCategory>? categories,
    ClientInfo? clientInfo,
    TestProgress? progress,
    bool? isRunning,
  }) {
    return EnhancedSystemsTestResult(
      success: success ?? this.success,
      timestamp: timestamp ?? this.timestamp,
      totalDuration: totalDuration ?? this.totalDuration,
      currentResults: currentResults ?? this.currentResults,
      categories: categories ?? this.categories,
      clientInfo: clientInfo ?? this.clientInfo,
      progress: progress ?? this.progress,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

/// Streaming test category with live updates
class StreamingTestCategory {
  final TestCategory category;
  final String displayName;
  final String description;
  final bool hasFailures;
  final bool isCompleted;
  final bool isCurrentlyTesting;
  final List<TestInfo> tests;
  final Duration duration;

  const StreamingTestCategory({
    required this.category,
    required this.displayName,
    required this.description,
    required this.hasFailures,
    required this.isCompleted,
    required this.isCurrentlyTesting,
    required this.tests,
    required this.duration,
  });
}

/// Test progress information for live updates
class TestProgress {
  final String currentTest;
  final int completedTests;
  final int totalTests;
  final String status;
  final Duration elapsed;

  const TestProgress({
    required this.currentTest,
    required this.completedTests,
    required this.totalTests,
    required this.status,
    required this.elapsed,
  });

  double get progressPercent =>
      totalTests > 0 ? completedTests / totalTests : 0.0;
}

/// Client information for display
class ClientInfo {
  final String clientId;
  final String serverAddress;
  final String serverKey;
  final bool isConnected;
  final List<RelayServerInfo> relayServers;

  const ClientInfo({
    required this.clientId,
    required this.serverAddress,
    required this.serverKey,
    required this.isConnected,
    required this.relayServers,
  });
}

/// Relay server information for testing
class RelayServerInfo {
  final String address;
  final String keyHex;
  final String keyId;
  final bool isConnected;
  final bool isDefault;

  const RelayServerInfo({
    required this.address,
    required this.keyHex,
    required this.keyId,
    required this.isConnected,
    required this.isDefault,
  });
}

/// Result of testing a specific relay server
class RelayTestResult {
  final RelayServerInfo server;
  final bool success;
  final Duration duration;
  final String? error;
  final DateTime timestamp;

  const RelayTestResult({
    required this.server,
    required this.success,
    required this.duration,
    required this.error,
    required this.timestamp,
  });
}

/// Trace message collected during testing
class TraceMessage {
  final DateTime timestamp;
  final String level;
  final String target;
  final String message;
  final String? category;

  const TraceMessage({
    required this.timestamp,
    required this.level,
    required this.target,
    required this.message,
    this.category,
  });
}

/// Diagnostic message (errors/warnings)
class DiagnosticMessage {
  final String level;
  final String message;
  final DateTime timestamp;

  const DiagnosticMessage({
    required this.level,
    required this.message,
    required this.timestamp,
  });
}

/// Enhanced systems test category with trace data
class SystemsTestCategory {
  final String categoryName;
  final String displayName;
  final bool hasFailures;
  final String description;
  final List<TraceMessage> traces;
  final Duration duration;

  const SystemsTestCategory({
    required this.categoryName,
    required this.displayName,
    required this.hasFailures,
    required this.description,
    required this.traces,
    required this.duration,
  });
}

/// Enhanced systems test provider with trace collection
class EnhancedSystemsTestNotifier
    extends AsyncNotifier<EnhancedSystemsTestResult> {
  StreamSubscription<SystemCheckResults>? _testSubscription;
  DateTime _testStartTime = DateTime.now();
  final Map<TestCategory, StreamingTestCategory> _categoryStates = {};

  @override
  Future<EnhancedSystemsTestResult> build() async {
    // Load client info immediately to show relay servers
    try {
      final client = await ref.read(clientProvider.future);
      final clientInfo = await _getClientInfo(client);

      // Initialize all categories as pending
      _initializeCategories();

      // Return initial state with client info but no test results
      return EnhancedSystemsTestResult(
        success: false,
        timestamp: DateTime.now(),
        totalDuration: Duration.zero,
        currentResults: null,
        categories: _categoryStates.values.toList(),
        clientInfo: clientInfo,
        isRunning: false,
      );
    } catch (e) {
      throw AsyncError(
        'Failed to load client information: $e',
        StackTrace.current,
      );
    }
  }

  void _initializeCategories() {
    final allCategories = [
      TestCategory.connectivity,
      TestCategory.storage,
      TestCategory.blobService,
      TestCategory.offlineStorage,
      TestCategory.offlineBlob,
      TestCategory.synchronization,
    ];

    for (final category in allCategories) {
      _categoryStates[category] = StreamingTestCategory(
        category: category,
        displayName: _getCategoryDisplayName(category),
        description: _getCategoryDescription(category, false),
        hasFailures: false,
        isCompleted: false,
        isCurrentlyTesting: false,
        tests: [],
        duration: Duration.zero,
      );
    }
  }

  /// Run comprehensive systems test with streaming updates
  Future<void> runSystemsTest() async {
    await runSystemsTestForServer(null);
  }

  /// Run systems test against a specific relay server with streaming updates
  Future<void> runSystemsTestForServer(RelayServerInfo? targetServer) async {
    try {
      // Cancel any existing test
      await _cancelCurrentTest();

      final client = await ref.read(clientProvider.future);
      _testStartTime = DateTime.now();

      // Prepare client for systems test by configuring the relay server
      // Log the server details for debugging
      // print('Preparing client with server: $defaultServerAddr');
      // print('Server key: ${defaultServerKey.substring(0, 16)}...');

      final success = await prepareClientForSystemsTest(
        client: client,
        serverAddress: defaultServerAddr,
        serverKeyHex: defaultServerKey,
      );

      if (!success) {
        state = AsyncValue.error(
          'Failed to prepare client for systems test',
          StackTrace.current,
        );
        return;
      }

      // Give the client a moment to establish connection
      // Connection establishment is asynchronous and may take time
      await Future.delayed(const Duration(seconds: 2));

      // Reset all categories to pending state
      _initializeCategories();

      // Update state to show test is starting
      state = AsyncValue.data(
        state.value!.copyWith(
          isRunning: true,
          categories: _categoryStates.values.toList(),
        ),
      );

      // Start the streaming test
      _testSubscription = runSystemTests(client: client).listen(
        _handleTestUpdate,
        onError: _handleTestError,
        onDone: _handleTestComplete,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> _cancelCurrentTest() async {
    await _testSubscription?.cancel();
    _testSubscription = null;
  }

  void _handleTestUpdate(SystemCheckResults results) async {
    try {
      // Extract information from the results
      final categories = await systemCheckResultsGetCategories(
        results: results,
      );
      final isSuccess = await systemCheckResultsIsSuccess(results: results);
      final totalDurationMs = await systemCheckResultsTotalDurationMs(
        results: results,
      );

      // Reset all categories to pending first
      _initializeCategories();

      // Update category states based on current results
      for (final category in categories) {
        final tests = await systemCheckResultsGetTestsForCategory(
          results: results,
          category: category,
        );
        final hasFailures = await systemCheckResultsCategoryHasFailures(
          results: results,
          category: category,
        );

        _categoryStates[category] = StreamingTestCategory(
          category: category,
          displayName: _getCategoryDisplayName(category),
          description: _getCategoryDescription(category, hasFailures),
          hasFailures: hasFailures,
          isCompleted: true,
          isCurrentlyTesting: false,
          tests: tests,
          duration: Duration(milliseconds: totalDurationMs.toInt()),
        );
      }

      // Determine which test is currently running based on logical flow
      String? currentTestName;
      final completedCategories = categories.length;
      final allCategories = [
        TestCategory.offlineStorage,
        TestCategory.offlineBlob,
        TestCategory.connectivity,
        TestCategory.storage,
        TestCategory.blobService,
        TestCategory.synchronization,
      ];

      // Find the next category that should be running
      if (completedCategories < allCategories.length) {
        final nextCategory = allCategories[completedCategories];
        currentTestName = _getCategoryDisplayName(nextCategory);

        // Mark the next category as currently testing
        _categoryStates[nextCategory] = StreamingTestCategory(
          category: nextCategory,
          displayName: _getCategoryDisplayName(nextCategory),
          description: 'Testing in progress...',
          hasFailures: false,
          isCompleted: false,
          isCurrentlyTesting: true,
          tests: [],
          duration: Duration.zero,
        );
      }

      final progress = TestProgress(
        currentTest: currentTestName ?? 'Completed',
        completedTests: completedCategories,
        totalTests: allCategories.length,
        status: completedCategories < allCategories.length
            ? 'Running ${currentTestName ?? "tests"}...'
            : 'Completed',
        elapsed: DateTime.now().difference(_testStartTime),
      );

      // Check if test is complete (no more categories to test)
      final isTestComplete = completedCategories >= allCategories.length;

      // Update state with live results
      state = AsyncValue.data(
        EnhancedSystemsTestResult(
          success: isSuccess,
          timestamp: _testStartTime,
          totalDuration: Duration(milliseconds: totalDurationMs.toInt()),
          currentResults: results,
          categories: _categoryStates.values.toList(),
          clientInfo: state.value!.clientInfo,
          progress: isTestComplete ? null : progress,
          isRunning: !isTestComplete,
        ),
      );
    } catch (e, stackTrace) {
      // Log error for debugging
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void _handleTestError(Object error, StackTrace stackTrace) {
    // Handle test stream error
    state = AsyncValue.error(error, stackTrace);
  }

  void _handleTestComplete() async {
    // Test stream completed

    // Mark test as no longer running
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.copyWith(isRunning: false, progress: null),
      );
    }

    _testSubscription = null;
  }

  // Helper methods
  Future<ClientInfo> _getClientInfo(client) async {
    try {
      final clientId = await client.idHex();
      final relayServers = await _getRelayServerInfo(client);

      return ClientInfo(
        clientId: clientId.length > 16
            ? '${clientId.substring(0, 16)}...'
            : clientId,
        serverAddress: defaultServerAddr,
        serverKey: defaultServerKey.length > 16
            ? '${defaultServerKey.substring(0, 16)}...'
            : defaultServerKey,
        isConnected: false, // We'll determine this during testing
        relayServers: relayServers,
      );
    } catch (e) {
      return ClientInfo(
        clientId: 'Unknown',
        serverAddress: defaultServerAddr,
        serverKey: 'Unknown',
        isConnected: false,
        relayServers: [],
      );
    }
  }

  Future<List<RelayServerInfo>> _getRelayServerInfo(client) async {
    try {
      // For now, return empty list - we can enhance this later
      return [];
    } catch (e) {
      return [];
    }
  }

  String _getCategoryDisplayName(TestCategory category) => switch (category) {
    TestCategory.connectivity => 'Connectivity',
    TestCategory.storage => 'Storage',
    TestCategory.blobService => 'Blob Service',
    TestCategory.offlineStorage => 'Offline Storage',
    TestCategory.offlineBlob => 'Offline Blob',
    TestCategory.synchronization => 'Synchronization',
  };

  String _getCategoryDescription(TestCategory category, bool hasFailures) {
    final status = hasFailures ? 'Failed' : 'Passed';
    return switch (category) {
      TestCategory.connectivity =>
        '$status - Server connectivity and handshake tests',
      TestCategory.storage =>
        '$status - Online message storage and retrieval tests',
      TestCategory.blobService =>
        '$status - Online blob service upload/download tests',
      TestCategory.offlineStorage =>
        '$status - Offline storage tests (without relay connection)',
      TestCategory.offlineBlob =>
        '$status - Offline blob service tests (without relay connection)',
      TestCategory.synchronization =>
        '$status - Message and blob synchronization tests',
    };
  }

  void dispose() {
    _testSubscription?.cancel();
  }
}

/// Provider for enhanced systems test state
final enhancedSystemsTestProvider =
    AsyncNotifierProvider<
      EnhancedSystemsTestNotifier,
      EnhancedSystemsTestResult
    >(() => EnhancedSystemsTestNotifier());
