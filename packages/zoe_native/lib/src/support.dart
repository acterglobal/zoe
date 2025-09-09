import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zoe_native/zoe_native.dart';
import 'package:logging/logging.dart';

final _log = Logger('zoe_native::support');

const rustLogKey = 'RUST_LOG';
const proxyKey = 'HTTP_PROXY';
const bool isDevBuild = !bool.fromEnvironment('dart.vm.product');

// default development server
const defaultServerAddr = 'a.dev.hellozoe.app:13918';
const defaultServerKey =
    '00201f12f22a1ed75a2e12462c8c106121db49a779d1bd2fb9c96a881835c068f09c';

FlutterSecureStorage? _globalStorage;
String _globalSessionKey = 'clientSecret';

void initStorage({
  required String appleKeychainAppGroupName,
  String? sessionKey,
}) {
  if (_globalStorage != null) {
    throw 'Storage already initialized';
  }
  if (sessionKey != null) {
    _globalSessionKey = sessionKey;
  }

  _globalStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      preferencesKeyPrefix: isDevBuild ? 'dev.flutter' : null,
    ),
    iOptions: IOSOptions(
      synchronizable: false,
      accessibility: KeychainAccessibility
          .first_unlock, // must have been unlocked since reboot
      groupId:
          appleKeychainAppGroupName, // to allow the background process to access the same store
    ),
    mOptions: MacOsOptions(
      synchronizable: false,
      accessibility: KeychainAccessibility
          .first_unlock, // must have been unlocked since reboot
      groupId:
          appleKeychainAppGroupName, // to allow the background process to access the same store
    ),
  );
}

Completer<String>? _appDirCompl;
Completer<String>? _appCacheDirCompl;
Completer<Client>? _clientCompl;

Future<String> appDir() async {
  if (_appDirCompl == null) {
    Completer<String> completer = Completer();
    completer.complete(appDirInner());
    _appDirCompl = completer;
  }
  return _appDirCompl!.future;
}

Future<String> appCacheDir() async {
  if (_appCacheDirCompl == null) {
    Completer<String> completer = Completer();
    completer.complete(appCacheDirInner());
    _appCacheDirCompl = completer;
  }
  return _appCacheDirCompl!.future;
}

Future<String> appDirInner() async {
  Directory appDocDir = await getApplicationSupportDirectory();
  if (isDevBuild) {
    // on dev we put this into a subfolder to separate from any installed version
    appDocDir = Directory(p.join(appDocDir.path, 'DEV'));
    if (!await appDocDir.exists()) {
      await appDocDir.create();
    }
  }
  return appDocDir.path;
}

Future<String> appCacheDirInner() async {
  Directory appCacheDir = await getApplicationCacheDirectory();
  if (isDevBuild) {
    // on dev we put this into a subfolder to separate from any installed version
    appCacheDir = Directory(p.join(appCacheDir.path, 'DEV'));
    if (!await appCacheDir.exists()) {
      await appCacheDir.create();
    }
  }
  return appCacheDir.path;
}

Future<void> _writeClientSecret(String clientSecret) async {
  if (_globalStorage == null) {
    throw 'Secure Storage not initialized. call initStorage() first!';
  }
  final storage = _globalStorage!;
  await storage.write(key: _globalSessionKey, value: clientSecret);
}

Future<String?> _readClientSecret() async {
  if (_globalStorage == null) {
    throw 'Secure Storage not initialized. call initStorage() first!';
  }
  final storage = _globalStorage!;
  final sessionKey = _globalSessionKey;

  int delayedCounter = 0;
  while ((await storage.isCupertinoProtectedDataAvailable()) == false) {
    if (delayedCounter > 10) {
      _log.severe('Secure Store: not available after 10 seconds');
      throw 'Secure Store: not available';
    }
    delayedCounter += 1;
    _log.info('Secure Store: not available yet. Delaying');
    await Future.delayed(const Duration(milliseconds: 50));
  }

  _log.info('Secure Store: available. Attempting to read.');
  if (Platform.isAndroid) {
    // fake read for https://github.com/mogol/flutter_secure_storage/issues/566
    _log.info('Secure Store: fake read for android');
    await storage.read(key: sessionKey);
  }
  _log.info('Secure Store: attempting to check if $sessionKey exists');
  String? sessionsStr;
  try {
    sessionsStr = await storage.read(key: sessionKey);
  } on PlatformException catch (error, stack) {
    if (error.code == '-25300') {
      _log.severe('Ignoring read failure for missing key $sessionKey');
    } else {
      _log.severe(
        'Ignoring read failure of session key $sessionKey',
        error,
        stack,
      );
    }
  } catch (error, stack) {
    _log.severe(
      'Ignoring read failure of session key $sessionKey',
      error,
      stack,
    );
  }

  return sessionsStr;
}

Future<ClientBuilder> _defaultClientBuilder({
  String? serverAddr,
  String? serverKey,
}) async {
  ClientBuilder builder = await ClientBuilder.default_();

  builder.dbStorageDir(path: await appDir());
  builder.mediaStorageDir(mediaStorageDir: await appCacheDir());

  serverAddr ??= defaultServerAddr;
  serverKey ??= defaultServerKey;

  builder.serverInfo(
    serverPublicKey: await VerifyingKey.fromHex(hex: serverKey),
    serverAddr: await resolveToSocketAddr(s: serverAddr),
  );
  return builder;
}

Future<Client> _loadOrGenerateClient() async {
  final clientSecret = await _readClientSecret();
  final builder = await _defaultClientBuilder();
  if (clientSecret != null) {
    builder.clientSecret(secret: await ClientSecret.fromHex(hex: clientSecret));
    return await builder.build();
  }
  final client = await builder.build();
  final clientSecretHex = await client.clientSecretHex();
  await _writeClientSecret(clientSecretHex);
  return client;
}

Future<Client> loadOrGenerateClient() async {
  if (_clientCompl == null) {
    Completer<Client> completer = Completer();
    completer.complete(await _loadOrGenerateClient());
    _clientCompl = completer;
  }
  return _clientCompl!.future;
}
