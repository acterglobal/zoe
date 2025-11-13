import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:zoe/core/routing/app_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/share/widgets/sheet_join_preview_widget.dart';

final _logger = Logger('DeepLinkInitializer');

/// Initializes and listens for incoming deep links.
/// When a valid sheet link is received, navigates to home and shows the join preview.
class DeepLinkInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const DeepLinkInitializer({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DeepLinkInitializer> createState() => _DeepLinkInitializerState();
}

class _DeepLinkInitializerState extends ConsumerState<DeepLinkInitializer> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    await _handleInitialLink();
    _listenToIncomingLinks();
  }

  Future<void> _handleInitialLink() async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null && mounted) {
        _handleUri(initialLink);
      }
    } catch (error) {
      _logger.severe('Error getting initial link', error);
    }
  }

  void _listenToIncomingLinks() {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (mounted) _handleUri(uri);
      },
      onError: (error) => _logger.severe('Error in link stream', error),
    );
  }

  void _handleUri(Uri uri) {
    try {
      final sheetId = _extractSheetId(uri);
      if (sheetId == null || sheetId.isEmpty) {
        _logger.severe('No sheet ID found in URI', uri.toString());
        return;
      }

      // Delay slightly to ensure router is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _navigateAndShowJoinSheet(sheetId);
        });
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

  void _navigateAndShowJoinSheet(String sheetId) {
    try {
      final router = ref.read(routerProvider);
      router.go(AppRoutes.home.route);

      // Wait for navigation to complete before showing the sheet
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        final context = router.routerDelegate.navigatorKey.currentContext;
        if (context == null || !context.mounted) {
          _logger.severe('Context unavailable for showing join dialog', sheetId);
          return;
        }

        showJoinSheetBottomSheet(
          context: context,
          parentId: sheetId,
        );
      });
    } catch (error) {
      _logger.severe('Error navigating or showing join sheet', error);
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
