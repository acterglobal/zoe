import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'sheet_providers.g.dart';

@Riverpod(keepAlive: true)
class SheetList extends _$SheetList {
  CollectionReference<Map<String, dynamic>> get collection =>
      ref.read(firestoreProvider).collection(FirestoreCollections.sheets);

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
          Filter(FirestoreFieldConstants.users, arrayContains: userId),
          Filter(FirestoreFieldConstants.users, isEqualTo: []),
          Filter(FirestoreFieldConstants.users, isNull: true),
        ),
      );
    } else {
      query = query.where(
        Filter.or(
          Filter(FirestoreFieldConstants.users, isEqualTo: []),
          Filter(FirestoreFieldConstants.users, isNull: true),
        ),
      );
    }

    _subscription = query.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => SheetModel.fromJson(doc.data()))
            .toList();
      },
      onError: (error, stackTrace) => runFirestoreOperation(
        ref,
        () => Error.throwWithStackTrace(error, stackTrace),
      ),
    );

    ref.onDispose(() => _subscription?.cancel());
    return [];
  }

  // ─────────────────────────────────────
  // CRUD Operations
  // ─────────────────────────────────────

  Future<void> addSheet(SheetModel sheet) async {
    final userId = ref.read(loggedInUserProvider).value;
    if (userId == null) return;
    await runFirestoreOperation(ref, () async {
      var newSheet = sheet;
      newSheet = newSheet.copyWith(users: [userId], createdBy: userId);
      await collection.doc(newSheet.id).set(newSheet.toJson());
    });
  }

  Future<void> deleteSheet(String sheetId) async {
    await runFirestoreOperation(ref, () => collection.doc(sheetId).delete());
  }

  Future<void> updateSheetTitle(String sheetId, String title) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(sheetId).update({
        FirestoreFieldConstants.title: title,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateSheetCoverImage(String sheetId, String? url) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(sheetId).update({
        if (url == null)
          FirestoreFieldConstants.coverImageUrl: null
        else
          FirestoreFieldConstants.coverImageUrl: url,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateSheetDescription(String sheetId, Description desc) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(sheetId).update({
        FirestoreFieldConstants.description: {
          FirestoreFieldConstants.plainText: desc.plainText,
          FirestoreFieldConstants.htmlText: desc.htmlText,
        },
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateSheetAvatar({
    required String sheetId,
    required AvatarType type,
    required String data,
    Color? color,
  }) async {
    await runFirestoreOperation(ref, () async {
      final updatedAvatar = SheetAvatar(type: type, data: data, color: color);
      await collection.doc(sheetId).update({
        FirestoreFieldConstants.sheetAvatar: updatedAvatar.toJson(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> addUserToSheet(String sheetId, String userId) async {
    await runFirestoreOperation(
      ref,
      () => collection.doc(sheetId).update({
        FirestoreFieldConstants.users: FieldValue.arrayUnion([userId]),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updateSheetShareInfo({
    required String sheetId,
    String? sharedBy,
    String? message,
  }) async {
    await runFirestoreOperation(ref, () async {
      final updateMap = <String, dynamic>{
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      };
      if (sharedBy != null) updateMap['sharedBy'] = sharedBy;
      if (message != null) updateMap['message'] = message;

      await collection.doc(sheetId).update(updateMap);
    });
  }

  Future<void> updateSheetTheme({
    required String sheetId,
    required Color primary,
    required Color secondary,
  }) async {
    await runFirestoreOperation(ref, () async {
      final newTheme = SheetTheme(primary: primary, secondary: secondary);
      await collection.doc(sheetId).update({
        FirestoreFieldConstants.theme: newTheme.toJson(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }
}

/// Search provider
@riverpod
List<SheetModel> sheetListSearch(Ref ref) {
  final sheets = ref.watch(sheetListProvider);
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
  final sheets = ref.watch(sheetListProvider);
  return [...sheets]..sort((a, b) => a.title.compareTo(b.title));
}
