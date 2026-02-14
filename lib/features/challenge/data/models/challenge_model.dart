import 'package:equatable/equatable.dart';

class ChallengeModel extends Equatable {
  final int day;
  final String title;
  final String description;
  final bool isCompleted;

  const ChallengeModel({
    required this.day,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  ChallengeModel copyWith({
    int? day,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return ChallengeModel(
      day: day ?? this.day,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [day, title, description, isCompleted];
}
