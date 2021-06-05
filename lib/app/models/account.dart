import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String ownerPublicKey;

  @HiveField(3)
  final String activePublicKey;

  @HiveField(4)
  final String postingPublicKey;

  @HiveField(5)
  final String memoPublicKey;

  Account({
    required this.id,
    required this.name,
    required this.ownerPublicKey,
    required this.activePublicKey,
    required this.postingPublicKey,
    required this.memoPublicKey,
  });
}
