// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$highlightRepositoryHash() =>
    r'11c49191ba0cced68a2763d53996771e30c7e574';

/// See also [highlightRepository].
@ProviderFor(highlightRepository)
final highlightRepositoryProvider = Provider<HighlightRepository>.internal(
  highlightRepository,
  name: r'highlightRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$highlightRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HighlightRepositoryRef = ProviderRef<HighlightRepository>;
String _$highlightsStreamHash() => r'477a58d5fc89aee52ab58c60204a972a5e891f35';

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

/// See also [highlightsStream].
@ProviderFor(highlightsStream)
const highlightsStreamProvider = HighlightsStreamFamily();

/// See also [highlightsStream].
class HighlightsStreamFamily extends Family<AsyncValue<List<Highlight>>> {
  /// See also [highlightsStream].
  const HighlightsStreamFamily();

  /// See also [highlightsStream].
  HighlightsStreamProvider call(
    int bookId,
  ) {
    return HighlightsStreamProvider(
      bookId,
    );
  }

  @override
  HighlightsStreamProvider getProviderOverride(
    covariant HighlightsStreamProvider provider,
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
  String? get name => r'highlightsStreamProvider';
}

/// See also [highlightsStream].
class HighlightsStreamProvider
    extends AutoDisposeStreamProvider<List<Highlight>> {
  /// See also [highlightsStream].
  HighlightsStreamProvider(
    int bookId,
  ) : this._internal(
          (ref) => highlightsStream(
            ref as HighlightsStreamRef,
            bookId,
          ),
          from: highlightsStreamProvider,
          name: r'highlightsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$highlightsStreamHash,
          dependencies: HighlightsStreamFamily._dependencies,
          allTransitiveDependencies:
              HighlightsStreamFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  HighlightsStreamProvider._internal(
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
    Stream<List<Highlight>> Function(HighlightsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HighlightsStreamProvider._internal(
        (ref) => create(ref as HighlightsStreamRef),
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
  AutoDisposeStreamProviderElement<List<Highlight>> createElement() {
    return _HighlightsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HighlightsStreamProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HighlightsStreamRef on AutoDisposeStreamProviderRef<List<Highlight>> {
  /// The parameter `bookId` of this provider.
  int get bookId;
}

class _HighlightsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Highlight>>
    with HighlightsStreamRef {
  _HighlightsStreamProviderElement(super.provider);

  @override
  int get bookId => (origin as HighlightsStreamProvider).bookId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
