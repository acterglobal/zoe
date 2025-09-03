import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoe_native/zoe_native.dart';

const rustLogKey = 'RUST_LOG';
const proxyKey = 'HTTP_PROXY';
const bool isDevBuild = !bool.fromEnvironment('dart.vm.product');

// default development server
const defaultServerAddr = 'a.dev.hellozoe.app:13918';
const defaultServerKey =
    '00201f12f22a1ed75a2e12462c8c106121db49a779d1bd2fb9c96a881835c068f09c';

Completer<SharedPreferences>? _sharedPrefCompl;
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

@visibleForTesting
Future<void> resetSharedPrefs() async {
  _sharedPrefCompl = null;
}

Future<SharedPreferences> sharedPrefs() async {
  if (_sharedPrefCompl == null) {
    // if (isDevBuild) {
    //   // on dev we put this into a prefix to separate from any installed version
    //   SharedPreferences.setPrefix('dev.flutter');
    // }
    final Completer<SharedPreferences> completer =
        Completer<SharedPreferences>();
    completer.complete(SharedPreferences.getInstance());
    _sharedPrefCompl = completer;
  }

  return _sharedPrefCompl!.future;
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
  final prefs = await sharedPrefs();
  final clientSecret = prefs.getString('clientSecret');
  final builder = await _defaultClientBuilder();
  if (clientSecret != null) {
    builder.clientSecret(secret: await ClientSecret.fromHex(hex: clientSecret));
    return await builder.build();
  }
  final client = await builder.build();
  final clientSecretHex = await client.clientSecretHex();
  await prefs.setString('clientSecret', clientSecretHex);
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
