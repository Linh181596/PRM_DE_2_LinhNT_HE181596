import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/expense_repository.dart';
import '../models/expense.dart';

part 'expense_viewmodel.g.dart';

@riverpod
class ExpenseListViewModel extends _$ExpenseListViewModel {
  @override
  Future<List<Expense>> build() async {
    return await ExpenseRepository.instance.getExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await ExpenseRepository.instance.updateExpense(expense);
    final updatedList = await ExpenseRepository.instance.getExpenses();
    state = AsyncValue.data(updatedList);
  }
}
