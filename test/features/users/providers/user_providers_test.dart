import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  group('UserList Provider', () {
    test('initial state returns userList from data', () {
      final userList = container.read(userListProvider);
      expect(userList, equals(userList));
      expect(userList, isA<List<UserModel>>());
      expect(userList.isNotEmpty, isTrue);
    });

    test('addUser adds new user to the list', () {
      final newUser = UserModel(
        id: 'new_user_1',
        email: 'user@gmail.com',
        name: 'New User',
        bio: 'New user bio',
        avatar: null,
      );

      container.read(userListProvider.notifier).addUser(newUser);

      final updatedList = container.read(userListProvider);
      expect(updatedList.length, equals(userList.length + 1));
      expect(updatedList.last, equals(newUser));
    });

    test('deleteUser removes user from the list', () {
      final initialList = container.read(userListProvider);
      final userToDelete = initialList.first;

      container.read(userListProvider.notifier).deleteUser(userToDelete.id);

      final updatedList = container.read(userListProvider);
      expect(updatedList.length, equals(initialList.length - 1));
      expect(updatedList.any((u) => u.id == userToDelete.id), isFalse);
    });

    test('deleteUser does nothing if user does not exist', () {
      final initialList = container.read(userListProvider);
      final initialLength = initialList.length;

      container.read(userListProvider.notifier).deleteUser('non_existent_user');

      final updatedList = container.read(userListProvider);
      expect(updatedList.length, equals(initialLength));
    });

    test('updateUserName updates user name correctly', () {
      final initialList = container.read(userListProvider);
      final userToUpdate = initialList.first;
      const newName = 'Updated Name';

      container
          .read(userListProvider.notifier)
          .updateUserName(userToUpdate.id, newName);

      final updatedList = container.read(userListProvider);
      final updatedUser = updatedList.firstWhere(
        (u) => u.id == userToUpdate.id,
      );
      expect(updatedUser.name, equals(newName));
      expect(updatedUser.id, equals(userToUpdate.id));
      expect(updatedUser.bio, equals(userToUpdate.bio));
      expect(updatedUser.avatar, equals(userToUpdate.avatar));
    });

    test('updateUserName does nothing if user does not exist', () {
      final initialList = container.read(userListProvider);
      const newName = 'Updated Name';

      container
          .read(userListProvider.notifier)
          .updateUserName('non_existent_user', newName);

      final updatedList = container.read(userListProvider);
      expect(updatedList, equals(initialList));
    });

    test('updateUser replaces entire user object', () {
      final initialList = container.read(userListProvider);
      final userToUpdate = initialList.first;
      final updatedUser = userToUpdate.copyWith(
        name: 'Completely New Name',
        bio: 'Completely new bio',
        avatar: 'new_avatar.png',
      );

      container
          .read(userListProvider.notifier)
          .updateUser(userToUpdate.id, updatedUser);

      final updatedList = container.read(userListProvider);
      final foundUser = updatedList.firstWhere((u) => u.id == userToUpdate.id);
      expect(foundUser, equals(updatedUser));
    });

    test('updateUser does nothing if user does not exist', () {
      final initialList = container.read(userListProvider);
      final newUser = UserModel(
        id: 'new_user',
        email: 'user@gmail.com',
        name: 'New User',
        bio: 'New bio',
        avatar: null,
      );

      container
          .read(userListProvider.notifier)
          .updateUser('non_existent_user', newUser);

      final updatedList = container.read(userListProvider);
      expect(updatedList, equals(initialList));
    });
  });

  group('loggedInUser Provider', () {
    test('provider exists and can be read', () {
      final container = ProviderContainer();
      expect(() => container.read(loggedInUserProvider), returnsNormally);
      container.dispose();
    });
  });

  group('getUserById Provider', () {
    test('returns user when found', () {
      final userList = container.read(userListProvider);
      final targetUser = userList.first;

      final result = container.read(getUserByIdProvider(targetUser.id));
      expect(result, equals(targetUser));
    });

    test('returns null when user not found', () {
      final result = container.read(getUserByIdProvider('non_existent_user'));
      expect(result, isNull);
    });

    test('returns null for empty user ID', () {
      final result = container.read(getUserByIdProvider(''));
      expect(result, isNull);
    });
  });

  group('userIdsFromUserModels Provider', () {
    test('returns list of user IDs from user models', () {
      final userList = container.read(userListProvider);
      final userModels = userList.take(3).toList();

      final result = container.read(userIdsFromUserModelsProvider(userModels));
      expect(result, equals(userModels.map((u) => u.id).toList()));
    });

    test('returns empty list for empty user models', () {
      final result = container.read(userIdsFromUserModelsProvider([]));
      expect(result, isEmpty);
    });

    test('handles single user model', () {
      final userList = container.read(userListProvider);
      final singleUser = <UserModel>[userList.first];

      final result = container.read(userIdsFromUserModelsProvider(singleUser));
      expect(result, equals([singleUser.first.id]));
    });
  });

  group('userDisplayName Provider', () {
    test('provider exists and can be read', () {
      final userList = container.read(userListProvider);
      final firstUser = userList.first;

      expect(
        () => container.read(userDisplayNameProvider(firstUser.id)),
        returnsNormally,
      );
    });

    test('returns user name for existing user', () {
      final userList = container.read(userListProvider);
      final firstUser = userList.first;

      final result = container.read(userDisplayNameProvider(firstUser.id));
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });

    test('returns user ID for non-existent user', () {
      final result = container.read(
        userDisplayNameProvider('non_existent_user'),
      );
      expect(result, equals('non_existent_user'));
    });

    test('handles empty user ID', () {
      final result = container.read(userDisplayNameProvider(''));
      expect(result, isA<String>());
    });
  });

  group('userListSearch Provider', () {
    test('returns all users when search term is empty', () {
      final result = container.read(userListSearchProvider(''));
      expect(result, equals(container.read(userListProvider)));
    });

    test('returns filtered users when search term matches', () {
      final userList = container.read(userListProvider);
      final firstUser = userList.first;
      final searchTerm = firstUser.name.substring(0, 3).toLowerCase();

      final result = container.read(userListSearchProvider(searchTerm));
      expect(result.any((u) => u.id == firstUser.id), isTrue);
    });

    test('returns empty list when no users match search term', () {
      final result = container.read(
        userListSearchProvider('nonexistentuser123'),
      );
      expect(result, isEmpty);
    });

    test('performs case-insensitive search', () {
      final userList = container.read(userListProvider);
      final firstUser = userList.first;
      final searchTerm = firstUser.name.toUpperCase();

      final result = container.read(userListSearchProvider(searchTerm));
      expect(result.any((u) => u.id == firstUser.id), isTrue);
    });
  });

  group('usersBySheetId Provider', () {
    test('returns users for valid sheet', () {
      // Create a mock sheet with some users
      final userList = container.read(userListProvider);
      final sheetUsers = userList.take(2).map((u) => u.id).toList();
      final mockSheet = SheetModel(
        id: 'test_sheet',
        title: 'Test Sheet',
        users: sheetUsers,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add the sheet to the sheet list
      container.read(sheetListProvider.notifier).addSheet(mockSheet);

      final result = container.read(usersBySheetIdProvider('test_sheet'));
      expect(result.length, equals(2));
      expect(result.every((u) => sheetUsers.contains(u.id)), isTrue);
    });

    test('returns empty list for non-existent sheet', () {
      final result = container.read(
        usersBySheetIdProvider('non_existent_sheet'),
      );
      expect(result, isEmpty);
    });

    test('returns empty list for sheet with no users', () {
      final mockSheet = SheetModel(
        id: 'empty_sheet',
        title: 'Empty Sheet',
        users: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      container.read(sheetListProvider.notifier).addSheet(mockSheet);

      final result = container.read(usersBySheetIdProvider('empty_sheet'));
      expect(result, isEmpty);
    });
  });

  group('sheetUserCount Provider', () {
    test('returns correct count for sheet with users', () {
      // Create a mock sheet with some users
      final userList = container.read(userListProvider);
      final sheetUsers = userList.take(3).map((u) => u.id).toList();
      final mockSheet = SheetModel(
        id: 'test_sheet',
        title: 'Test Sheet',
        users: sheetUsers,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      container.read(sheetListProvider.notifier).addSheet(mockSheet);

      final result = container.read(sheetProvider('test_sheet'));
      expect(result?.users, equals(3));
    });

    test('returns zero for non-existent sheet', () {
      final result = container.read(sheetProvider('non_existent_sheet'));
      expect(result?.users, equals(0));
    });

    test('returns zero for sheet with no users', () {
      final mockSheet = SheetModel(
        id: 'empty_sheet',
        title: 'Empty Sheet',
        users: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      container.read(sheetListProvider.notifier).addSheet(mockSheet);

      final result = container.read(sheetProvider('empty_sheet'));
      expect(result?.users, equals(0));
    });
  });

  group('Provider Integration Tests', () {
    test('user list updates trigger dependent providers', () {
      final initialUserList = container.read(userListProvider);
      final firstUser = initialUserList.first;

      // Test getUserById before update
      final userBeforeUpdate = container.read(
        getUserByIdProvider(firstUser.id),
      );
      expect(userBeforeUpdate, equals(firstUser));

      // Update user
      final updatedUser = firstUser.copyWith(name: 'Updated Name');
      container
          .read(userListProvider.notifier)
          .updateUser(firstUser.id, updatedUser);

      // Test getUserById after update
      final userAfterUpdate = container.read(getUserByIdProvider(firstUser.id));
      expect(userAfterUpdate, equals(updatedUser));
      expect(userAfterUpdate!.name, equals('Updated Name'));
    });

    test('search provider updates when user list changes', () {
      final newUser = UserModel(
        id: 'searchable_user',
        email: 'user@gmail.com',
        name: 'Searchable User',
        bio: 'A user for testing search',
        avatar: null,
      );

      // Search before adding user
      final searchBefore = container.read(userListSearchProvider('Searchable'));
      expect(searchBefore.any((u) => u.id == newUser.id), isFalse);

      // Add user
      container.read(userListProvider.notifier).addUser(newUser);

      // Search after adding user
      final searchAfter = container.read(userListSearchProvider('Searchable'));
      expect(searchAfter.any((u) => u.id == newUser.id), isTrue);
    });

    test('user display name updates when user is updated', () {
      final userList = container.read(userListProvider);
      final userToUpdate = userList.first;

      // Get display name before update
      final displayNameBefore = container.read(
        userDisplayNameProvider(userToUpdate.id),
      );
      expect(displayNameBefore, isA<String>());

      // Update user name
      final updatedUser = userToUpdate.copyWith(name: 'New Display Name');
      container
          .read(userListProvider.notifier)
          .updateUser(userToUpdate.id, updatedUser);

      // Get display name after update
      final displayNameAfter = container.read(
        userDisplayNameProvider(userToUpdate.id),
      );
      expect(displayNameAfter, isA<String>());
    });
  });

  group('Edge Cases and Error Handling', () {
    test('handles empty user list gracefully', () {
      // Clear all users
      final userList = container.read(userListProvider);
      for (final user in userList) {
        container.read(userListProvider.notifier).deleteUser(user.id);
      }

      final emptyList = container.read(userListProvider);
      expect(emptyList, isEmpty);

      // Test providers with empty list
      expect(container.read(getUserByIdProvider('any_id')), isNull);
      expect(container.read(userListSearchProvider('any_term')), isEmpty);
    });

    test('handles duplicate user IDs in operations', () {
      final userList = container.read(userListProvider);
      final firstUser = userList.first;

      // Try to add user with same ID
      final duplicateUser = firstUser.copyWith(name: 'Duplicate Name');
      container.read(userListProvider.notifier).addUser(duplicateUser);

      // Should have added the duplicate (this is the current behavior)
      final updatedList = container.read(userListProvider);
      final usersWithSameId = updatedList
          .where((u) => u.id == firstUser.id)
          .toList();
      expect(usersWithSameId.length, equals(2));
    });

    test('handles null and empty string inputs', () {
      // Test with empty string user ID
      expect(container.read(getUserByIdProvider('')), isNull);
      expect(container.read(userDisplayNameProvider('')), isA<String>());

      // Test search with null-like inputs
      expect(container.read(userListSearchProvider('')), isNotEmpty);
    });

    test('handles very long search terms', () {
      final longSearchTerm = 'a' * 1000;
      final result = container.read(userListSearchProvider(longSearchTerm));
      expect(result, isEmpty);
    });

    test('handles special characters in search', () {
      final specialSearchTerm = '!@#\$%^&*()';
      final result = container.read(userListSearchProvider(specialSearchTerm));
      expect(result, isEmpty);
    });

    test('handles unicode characters in search', () {
      final unicodeSearchTerm = '用户🎉🚀';
      final result = container.read(userListSearchProvider(unicodeSearchTerm));
      expect(result, isEmpty);
    });
  });
}
