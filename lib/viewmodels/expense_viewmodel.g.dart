// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseListViewModel)
final expenseListViewModelProvider = ExpenseListViewModelProvider._();

final class ExpenseListViewModelProvider
    extends $AsyncNotifierProvider<ExpenseListViewModel, List<Expense>> {
  ExpenseListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListViewModelHash();

  @$internal
  @override
  ExpenseListViewModel create() => ExpenseListViewModel();
}

String _$expenseListViewModelHash() =>
    r'7ce2804167f1938800db5ecc488cab57e42d2c23';

abstract class _$ExpenseListViewModel extends $AsyncNotifier<List<Expense>> {
  FutureOr<List<Expense>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
