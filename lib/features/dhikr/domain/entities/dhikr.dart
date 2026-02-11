import 'package:equatable/equatable.dart';

class Dhikr extends Equatable {
  final String id;
  final String name;
  final int targetCount;
  final int currentCount;

  const Dhikr({
    required this.id,
    required this.name,
    required this.targetCount,
    required this.currentCount,
  });

  Dhikr copyWith({int? currentCount}) {
    return Dhikr(
      id: id,
      name: name,
      targetCount: targetCount,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  bool get isCompleted => currentCount >= targetCount;
  double get progress => targetCount == 0 ? 0 : currentCount / targetCount;

  @override
  List<Object> get props => [id, name, targetCount, currentCount];
}
