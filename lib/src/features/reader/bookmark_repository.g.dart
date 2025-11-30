// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookmarkRepositoryHash() =>
    r'3cc9a9ddcff73decacef1d0e250f3f3508724167';

/// See also [bookmarkRepository].
@ProviderFor(bookmarkRepository)
final bookmarkRepositoryProvider = Provider<BookmarkRepository>.internal(
  bookmarkRepository,
  name: r'bookmarkRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookmarkRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookmarkRepositoryRef = ProviderRef<BookmarkRepository>;
String _$bookmarksStreamHash() => r'07dd002babcf13a1106c44fecf6fe39cf7a4e963';

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

/// See also [bookmarksStream].
@ProviderFor(bookmarksStream)
const bookmarksStreamProvider = BookmarksStreamFamily();

/// See also [bookmarksStream].
class BookmarksStreamFamily extends Family<AsyncValue<List<Bookmark>>> {
  /// See also [bookmarksStream].
  const BookmarksStreamFamily();

  /// See also [bookmarksStream].
  BookmarksStreamProvider call(
    int bookId,
  ) {
    return BookmarksStreamProvider(
      bookId,
    );
  }

  @override
  BookmarksStreamProvider getProviderOverride(
    covariant BookmarksStreamProvider provider,
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
  String? get name => r'bookmarksStreamProvider';
}

/// See also [bookmarksStream].
class BookmarksStreamProvider
    extends AutoDisposeStreamProvider<List<Bookmark>> {
  /// See also [bookmarksStream].
  BookmarksStreamProvider(
    int bookId,
  ) : this._internal(
          (ref) => bookmarksStream(
            ref as BookmarksStreamRef,
            bookId,
          ),
          from: bookmarksStreamProvider,
          name: r'bookmarksStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookmarksStreamHash,
          dependencies: BookmarksStreamFamily._dependencies,
          allTransitiveDependencies:
              BookmarksStreamFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  BookmarksStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final int bookId;

  @override
  Override overrideWith(
    Stream<List<Bookmark>> Function(BookmarksStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookmarksStreamProvider._internal(
        (ref) => create(ref as BookmarksStreamRef),
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
  AutoDisposeStreamProviderElement<List<Bookmark>> createElement() {
    return _BookmarksStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookmarksStreamProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookmarksStreamRef on AutoDisposeStreamProviderRef<List<Bookmark>> {
  /// The parameter `bookId` of this provider.
  int get bookId;
}

class _BookmarksStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Bookmark>>
    with BookmarksStreamRef {
  _BookmarksStreamProviderElement(super.provider);

  @override
  int get bookId => (origin as BookmarksStreamProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
