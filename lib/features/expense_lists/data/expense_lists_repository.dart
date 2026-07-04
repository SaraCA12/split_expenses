import '../../../shared/data/mock_database.dart';
import '../../../shared/models/expense_list.dart';
import '../../../shared/models/participant.dart';
import '../../../core/utils/id_generator.dart';

class ExpenseListsRepository {
  final _db = MockDatabase.instance;

  Future<List<ExpenseList>> getMyLists(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_db.lists);
  }

  Future<ExpenseList> createList({
    required String name,
    required String description,
    required ExpenseListType type,
    required SplitType splitType,
    required List<String> participantNames,
    required String creatorUserId,
    required String creatorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (name.trim().isEmpty) {
      throw Exception('El nombre de la lista es obligatorio');
    }

    // El creador siempre es el primer participante, con su ID de usuario real.
    final participantes = <Participant>[
      Participant(id: creatorUserId, name: creatorName.trim()),
      ...participantNames
          .where((n) => n.trim().isNotEmpty)
          .map((n) => Participant(id: IdGenerator.generate(), name: n.trim())),
    ];

    final newList = ExpenseList(
      id: IdGenerator.generate(),
      name: name.trim(),
      description: description.trim(),
      type: type,
      splitType: splitType,
      participants: participantes,
      createdAt: DateTime.now(),
    );

    _db.lists.add(newList);
    return newList;
  }

  Future<int> getListCount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _db.lists.length;
  }

  Future<Map<ExpenseListType, int>> getCategoryDistribution(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final Map<ExpenseListType, int> distribution = {};
    for (final list in _db.lists) {
      distribution[list.type] = (distribution[list.type] ?? 0) + 1;
    }
    return distribution;
  }
}