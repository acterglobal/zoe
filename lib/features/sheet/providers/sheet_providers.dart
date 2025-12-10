import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'sheet_providers.g.dart';

@Riverpod(keepAlive: true)
class SheetList extends _$SheetList {
  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection('sheets');

  StreamSubscription? _subscription;

  @override
  List<SheetModel> build() {
    final userId = ref.watch(loggedInUserProvider).value;

    _subscription?.cancel();
    _subscription = null;

    Query<Map<String, dynamic>> query = collection;

    if (userId != null) {
      query = query.where(
        Filter.or(
          Filter('users', arrayContains: userId),
          Filter('users', isEqualTo: []),
          Filter('users', isNull: true),
        ),
      );
    } else {
      query = query.where(
        Filter.or(
          Filter('users', isEqualTo: []),
          Filter('users', isNull: true),
        ),
      );
    }

    _subscription = query.snapshots().listen((snapshot) {
      final items = snapshot.docs
          .map((doc) {
            return SheetModel.fromJson(doc.data());
          })
          .whereType<SheetModel>()
          .toList();

      state = items;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  // ─────────────────────────────────────
  // CRUD Operations
  // ─────────────────────────────────────

  Future<void> addSheet(SheetModel sheet) async {
    final userId = ref.read(loggedInUserProvider).value;
    var newSheet = sheet;

    newSheet = newSheet.copyWith(
      users: [if (userId != null) userId],
      createdBy: userId,
    );
    await collection.doc(newSheet.id).set(newSheet.toJson());
  }

  Future<void> deleteSheet(String sheetId) async {
    await collection.doc(sheetId).delete();
  }

  Future<void> updateSheetTitle(String sheetId, String title) async {
    await collection.doc(sheetId).update({
      'title': title,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSheetCoverImage(String sheetId, String? url) async {
    await collection.doc(sheetId).update({
      if (url == null) 'coverImageUrl': null else 'coverImageUrl': url,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSheetDescription(String sheetId, Description desc) async {
    await collection.doc(sheetId).update({
      'description': {'plainText': desc.plainText, 'htmlText': desc.htmlText},
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSheetAvatar({
    required String sheetId,
    required AvatarType type,
    required String data,
    Color? color,
  }) async {
    final sheet = state.firstWhere((s) => s.id == sheetId);
    final updatedAvatar = sheet.sheetAvatar.copyWith(
      type: type,
      data: data,
      color: color,
    );

    await collection.doc(sheetId).update({
      'sheetAvatar': updatedAvatar.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUserToSheet(String sheetId, String userId) async {
    await collection.doc(sheetId).update({
      'users': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSheetShareInfo({
    required String sheetId,
    String? sharedBy,
    String? message,
  }) async {
    final updateMap = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (sharedBy != null) updateMap['sharedBy'] = sharedBy;
    if (message != null) updateMap['message'] = message;

    await collection.doc(sheetId).update(updateMap);
  }

  Future<void> updateSheetTheme({
    required String sheetId,
    required Color primary,
    required Color secondary,
  }) async {
    final sheet = state.firstWhere((s) => s.id == sheetId);
    final newTheme =
        sheet.theme?.copyWith(primary: primary, secondary: secondary) ??
        SheetTheme(primary: primary, secondary: secondary);

    await collection.doc(sheetId).update({
      'theme': newTheme.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

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
  return ref
          .watch(sheetListProvider)
          .where((s) => s.id == sheetId)
          .firstOrNull
          ?.users ??
      [];
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
