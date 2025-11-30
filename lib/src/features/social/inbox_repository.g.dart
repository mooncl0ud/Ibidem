// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inboxRepositoryHash() => r'2c4e05d210cfc8991933353360edcbcaa3ff3e3b';

/// See also [inboxRepository].
@ProviderFor(inboxRepository)
final inboxRepositoryProvider = Provider<InboxRepository>.internal(
  inboxRepository,
  name: r'inboxRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inboxRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InboxRepositoryRef = ProviderRef<InboxRepository>;
String _$unreadInboxCountHash() => r'a7087e126875ab8b40ec225500906dab861fbab1';

/// See also [unreadInboxCount].
@ProviderFor(unreadInboxCount)
final unreadInboxCountProvider = AutoDisposeStreamProvider<int>.internal(
  unreadInboxCount,
  name: r'unreadInboxCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadInboxCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnreadInboxCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
