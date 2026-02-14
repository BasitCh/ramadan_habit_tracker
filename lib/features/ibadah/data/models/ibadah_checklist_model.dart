import 'package:hive/hive.dart';
import 'package:ramadan_habit_tracker/features/ibadah/domain/entities/ibadah_checklist.dart';

part 'ibadah_checklist_model.g.dart';

@HiveType(typeId: 16)
class IbadahChecklistModel extends HiveObject {
  @HiveField(0)
  final String dateKey;

  @HiveField(1)
  final List<String> items;

  @HiveField(2)
  final List<bool> values;

  IbadahChecklistModel({
    required this.dateKey,
    required this.items,
    required this.values,
  });

  IbadahChecklist toEntity() => IbadahChecklist(
        dateKey: dateKey,
        items: Map<String, bool>.fromIterables(items, values),
      );

  factory IbadahChecklistModel.fromEntity(IbadahChecklist entity) {
    return IbadahChecklistModel(
      dateKey: entity.dateKey,
      items: entity.items.keys.toList(),
      values: entity.items.values.toList(),
    );
  }
}
