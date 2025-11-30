import 'package:isar/isar.dart';

part 'user_schema.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  String? email;
  String? nickname;
}
