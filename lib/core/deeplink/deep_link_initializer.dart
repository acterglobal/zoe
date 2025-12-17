import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/share/widgets/sheet_join_preview_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

final _logger = Logger('DeepLinkInitializer');

/// Initializes and listens for incoming deep links.
/// When a valid sheet link is received, navigates to home and shows the join preview.
class DeepLinkInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const DeepLinkInitializer({super.key, required this.child});

  @override
  ConsumerState<DeepLinkInitializer> createState() =>
      _DeepLinkInitializerState();
}

class _DeepLinkInitializerState extends ConsumerState<DeepLinkInitializer> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = ref.read(appLinksProvider);
    _listenToIncomingLinks();
  }

  void _listenToIncomingLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (mounted) _handleUri(uri);
    }, onError: (error) => _logger.severe('Error in link stream', error));
  }

  void _handleUri(Uri uri) {
    try {
      final sheetId = _extractSheetId(uri);
      if (sheetId == null || sheetId.isEmpty) return;

      final sharedBy = uri.queryParameters['sharedBy'];
      final message = uri.queryParameters['message'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _navigateAndShowJoinSheet(
          sheetId,
          sharedBy: sharedBy,
          message: message,
        );
      });
    } catch (error) {
      _logger.severe('Error handling URI: $uri', error);
    }
  }

  String? _extractSheetId(Uri uri) {
    // Only support links of the form: https://hellozoe.app/sheet/<sheetId>
    if (uri.scheme != 'https') return null;
    if (uri.host.toLowerCase() != 'hellozoe.app') return null;

    final segments = uri.pathSegments;
    if (segments.length < 2) return null;
    if (segments.first != 'sheet') return null;

    final sheetId = segments[1];
    if (sheetId.isEmpty) return null;
    return sheetId;
  }

  Future<void> _navigateAndShowJoinSheet(
    String sheetId, {
    String? sharedBy,
    String? message,
  }) async {
    try {
      final currentUser = ref.read(authProvider);
      if (currentUser == null) return;

      final router = ref.read(routerProvider);
      router.go(AppRoutes.home.route);

      final context = router.routerDelegate.navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        _logger.severe('Context unavailable after navigation');
        return;
      }

      final sheet = await ref.read(getSheetByIdProvider(sheetId).future);
      if (sheet == null || !context.mounted) {
        _logger.warning('Sheet not found or access denied: $sheetId');
        return;
      }

      if (sharedBy != null || message != null) {
        ref
            .read(sheetListProvider.notifier)
            .updateSheetShareInfo(
              sheetId: sheetId,
              sharedBy: sharedBy,
              message: message,
            );
      }

      final isMember = sheet.users.contains(currentUser.id);
      if (!isMember) {
        showJoinSheetBottomSheet(context: context, sheet: sheet);
      } else {
        router.push(AppRoutes.sheet.route.replaceAll(':sheetId', sheetId));
      }
    } catch (error, stack) {
      _logger.severe('Deep link navigation failed', error, stack);
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
