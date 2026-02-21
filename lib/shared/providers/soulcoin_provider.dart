import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulchat/core/services/firestore_service.dart';

const String _kSoulCoinBalance = 'soulcoin_balance';
const int _defaultBalance = 50;
const int _welcomeBonus = 50;

final soulCoinProvider = StateNotifierProvider<SoulCoinNotifier, int>((ref) {
  return SoulCoinNotifier();
});

class SoulCoinNotifier extends StateNotifier<int> {
  SoulCoinNotifier() : super(_defaultBalance) {
    _load();
  }

  static SharedPreferences? _prefs;

  Future<void> _load() async {
    _prefs ??= await SharedPreferences.getInstance();
    final saved = _prefs!.getInt(_kSoulCoinBalance);
    final remote = await FirestoreService.getWalletBalance();
    if (remote > 0) {
      state = remote;
    } else if (saved != null && saved > 0) {
      state = saved;
    } else {
      state = _welcomeBonus;
      await _save();
    }
  }

  /// Production: Firestore bakiyesini tekrar çeker (hediye sonrası vb.).
  Future<void> syncFromFirestore() async {
    await _load();
  }

  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(_kSoulCoinBalance, state);
    await FirestoreService.setWalletBalance(state);
  }

  Future<void> add(int amount) async {
    if (amount <= 0) return;
    state = state + amount;
    await _save();
    await FirestoreService.addTransaction(amount: amount, type: 'reward', description: 'SoulCoin alındı');
  }

  Future<bool> spend(int amount) async {
    if (amount <= 0 || state < amount) return false;
    state = state - amount;
    await _save();
    await FirestoreService.addTransaction(amount: amount, type: 'spend', description: 'SoulCoin harcandı');
    return true;
  }

  bool canSpend(int amount) => state >= amount && amount > 0;
}
