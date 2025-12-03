// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticky_note_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stickyNoteRepositoryHash() =>
    r'c5d92a50a1081e04782347b500966484e6dde300';

/// See also [stickyNoteRepository].
@ProviderFor(stickyNoteRepository)
final stickyNoteRepositoryProvider = Provider<StickyNoteRepository>.internal(
  stickyNoteRepository,
  name: r'stickyNoteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stickyNoteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StickyNoteRepositoryRef = ProviderRef<StickyNoteRepository>;
String _$stickyNotesStreamHash() => r'b12cecd871250b05e1ba9f2e2356512ff45e0502';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [stickyNotesStream].
@ProviderFor(stickyNotesStream)
const stickyNotesStreamProvider = StickyNotesStreamFamily();

/// See also [stickyNotesStream].
class StickyNotesStreamFamily extends Family<AsyncValue<List<StickyNote>>> {
  /// See also [stickyNotesStream].
  const StickyNotesStreamFamily();

  /// See also [stickyNotesStream].
  StickyNotesStreamProvider call({
    required String ownerId,
    required String bookId,
  }) {
    return StickyNotesStreamProvider(
      ownerId: ownerId,
      bookId: bookId,
    );
  }

  @override
  StickyNotesStreamProvider getProviderOverride(
    covariant StickyNotesStreamProvider provider,
  ) {
    return call(
      ownerId: provider.ownerId,
      bookId: provider.bookId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stickyNotesStreamProvider';
}

/// See also [stickyNotesStream].
class StickyNotesStreamProvider
    extends AutoDisposeStreamProvider<List<StickyNote>> {
  /// See also [stickyNotesStream].
  StickyNotesStreamProvider({
    required String ownerId,
    required String bookId,
  }) : this._internal(
          (ref) => stickyNotesStream(
            ref as StickyNotesStreamRef,
            ownerId: ownerId,
            bookId: bookId,
          ),
          from: stickyNotesStreamProvider,
          name: r'stickyNotesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stickyNotesStreamHash,
          dependencies: StickyNotesStreamFamily._dependencies,
          allTransitiveDependencies:
              StickyNotesStreamFamily._allTransitiveDependencies,
          ownerId: ownerId,
          bookId: bookId,
        );

  StickyNotesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ownerId,
    required this.bookId,
  }) : super.internal();

  final String ownerId;
  final String bookId;

  @override
  Override overrideWith(
    Stream<List<StickyNote>> Function(StickyNotesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StickyNotesStreamProvider._internal(
        (ref) => create(ref as StickyNotesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ownerId: ownerId,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<StickyNote>> createElement() {
    return _StickyNotesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StickyNotesStreamProvider &&
        other.ownerId == ownerId &&
        other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ownerId.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StickyNotesStreamRef on AutoDisposeStreamProviderRef<List<StickyNote>> {
  /// The parameter `ownerId` of this provider.
  String get ownerId;

  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _StickyNotesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<StickyNote>>
    with StickyNotesStreamRef {
  _StickyNotesStreamProviderElement(super.provider);

  @override
  String get ownerId => (origin as StickyNotesStreamProvider).ownerId;
  @override
  String get bookId => (origin as StickyNotesStreamProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
