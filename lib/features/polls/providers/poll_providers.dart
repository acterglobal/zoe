import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/utils/firestore_error_handler.dart';
import 'package:zoe/constants/firestore_collection_constants.dart';
import 'package:zoe/constants/firestore_field_constants.dart';
import 'package:zoe/features/polls/models/poll_model.dart';
import 'package:zoe/features/polls/utils/poll_utils.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

part 'poll_providers.g.dart';

@Riverpod(keepAlive: true)
class PollList extends _$PollList {
  FirebaseFirestore get _firestore => ref.read(firestoreProvider);
  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.polls);

  StreamSubscription? _subscription;

  @override
  List<PollModel> build() {
    _subscription?.cancel();
    _subscription = _collection.snapshots().listen(
      (snapshot) {
        state = snapshot.docs
            .map((doc) => PollModel.fromJson(doc.data()))
            .toList();
      },
      onError: (error, stackTrace) {
        log.severe('Error listening to poll snapshots', error, stackTrace);
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  Future<void> addPoll(PollModel newPoll) async {
    await runFirestoreOperation(
      ref,
      () => _collection.doc(newPoll.id).set(newPoll.toJson()),
    );
  }

  Future<void> deletePoll(String pollId) async {
    await runFirestoreOperation(ref, () => _collection.doc(pollId).delete());
  }

  Future<void> updatePollQuestion(String pollId, String question) async {
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.question: question,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updatePollOrderIndex(String pollId, int orderIndex) async {
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.orderIndex: orderIndex,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> addPollOption(String pollId, String optionText) async {
    final newOption = PollOption(
      id: CommonUtils.generateRandomId(),
      title: optionText,
    );
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.options: FieldValue.arrayUnion([
          newOption.toJson(),
        ]),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> updatePollOptionText(
    String pollId,
    String optionId,
    String newTitle,
  ) async {
    await runFirestoreOperation(ref, () async {
      final poll = state.firstWhere((p) => p.id == pollId);
      final updatedOptions = poll.options.map((option) {
        if (option.id == optionId) {
          return option.copyWith(title: newTitle);
        }
        return option;
      }).toList();

      await _collection.doc(pollId).update({
        FirestoreFieldConstants.options: updatedOptions
            .map((o) => o.toJson())
            .toList(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> deletePollOption(String pollId, String optionId) async {
    await runFirestoreOperation(ref, () async {
      final poll = state.firstWhere((p) => p.id == pollId);
      final updatedOptions = poll.options
          .where((option) => option.id != optionId)
          .toList();

      await _collection.doc(pollId).update({
        FirestoreFieldConstants.options: updatedOptions
            .map((o) => o.toJson())
            .toList(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> voteOnPoll(String pollId, String optionId, String userId) async {
    final originalState = state;
    final pollIndex = originalState.indexWhere((p) => p.id == pollId);
    if (pollIndex == -1) return;

    final pollToUpdate = originalState[pollIndex];
    final optimisticPoll = _updatePollVotes(pollToUpdate, optionId, userId);

    final newState = List<PollModel>.from(originalState);
    newState[pollIndex] = optimisticPoll;
    state = newState;

    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _collection.doc(pollId);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Poll document not found during transaction!");
        }

        final serverPoll = PollModel.fromJson(snapshot.data()!);
        final finalUpdatedPoll = _updatePollVotes(serverPoll, optionId, userId);

        transaction.update(docRef, {
          FirestoreFieldConstants.options: finalUpdatedPoll.options
              .map((o) => o.toJson())
              .toList(),
          FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
        });
      });
    } catch (e, stackTrace) {
      log.severe(
        'Error voting on poll. Reverting optimistic update.',
        e,
        stackTrace,
      );
      state = originalState;
      rethrow;
    }
  }

  PollModel _updatePollVotes(PollModel poll, String optionId, String userId) {
    final hasVotedOnOption = poll.options.any(
      (option) =>
          option.id == optionId &&
          option.votes.any((vote) => vote.userId == userId),
    );

    if (hasVotedOnOption) {
      return poll.copyWith(
        options: poll.options.map((option) {
          if (option.id == optionId) {
            return option.copyWith(
              votes: option.votes
                  .where((voter) => voter.userId != userId)
                  .toList(),
            );
          }
          return option;
        }).toList(),
      );
    } else {
      var options = poll.options;
      if (!poll.isMultipleChoice) {
        options = poll.options.map((option) {
          return option.copyWith(
            votes: option.votes.where((vote) => vote.userId != userId).toList(),
          );
        }).toList();
      }

      return poll.copyWith(
        options: options.map((option) {
          if (option.id == optionId) {
            return option.copyWith(
              votes: [
                ...option.votes,
                Vote(userId: userId, createdAt: DateTime.now()),
              ],
            );
          }
          return option;
        }).toList(),
      );
    }
  }

  Future<void> togglePollMultipleChoice(String pollId) async {
    final poll = state.firstWhere((p) => p.id == pollId);
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.isMultipleChoice: !poll.isMultipleChoice,
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> endPoll(String pollId) async {
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.endDate: FieldValue.serverTimestamp(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }

  Future<void> startPoll(String pollId) async {
    await runFirestoreOperation(
      ref,
      () => _collection.doc(pollId).update({
        FirestoreFieldConstants.startDate: FieldValue.serverTimestamp(),
        FirestoreFieldConstants.updatedAt: FieldValue.serverTimestamp(),
      }),
    );
  }
}

@riverpod
PollModel? poll(Ref ref, String pollId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.id == pollId).firstOrNull;
}

@riverpod
List<PollModel> notActivePollList(Ref ref) {
  final polls = ref.watch(pollListProvider);
  return polls.where((p) => PollUtils.isDraft(p)).toList();
}

@riverpod
List<PollModel> activePollList(Ref ref) {
  final polls = ref.watch(pollListProvider);
  return polls.where((p) => PollUtils.isActive(p)).toList();
}

@riverpod
List<PollModel> completedPollList(Ref ref) {
  final polls = ref.watch(pollListProvider);
  return polls.where((p) => PollUtils.isCompleted(p)).toList();
}

@riverpod
List<PollModel> pollListSearch(Ref ref) {
  final searchValue = ref.watch(searchValueProvider);
  final polls = ref.watch(pollListProvider);

  if (searchValue.isEmpty) return polls;
  return polls
      .where(
        (poll) =>
            poll.question.toLowerCase().contains(searchValue.toLowerCase()),
      )
      .toList();
}

@riverpod
List<PollModel> pollListByParent(Ref ref, String parentId) {
  final pollList = ref.watch(pollListProvider);
  return pollList.where((p) => p.parentId == parentId).toList();
}

@riverpod
List<UserModel> pollVotedMembers(Ref ref, String pollId) {
  final poll = ref.watch(pollProvider(pollId));
  if (poll == null) return [];

  final members = ref.watch(usersBySheetIdProvider(poll.sheetId));

  return members.where((member) {
    return poll.options.any(
      (option) => option.votes.any((vote) => vote.userId == member.id),
    );
  }).toList();
}

@riverpod
class ActivePollsWithPendingResponse extends _$ActivePollsWithPendingResponse {
  @override
  List<PollModel> build() {
    final activePollList = ref.watch(activePollListProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    if (currentUserAsync.value == null) return [];
    final currentUserId = currentUserAsync.value!.id;

    return activePollList.where((poll) {
      final hasVoted = poll.options.any(
        (option) => option.votes.any((vote) => vote.userId == currentUserId),
      );

      return !hasVoted;
    }).toList();
  }

  void update(List<PollModel> value) => state = value;
}
