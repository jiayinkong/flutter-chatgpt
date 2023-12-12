
import 'package:floor/floor.dart';

@entity
class Session {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;

  Session({
    this.id,
    required this.title,
  });

  Session copyWith({int? id, String? title}) {
    return Session(
      title: title ?? this.title,
      id: id ?? this.id,
    );
  }
}