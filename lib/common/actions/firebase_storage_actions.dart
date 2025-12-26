import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/firebase_utils.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';

// Helper function to upload a file to Firebase Storage
Future<String?> uploadFileToStorage({
  required Ref ref,
  required String bucketName,
  String? subFolderName,
  required XFile file,
}) async {
  final snackbar = ref.read(snackbarServiceProvider);
  final firebaseStorage = ref.read(firebaseStorageProvider);

  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${timestamp}_${basename(file.path)}';

    // Create a reference to the file
    final storageRef = firebaseStorage.ref().child(
      '$bucketName/${subFolderName != null ? '$subFolderName/' : ''}$fileName',
    );

    // Wait for the upload to complete
    final TaskSnapshot snapshot = await storageRef.putFile(File(file.path));

    // Get the download URL
    return await snapshot.ref.getDownloadURL();
  } on FirebaseException catch (e) {
    snackbar.show(getFirebaseErrorMessage(e));
    return null;
  }
}

// Helper function to delete a file from Firebase Storage
Future<void> deleteFileFromStorage({
  required Ref ref,
  required String fileUrl,
}) async {
  final snackbar = ref.read(snackbarServiceProvider);
  final firebaseStorage = ref.read(firebaseStorageProvider);

  try {
    // Create a reference to the file using its download URL
    final storageRef = firebaseStorage.refFromURL(fileUrl);
    // Delete the file
    await storageRef.delete();
  } on FirebaseException catch (e) {
    snackbar.show(getFirebaseErrorMessage(e));
  }
}

// Helper function to delete sheet avatar and cover image from storage
Future<void> deleteSheetAvatarAndCoverImageFromStorage(
  Ref ref,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList,
) async {
  final sheetList = docsList
      .map((doc) => SheetModel.fromJson(doc.data()))
      .toList();
  List<SheetModel> sheetListWithAvatar = [];
  List<SheetModel> sheetListWithBanner = [];
  for (final sheet in sheetList) {
    if (sheet.sheetAvatar.isNetworkImage()) {
      sheetListWithAvatar.add(sheet);
    }
    if (sheet.coverImageUrl != null && sheet.coverImageUrl!.isNotEmpty) {
      sheetListWithBanner.add(sheet);
    }
  }
  await Future.wait([
    ...sheetListWithAvatar.map(
      (doc) => deleteFileFromStorage(ref: ref, fileUrl: doc.sheetAvatar.data),
    ),
    ...sheetListWithBanner.map(
      (doc) => deleteFileFromStorage(ref: ref, fileUrl: doc.coverImageUrl!),
    ),
  ]);
}

// Helper function to delete documents from storage
Future<void> deleteDocumentsFromStorage(
  Ref ref,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList,
) async {
  await Future.wait(
    docsList
        .map((doc) => DocumentModel.fromJson(doc.data()))
        .toList()
        .map((doc) => deleteFileFromStorage(ref: ref, fileUrl: doc.filePath))
        .toList(),
  );
}
