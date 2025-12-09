import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'sheet_providers.g.dart';

/// Firebase reference
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

@Riverpod(keepAlive: true)
class SheetList extends _$SheetList {
  CollectionReference<Map<String, dynamic>> get col =>
      ref.read(firestoreProvider).collection('sheets');

  @override
  List<SheetModel> build() {
    _init();
    return [];
  }

  Future<void> _init() async {
    final userId = ref.watch(loggedInUserProvider).value;
    if (userId == null) return;

    final userSheetsFuture = col.where('users', arrayContains: userId).get();

    final gettingStartedFuture = col.doc(kGettingStartedSheetId).get();

    final results = await Future.wait([userSheetsFuture, gettingStartedFuture]);

    final userSheets = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final gsDoc = results[1] as DocumentSnapshot<Map<String, dynamic>>;

    final map = <String, SheetModel>{};

    // User sheets
    for (final doc in userSheets.docs) {
      try {
        final sheet = SheetModel.fromJson(doc.data());
        map[sheet.id] = sheet;
      } catch (_) {}
    }

    // Getting Started sheet
    if (gsDoc.exists && gsDoc.data() != null) {
      try {
        final s = SheetModel.fromJson(gsDoc.data()!);
        map[s.id] = s;
      } catch (_) {}
    } else {
      // Auto-create getting started
      final gs = SheetModel(
        id: kGettingStartedSheetId,
        title: 'Getting Started Guide',
        createdBy: 'system',
        sheetAvatar: SheetAvatar(
          type: AvatarType.icon,
          data: ZoeIcon.book.name,
          color: const Color(0xFF6366F1),
        ),
        coverImageUrl:
            'https://cdn.pixabay.com/photo/2015/10/29/14/38/web-1012467_1280.jpg',
        description: (
          plainText:
              'Your complete introduction to Zoe! This interactive guide helps you start quickly.',
          htmlText:
              '<p>Your complete introduction to <strong>Zoe</strong>!</p>',
        ),
      );

      try {
        await col.doc(gs.id).set(gs.toJson());
        map[gs.id] = gs;
      } catch (_) {}
    }

    // Sort
    final items = map.values.toList()
      ..sort((a, b) {
        if (a.id == kGettingStartedSheetId) return -1;
        if (b.id == kGettingStartedSheetId) return 1;
        return a.title.compareTo(b.title);
      });

    state = items;
  }

  // ─────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────

  /// Updates local list safely
  void _updateLocalState(List<SheetModel> Function(List<SheetModel>) update) {
    state = update(state);
  }

  /// Firestore update wrapper with revert safety
  Future<void> _safeUpdate(Future<void> Function() action) async {
    final prev = state;
    try {
      await action();
    } catch (e) {
      state = prev; // Revert
      rethrow;
    }
  }

  // ─────────────────────────────────────
  // CRUD Operations
  // ─────────────────────────────────────

  Future<void> addSheet(SheetModel sheet) async {
    final userId = ref.read(loggedInUserProvider).value;
    var s = sheet;

    s = s.copyWith(
      theme:
          s.theme ??
          SheetTheme(
            primary: AppColors.primaryColor,
            secondary: AppColors.secondaryColor,
          ),
      users: [if (userId != null) userId],
      createdBy: userId,
    );

    _updateLocalState((list) => [...list, s]);

    await _safeUpdate(() async {
      await col.doc(s.id).set(s.toJson());
    });
  }

  Future<void> deleteSheet(String sheetId) async {
    _updateLocalState((list) => list.where((s) => s.id != sheetId).toList());

    await _safeUpdate(() async {
      await col.doc(sheetId).delete();
    });
  }

  Future<void> updateSheetTitle(String sheetId, String title) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId) s.copyWith(title: title) else s,
      ],
    );

    await _safeUpdate(() async {
      await col.doc(sheetId).update({
        'title': title,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateSheetCoverImage(String sheetId, String? url) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId)
            url == null ? s.removeCoverImage() : s.copyWith(coverImageUrl: url)
          else
            s,
      ],
    );

    await _safeUpdate(() async {
      await col.doc(sheetId).update({
        if (url == null)
          'coverImageUrl': FieldValue.delete()
        else
          'coverImageUrl': url,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateSheetDescription(String sheetId, Description desc) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId) s.copyWith(description: desc) else s,
      ],
    );

    await _safeUpdate(() async {
      await col.doc(sheetId).update({
        'description': {'plainText': desc.plainText, 'htmlText': desc.htmlText},
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateSheetAvatar({
    required String sheetId,
    required AvatarType type,
    required String data,
    Color? color,
  }) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId)
            s.copyWith(
              sheetAvatar: s.sheetAvatar.copyWith(
                type: type,
                data: data,
                color: color,
              ),
            )
          else
            s,
      ],
    );

    await _safeUpdate(() async {
      final sheet = state.firstWhere((s) => s.id == sheetId);
      await col.doc(sheetId).update({
        'sheetAvatar': sheet.sheetAvatar.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> addUserToSheet(String sheetId, String userId) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId)
            s.copyWith(users: {...s.users, userId}.toList())
          else
            s,
      ],
    );

    await _safeUpdate(() async {
      await col.doc(sheetId).update({
        'users': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> updateSheetShareInfo({
    required String sheetId,
    String? sharedBy,
    String? message,
  }) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId)
            s.copyWith(sharedBy: sharedBy, message: message)
          else
            s,
      ],
    );

    await _safeUpdate(() async {
      final updateMap = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (sharedBy != null) updateMap['sharedBy'] = sharedBy;
      if (message != null) updateMap['message'] = message;

      await col.doc(sheetId).update(updateMap);
    });
  }

  Future<void> updateSheetTheme({
    required String sheetId,
    required Color primary,
    required Color secondary,
  }) async {
    _updateLocalState(
      (list) => [
        for (final s in list)
          if (s.id == sheetId)
            s.copyWith(
              theme: SheetTheme(primary: primary, secondary: secondary),
            )
          else
            s,
      ],
    );

    await _safeUpdate(() async {
      final sheet = state.firstWhere((s) => s.id == sheetId);
      await col.doc(sheetId).update({
        'theme': sheet.theme?.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}

/// Default Getting Started Sheet ID
const String kGettingStartedSheetId = 'sheet-1';

/// Filters by membership
@riverpod
List<SheetModel> sheetsList(Ref ref) {
  return ref.watch(sheetListProvider);
}

/// Search provider
@riverpod
List<SheetModel> sheetListSearch(Ref ref) {
  final sheets = ref.watch(sheetsListProvider);
  final query = ref.watch(searchValueProvider);

  if (query.isEmpty) return sheets;
  return sheets
      .where((s) => s.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

/// Get Single Sheet
@riverpod
SheetModel? sheet(Ref ref, String sheetId) {
  return ref.watch(sheetListProvider).where((s) => s.id == sheetId).firstOrNull;
}

/// Get Users of Sheet
@riverpod
List<String> listOfUsersBySheetId(Ref ref, String sheetId) {
  return ref.watch(sheetListProvider).firstWhere((s) => s.id == sheetId).users;
}

/// Provider to check if a sheet exists
@riverpod
bool sheetExists(Ref ref, String sheetId) {
  final sheet = ref.watch(sheetProvider(sheetId));
  return sheet != null;
}

/// Provider for sheets sorted by title (filtered by membership)
@riverpod
List<SheetModel> sortedSheets(Ref ref) {
  final sheets = ref.watch(sheetsListProvider);
  return [...sheets]..sort((a, b) => a.title.compareTo(b.title));
}
