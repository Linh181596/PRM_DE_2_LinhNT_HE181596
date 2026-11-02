import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'currency_viewmodel.g.dart';

@riverpod
class CurrencyViewModel extends _$CurrencyViewModel {
  static const String _currencyKey = 'currency_unit';

  static const double usdExchangeRate = 25000.0;

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'VND';
  }

  Future<void> setCurrency(String newCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, newCurrency);
    state = AsyncValue.data(newCurrency);
  }

  double vndToUsd(double vndAmount) {
    return vndAmount / usdExchangeRate;
  }

  double usdToVnd(double usdAmount) {
    return usdAmount * usdExchangeRate;
  }

  double convertFromVnd(double vndAmount, String targetCurrency) {
    if (targetCurrency == 'USD') {
      return vndToUsd(vndAmount);
    }
    return vndAmount;
  }

  double convertToVnd(double inputAmount, String currentCurrency) {
    if (currentCurrency == 'USD') {
      return usdToVnd(inputAmount);
    }
    return inputAmount;
  }
}
