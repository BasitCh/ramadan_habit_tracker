import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  const Habit({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
