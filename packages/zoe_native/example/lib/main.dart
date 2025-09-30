import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe_native/zoe_native.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/src/support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Rust library
  await RustLib.init();
  
  // Initialize storage for the example app
  initStorage(
    appleKeychainAppGroupName: 'app.zoe.flutter.example',
    sessionKey: 'exampleClientSecret',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoe Native Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zoe Native Integration Test'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  String _status = 'Initializing...';
  final List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toIso8601String()}: $message');
    });
  }

  Future<void> _testClientCreation() async {
    try {
      _addLog('Creating client through Riverpod provider...');
      final client = await ref.read(clientProvider.future);

      final clientId = await client.idHex();
      _addLog(
        '✅ Client created successfully! ID: ${clientId.substring(0, 16)}...',
      );

      setState(() {
        _status = 'Client Ready';
      });
    } catch (e) {
      _addLog('❌ Client creation failed: $e');
      setState(() {
        _status = 'Client Failed';
      });
    }
  }

  Future<void> _testGroupCreation() async {
    try {
      _addLog('Creating group through client...');
      final client = await ref.read(clientProvider.future);

      final groupBuilder = await CreateGroupBuilder.newInstance(
        title: 'Test Group ${DateTime.now().millisecondsSinceEpoch}',
      );
      final groupId = await client.createGroup(createGroup: groupBuilder);

      _addLog('✅ Group created! ID: ${groupId.toString().substring(0, 16)}...');

      // Wait a moment for the group to appear in providers
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if group appears in providers
      final allGroups = await ref.read(allGroupIdsProvider.future);
      if (allGroups.contains(groupId)) {
        _addLog(
          '✅ Group appears in providers! Total groups: ${allGroups.length}',
        );
      } else {
        _addLog('⚠️ Group not yet visible in providers');
      }

      setState(() {
        _status = 'Group Created';
      });
    } catch (e) {
      _addLog('❌ Group creation failed: $e');
      setState(() {
        _status = 'Group Failed';
      });
    }
  }

  Future<void> _testGroupList() async {
    try {
      _addLog('Fetching group list...');
      final allGroups = await ref.read(allGroupIdsProvider.future);
      _addLog('📋 Found ${allGroups.length} groups');

      for (int i = 0; i < allGroups.length && i < 3; i++) {
        final groupId = allGroups[i];
        final groupName = await ref.read(groupNameProvider(groupId).future);
        _addLog('  - Group ${i + 1}: $groupName');
      }

      setState(() {
        _status = 'Groups Listed';
      });
    } catch (e) {
      _addLog('❌ Group list failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Status: $_status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _testClientCreation,
                          child: const Text('Test Client'),
                        ),
                        ElevatedButton(
                          onPressed: _testGroupCreation,
                          child: const Text('Create Group'),
                        ),
                        ElevatedButton(
                          onPressed: _testGroupList,
                          child: const Text('List Groups'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logs:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                              child: Text(
                                _logs[index],
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _logs.clear();
            _status = 'Cleared';
          });
        },
        tooltip: 'Clear Logs',
        child: const Icon(Icons.clear),
      ),
    );
  }
}