// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main event list provider with all event management functionality

@ProviderFor(EventList)
const eventListProvider = EventListProvider._();

/// Main event list provider with all event management functionality
final class EventListProvider
    extends $NotifierProvider<EventList, List<EventModel>> {
  /// Main event list provider with all event management functionality
  const EventListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventListHash();

  @$internal
  @override
  EventList create() => EventList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$eventListHash() => r'14ff54faef859680bbf7d871910512f603e376dd';

/// Main event list provider with all event management functionality

abstract class _$EventList extends $Notifier<List<EventModel>> {
  List<EventModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<EventModel>, List<EventModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<EventModel>, List<EventModel>>,
              List<EventModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for events filtered by membership (current user must be a member of the sheet)

@ProviderFor(eventsList)
const eventsListProvider = EventsListProvider._();

/// Provider for events filtered by membership (current user must be a member of the sheet)

final class EventsListProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for events filtered by membership (current user must be a member of the sheet)
  const EventsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsListHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return eventsList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$eventsListHash() => r'792e9ff68aac24ba14a1f59453c8faf31e64b831';

/// Provider for today's events (filtered by membership)

@ProviderFor(todaysEvents)
const todaysEventsProvider = TodaysEventsProvider._();

/// Provider for today's events (filtered by membership)

final class TodaysEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for today's events (filtered by membership)
  const TodaysEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return todaysEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$todaysEventsHash() => r'c46bc7e837196a451fb55ea36cc39bc7ea17c310';

/// Provider for upcoming events (filtered by membership)

@ProviderFor(upcomingEvents)
const upcomingEventsProvider = UpcomingEventsProvider._();

/// Provider for upcoming events (filtered by membership)

final class UpcomingEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for upcoming events (filtered by membership)
  const UpcomingEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return upcomingEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$upcomingEventsHash() => r'bd47be818827b51c43dca1ab817ec376d1135114';

/// Provider for past events (filtered by membership)

@ProviderFor(pastEvents)
const pastEventsProvider = PastEventsProvider._();

/// Provider for past events (filtered by membership)

final class PastEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for past events (filtered by membership)
  const PastEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pastEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pastEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return pastEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$pastEventsHash() => r'6be588c85739df644e97902af639d30f048c513e';

/// Provider for all events combined

@ProviderFor(allEvents)
const allEventsProvider = AllEventsProvider._();

/// Provider for all events combined

final class AllEventsProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for all events combined
  const AllEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allEventsHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return allEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$allEventsHash() => r'2b0a1ea1863ae318fcb764822ca21af5ba5c35ef';

/// Provider for searching events

@ProviderFor(eventListSearch)
const eventListSearchProvider = EventListSearchProvider._();

/// Provider for searching events

final class EventListSearchProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for searching events
  const EventListSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventListSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventListSearchHash();

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    return eventListSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$eventListSearchHash() => r'1f768930426078e291ce2f73c90e85e4c3ac6bc2';

/// Provider for a single event by ID

@ProviderFor(event)
const eventProvider = EventFamily._();

/// Provider for a single event by ID

final class EventProvider
    extends $FunctionalProvider<EventModel?, EventModel?, EventModel?>
    with $Provider<EventModel?> {
  /// Provider for a single event by ID
  const EventProvider._({
    required EventFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventHash();

  @override
  String toString() {
    return r'eventProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<EventModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventModel? create(Ref ref) {
    final argument = this.argument as String;
    return event(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventModel?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventHash() => r'6a5e6236dca50f8f19c68a1e49b10b9332381458';

/// Provider for a single event by ID

final class EventFamily extends $Family
    with $FunctionalFamilyOverride<EventModel?, String> {
  const EventFamily._()
    : super(
        retry: null,
        name: r'eventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for a single event by ID

  EventProvider call(String eventId) =>
      EventProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventProvider';
}

/// Provider for events filtered by parent ID

@ProviderFor(eventByParent)
const eventByParentProvider = EventByParentFamily._();

/// Provider for events filtered by parent ID

final class EventByParentProvider
    extends
        $FunctionalProvider<
          List<EventModel>,
          List<EventModel>,
          List<EventModel>
        >
    with $Provider<List<EventModel>> {
  /// Provider for events filtered by parent ID
  const EventByParentProvider._({
    required EventByParentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventByParentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventByParentHash();

  @override
  String toString() {
    return r'eventByParentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<EventModel>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<EventModel> create(Ref ref) {
    final argument = this.argument as String;
    return eventByParent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventByParentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventByParentHash() => r'4581a4ba9d58da784cd9f4cfbea30c867205dbcb';

/// Provider for events filtered by parent ID

final class EventByParentFamily extends $Family
    with $FunctionalFamilyOverride<List<EventModel>, String> {
  const EventByParentFamily._()
    : super(
        retry: null,
        name: r'eventByParentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for events filtered by parent ID

  EventByParentProvider call(String parentId) =>
      EventByParentProvider._(argument: parentId, from: this);

  @override
  String toString() => r'eventByParentProvider';
}

/// Provider for current user's RSVP status

@ProviderFor(currentUserRsvp)
const currentUserRsvpProvider = CurrentUserRsvpFamily._();

/// Provider for current user's RSVP status

final class CurrentUserRsvpProvider
    extends
        $FunctionalProvider<
          AsyncValue<RsvpStatus?>,
          RsvpStatus?,
          FutureOr<RsvpStatus?>
        >
    with $FutureModifier<RsvpStatus?>, $FutureProvider<RsvpStatus?> {
  /// Provider for current user's RSVP status
  const CurrentUserRsvpProvider._({
    required CurrentUserRsvpFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currentUserRsvpProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentUserRsvpHash();

  @override
  String toString() {
    return r'currentUserRsvpProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RsvpStatus?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RsvpStatus?> create(Ref ref) {
    final argument = this.argument as String;
    return currentUserRsvp(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentUserRsvpProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentUserRsvpHash() => r'3a14e5459c2e93c11f8b9701c128cda399e4a840';

/// Provider for current user's RSVP status

final class CurrentUserRsvpFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RsvpStatus?>, String> {
  const CurrentUserRsvpFamily._()
    : super(
        retry: null,
        name: r'currentUserRsvpProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for current user's RSVP status

  CurrentUserRsvpProvider call(String eventId) =>
      CurrentUserRsvpProvider._(argument: eventId, from: this);

  @override
  String toString() => r'currentUserRsvpProvider';
}

/// Provider for RSVP yes count of a specific event

@ProviderFor(eventRsvpYesCount)
const eventRsvpYesCountProvider = EventRsvpYesCountFamily._();

/// Provider for RSVP yes count of a specific event

final class EventRsvpYesCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for RSVP yes count of a specific event
  const EventRsvpYesCountProvider._({
    required EventRsvpYesCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventRsvpYesCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventRsvpYesCountHash();

  @override
  String toString() {
    return r'eventRsvpYesCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return eventRsvpYesCount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventRsvpYesCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventRsvpYesCountHash() => r'ecd65995788188a9e42a692c132704b01028d571';

/// Provider for RSVP yes count of a specific event

final class EventRsvpYesCountFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  const EventRsvpYesCountFamily._()
    : super(
        retry: null,
        name: r'eventRsvpYesCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for RSVP yes count of a specific event

  EventRsvpYesCountProvider call(String eventId) =>
      EventRsvpYesCountProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventRsvpYesCountProvider';
}

/// Provider for total RSVP count of a specific event

@ProviderFor(eventTotalRsvpCount)
const eventTotalRsvpCountProvider = EventTotalRsvpCountFamily._();

/// Provider for total RSVP count of a specific event

final class EventTotalRsvpCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Provider for total RSVP count of a specific event
  const EventTotalRsvpCountProvider._({
    required EventTotalRsvpCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventTotalRsvpCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventTotalRsvpCountHash();

  @override
  String toString() {
    return r'eventTotalRsvpCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return eventTotalRsvpCount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventTotalRsvpCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventTotalRsvpCountHash() =>
    r'ea08b1b4cc38e32324a01d1390d8a2390f86588f';

/// Provider for total RSVP count of a specific event

final class EventTotalRsvpCountFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  const EventTotalRsvpCountFamily._()
    : super(
        retry: null,
        name: r'eventTotalRsvpCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for total RSVP count of a specific event

  EventTotalRsvpCountProvider call(String eventId) =>
      EventTotalRsvpCountProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventTotalRsvpCountProvider';
}

/// Provider for getting users whose RSVP to a specific event is "yes"

@ProviderFor(eventRsvpYesUsers)
const eventRsvpYesUsersProvider = EventRsvpYesUsersFamily._();

/// Provider for getting users whose RSVP to a specific event is "yes"

final class EventRsvpYesUsersProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// Provider for getting users whose RSVP to a specific event is "yes"
  const EventRsvpYesUsersProvider._({
    required EventRsvpYesUsersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventRsvpYesUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventRsvpYesUsersHash();

  @override
  String toString() {
    return r'eventRsvpYesUsersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    final argument = this.argument as String;
    return eventRsvpYesUsers(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventRsvpYesUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventRsvpYesUsersHash() => r'ea8c57b778f47d0d2739c54be7f07665ee6da12a';

/// Provider for getting users whose RSVP to a specific event is "yes"

final class EventRsvpYesUsersFamily extends $Family
    with $FunctionalFamilyOverride<List<String>, String> {
  const EventRsvpYesUsersFamily._()
    : super(
        retry: null,
        name: r'eventRsvpYesUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for getting users whose RSVP to a specific event is "yes"

  EventRsvpYesUsersProvider call(String eventId) =>
      EventRsvpYesUsersProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventRsvpYesUsersProvider';
}
