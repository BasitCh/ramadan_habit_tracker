import 'package:equatable/equatable.dart';

class IbadahChecklist extends Equatable {
  final String dateKey;
  final Map<String, bool> items;

  const IbadahChecklist({
    required this.dateKey,
    required this.items,
  });

  @override
  List<Object> get props => [dateKey, items];
}
