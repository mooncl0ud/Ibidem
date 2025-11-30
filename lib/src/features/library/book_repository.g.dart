// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookRepositoryHash() => r'43f928f602464fbb04bdc99d4fec41784a4ac79b';

/// See also [bookRepository].
@ProviderFor(bookRepository)
final bookRepositoryProvider = Provider<BookRepository>.internal(
  bookRepository,
  name: r'bookRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookRepositoryRef = ProviderRef<BookRepository>;
String _$booksHash() => r'ab385d01346401d97210b586475bde32b4bbc8c5';

/// See also [books].
@ProviderFor(books)
final booksProvider = AutoDisposeStreamProvider<List<Book>>.internal(
  books,
  name: r'booksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$booksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BooksRef = AutoDisposeStreamProviderRef<List<Book>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
