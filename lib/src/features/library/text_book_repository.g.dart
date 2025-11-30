// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_book_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$textBookRepositoryHash() =>
    r'5799eee27c6cd6952a384e0a580d0b3f80411ac3';

/// See also [textBookRepository].
@ProviderFor(textBookRepository)
final textBookRepositoryProvider =
    AutoDisposeProvider<TextBookRepository>.internal(
  textBookRepository,
  name: r'textBookRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$textBookRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TextBookRepositoryRef = AutoDisposeProviderRef<TextBookRepository>;
String _$textBooksHash() => r'2e4736baaf1848d7a9ed65f0747550f49345ac49';

/// See also [textBooks].
@ProviderFor(textBooks)
final textBooksProvider = AutoDisposeStreamProvider<List<TextBook>>.internal(
  textBooks,
  name: r'textBooksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$textBooksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TextBooksRef = AutoDisposeStreamProviderRef<List<TextBook>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
