// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socialRepositoryHash() => r'0c50b41f2d72dd311ac83f808ff616779e5f5aec';

/// See also [socialRepository].
@ProviderFor(socialRepository)
final socialRepositoryProvider = Provider<SocialRepository>.internal(
  socialRepository,
  name: r'socialRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socialRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SocialRepositoryRef = ProviderRef<SocialRepository>;
String _$pendingRequestsHash() => r'fcddc4d6a66946ff6884dc2a4aa3710f442cf72c';

/// See also [pendingRequests].
@ProviderFor(pendingRequests)
final pendingRequestsProvider =
    AutoDisposeStreamProvider<List<Map<String, dynamic>>>.internal(
  pendingRequests,
  name: r'pendingRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingRequestsRef
    = AutoDisposeStreamProviderRef<List<Map<String, dynamic>>>;
String _$friendsListHash() => r'26aa66ee34707967bb8aeff109a9b91bfb039af4';

/// See also [friendsList].
@ProviderFor(friendsList)
final friendsListProvider =
    AutoDisposeStreamProvider<List<Map<String, dynamic>>>.internal(
  friendsList,
  name: r'friendsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FriendsListRef
    = AutoDisposeStreamProviderRef<List<Map<String, dynamic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
