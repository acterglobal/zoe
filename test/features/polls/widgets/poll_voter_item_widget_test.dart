import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/widgets/poll_voter_item_widget.dart';
import 'package:zoe/features/users/data/user_list.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('PollVoterItemWidget Tests', () {
    late ProviderContainer container;
    late UserModel testUser;
    late Vote testVote;

    setUp(() {
      testUser = userList.first;
      testVote = Vote(
        userId: testUser.id,
        createdAt: DateTime(2024, 1, 15, 14, 30),
      );

      container = ProviderContainer.test(
        overrides: [
          getUserByIdProvider(testUser.id).overrideWith((ref) => testUser),
          userDisplayNameProvider(
            testUser.id,
          ).overrideWith((ref) => testUser.name),
        ],
      );
    });

    Future<void> createWidgetUnderTest({
      required WidgetTester tester,
      required Vote vote,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: PollVoterItemWidget(vote: vote),
        container: container,
      );
    }

    group('Widget Rendering', () {
      testWidgets('renders correctly with valid vote data', (tester) async {
        await createWidgetUnderTest(tester: tester, vote: testVote);

        // Should find GlassyContainer
        expect(find.byType(GlassyContainer), findsOneWidget);

        // Should find Row layout
        expect(find.byType(Row), findsOneWidget);

        // Should find user avatar widget
        expect(find.byType(ZoeUserAvatarWidget), findsOneWidget);

        // Should find user name text
        expect(find.text(testUser.name), findsOneWidget);

        // Should find formatted date time text
        expect(
          find.text(
            DateTimeUtils.formatDateTime(testVote.createdAt ?? DateTime.now()),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders with correct layout structure', (tester) async {
        await createWidgetUnderTest(tester: tester, vote: testVote);

        // Should find SizedBox for spacing
        expect(
          find.byType(SizedBox),
          findsNWidgets(2),
        ); // One for width, one for height

        // Should find Expanded widget for user info
        expect(find.byType(Expanded), findsOneWidget);

        // Should find Column for user info layout
        expect(find.byType(Column), findsOneWidget);

        // Should find two Text widgets (name and date)
        expect(find.byType(Text), findsNWidgets(2));
      });

      testWidgets('applies correct styling', (tester) async {
        await createWidgetUnderTest(tester: tester, vote: testVote);

        final glassyContainer = tester.widget<GlassyContainer>(
          find.byType(GlassyContainer),
        );
        expect(glassyContainer.margin, const EdgeInsets.only(bottom: 8));
        expect(glassyContainer.padding, const EdgeInsets.all(12));
        expect(glassyContainer.borderRadius, BorderRadius.circular(12));
        expect(glassyContainer.borderOpacity, 0.08);

        final nameText = tester.widget<Text>(find.text(testUser.name));
        expect(nameText.style?.fontWeight, FontWeight.w600);
      });
    });

    group('User Provider Integration', () {
      testWidgets('displays user name from userDisplayNameProvider', (
        tester,
      ) async {
        final customUser = userList[1]; // Jane Smith
        final customVote = Vote(userId: customUser.id);

        container = ProviderContainer.test(
          overrides: [
            getUserByIdProvider(
              customUser.id,
            ).overrideWith((ref) => customUser),
            userDisplayNameProvider(
              customUser.id,
            ).overrideWith((ref) => customUser.name),
          ],
        );

        await createWidgetUnderTest(tester: tester, vote: customVote);

        expect(find.text('Jane Smith'), findsOneWidget);
      });

      testWidgets('handles different user data', (tester) async {
        final userWithBio = userList.first; // John Doe (has bio and avatar)
        final voteWithBio = Vote(userId: userWithBio.id);

        container = ProviderContainer.test(
          overrides: [
            getUserByIdProvider(
              userWithBio.id,
            ).overrideWith((ref) => userWithBio),
            userDisplayNameProvider(
              userWithBio.id,
            ).overrideWith((ref) => userWithBio.name),
          ],
        );

        await createWidgetUnderTest(tester: tester, vote: voteWithBio);

        expect(find.text('John Doe'), findsOneWidget);
      });
    });

    group('DateTime Handling', () {
      testWidgets('displays formatted date time correctly', (tester) async {
        final specificDateTime = DateTime(2024, 12, 25, 9, 15);
        final voteWithSpecificTime = Vote(
          userId: testUser.id,
          createdAt: specificDateTime,
        );

        await createWidgetUnderTest(tester: tester, vote: voteWithSpecificTime);

        expect(
          find.text(DateTimeUtils.formatDateTime(specificDateTime)),
          findsOneWidget,
        );
      });

      testWidgets('handles different time formats', (tester) async {
        final morningTime = DateTime(2024, 6, 10, 8, 45);
        final eveningTime = DateTime(2024, 6, 10, 20, 30);
        final midnightTime = DateTime(2024, 6, 10, 0, 0);

        final morningVote = Vote(userId: testUser.id, createdAt: morningTime);
        final eveningVote = Vote(userId: testUser.id, createdAt: eveningTime);
        final midnightVote = Vote(userId: testUser.id, createdAt: midnightTime);

        // Test morning time
        await createWidgetUnderTest(tester: tester, vote: morningVote);
        expect(
          find.text(DateTimeUtils.formatDateTime(morningTime)),
          findsOneWidget,
        );

        await tester.pumpWidget(Container()); // Clear previous widget

        // Test evening time
        await createWidgetUnderTest(tester: tester, vote: eveningVote);
        expect(
          find.text(DateTimeUtils.formatDateTime(eveningTime)),
          findsOneWidget,
        );

        await tester.pumpWidget(Container()); // Clear previous widget

        // Test midnight time
        await createWidgetUnderTest(tester: tester, vote: midnightVote);
        expect(
          find.text(DateTimeUtils.formatDateTime(midnightTime)),
          findsOneWidget,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('returns SizedBox.shrink when user is null', (tester) async {
        final voteWithNonExistentUser = Vote(userId: 'non-existent-user-id');

        container = ProviderContainer.test(
          overrides: [
            getUserByIdProvider(
              'non-existent-user-id',
            ).overrideWith((ref) => null),
            userDisplayNameProvider(
              'non-existent-user-id',
            ).overrideWith((ref) => 'Unknown User'),
          ],
        );

        await createWidgetUnderTest(
          tester: tester,
          vote: voteWithNonExistentUser,
        );

        // Should find SizedBox.shrink (which renders nothing)
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(GlassyContainer), findsNothing);
        expect(find.byType(Row), findsNothing);
      });

      testWidgets('handles special characters in user name', (tester) async {
        final specialName =
            r'User@#$%^&*()_+{}|:"<>?[]\;\'
            ',./';
        final userWithSpecialName = UserModel(
          id: 'special-name-user-id',
          email: 'test@gmail.com',
          name: specialName,
        );
        final voteWithSpecialName = Vote(userId: userWithSpecialName.id);

        container = ProviderContainer.test(
          overrides: [
            getUserByIdProvider(
              userWithSpecialName.id,
            ).overrideWith((ref) => userWithSpecialName),
            userDisplayNameProvider(
              userWithSpecialName.id,
            ).overrideWith((ref) => specialName),
          ],
        );

        await createWidgetUnderTest(tester: tester, vote: voteWithSpecialName);

        expect(find.text(specialName), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('applies theme colors correctly', (tester) async {
        await createWidgetUnderTest(tester: tester, vote: testVote);

        final dateText = tester.widget<Text>(find.byType(Text).last);
        expect(dateText.style?.color, isA<Color>());
      });
    });

    group('Widget Properties', () {
      testWidgets('has correct key when provided', (tester) async {
        const testKey = Key('test-voter-item-key');

        await tester.pumpMaterialWidgetWithProviderScope(
          child: PollVoterItemWidget(key: testKey, vote: testVote),
          container: container,
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('handles multiple instances', (tester) async {
        final vote1 = Vote(
          userId: 'user_1',
          createdAt: DateTime(2024, 1, 1, 10, 0),
        );
        final vote2 = Vote(
          userId: 'user_2',
          createdAt: DateTime(2024, 1, 2, 11, 0),
        );
        final user1 = userList.first; // John Doe
        final user2 = userList[1]; // Jane Smith

        container = ProviderContainer.test(
          overrides: [
            getUserByIdProvider('user_1').overrideWith((ref) => user1),
            getUserByIdProvider('user_2').overrideWith((ref) => user2),
            userDisplayNameProvider('user_1').overrideWith((ref) => 'John Doe'),
            userDisplayNameProvider(
              'user_2',
            ).overrideWith((ref) => 'Jane Smith'),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: Column(
            children: [
              PollVoterItemWidget(vote: vote1),
              PollVoterItemWidget(vote: vote2),
            ],
          ),
          container: container,
        );

        expect(find.byType(PollVoterItemWidget), findsNWidgets(2));
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Jane Smith'), findsOneWidget);
      });
    });
  });
}
