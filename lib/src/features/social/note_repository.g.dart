// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteRepositoryHash() => r'4dab4e1ef1a9b4d50a209e3bd25574f6a9585b2b';

/// See also [noteRepository].
@ProviderFor(noteRepository)
final noteRepositoryProvider = Provider<NoteRepository>.internal(
  noteRepository,
  name: r'noteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteRepositoryRef = ProviderRef<NoteRepository>;
String _$notesForBookHash() => r'b62062cc9681008e9fd726fdad18769dc91eda02';

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

/// See also [notesForBook].
@ProviderFor(notesForBook)
const notesForBookProvider = NotesForBookFamily();

/// See also [notesForBook].
class NotesForBookFamily extends Family<AsyncValue<List<StickyNote>>> {
  /// See also [notesForBook].
  const NotesForBookFamily();

  /// See also [notesForBook].
  NotesForBookProvider call(
    String bookId,
  ) {
    return NotesForBookProvider(
      bookId,
    );
  }

  @override
  NotesForBookProvider getProviderOverride(
    covariant NotesForBookProvider provider,
  ) {
    return call(
      provider.bookId,
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
  String? get name => r'notesForBookProvider';
}

/// See also [notesForBook].
class NotesForBookProvider extends AutoDisposeStreamProvider<List<StickyNote>> {
  /// See also [notesForBook].
  NotesForBookProvider(
    String bookId,
  ) : this._internal(
          (ref) => notesForBook(
            ref as NotesForBookRef,
            bookId,
          ),
          from: notesForBookProvider,
          name: r'notesForBookProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesForBookHash,
          dependencies: NotesForBookFamily._dependencies,
          allTransitiveDependencies:
              NotesForBookFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  NotesForBookProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  Override overrideWith(
    Stream<List<StickyNote>> Function(NotesForBookRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotesForBookProvider._internal(
        (ref) => create(ref as NotesForBookRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<StickyNote>> createElement() {
    return _NotesForBookProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesForBookProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotesForBookRef on AutoDisposeStreamProviderRef<List<StickyNote>> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _NotesForBookProviderElement
    extends AutoDisposeStreamProviderElement<List<StickyNote>>
    with NotesForBookRef {
  _NotesForBookProviderElement(super.provider);

  @override
  String get bookId => (origin as NotesForBookProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
