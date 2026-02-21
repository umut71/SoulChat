import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/core/services/firestore_service.dart';

/// VIP ve ilk alım durumu – her ekranda ref.watch(vipProvider) ile kullanılır.
final vipProvider = StateNotifierProvider<VipNotifier, VipState>((ref) {
  return VipNotifier();
});

class VipState {
  final bool isVip;
  final bool hasPurchasedBefore;
  final bool loading;

  const VipState({
    this.isVip = false,
    this.hasPurchasedBefore = false,
    this.loading = true,
  });

  VipState copyWith({bool? isVip, bool? hasPurchasedBefore, bool? loading}) =>
      VipState(
        isVip: isVip ?? this.isVip,
        hasPurchasedBefore: hasPurchasedBefore ?? this.hasPurchasedBefore,
        loading: loading ?? this.loading,
      );
}

class VipNotifier extends StateNotifier<VipState> {
  VipNotifier() : super(const VipState()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final status = await FirestoreService.getUserPurchaseStatus();
      state = VipState(
        isVip: status.isVip,
        hasPurchasedBefore: status.hasPurchasedBefore,
        loading: false,
      );
    } catch (_) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> refresh() => _load();

  /// Ödeme onaylandıktan sonra çağrılır.
  Future<void> activatePlan({
    required String planId,
    required int bonusCoins,
    Duration? duration,
  }) async {
    await FirestoreService.activateVip(
      planId: planId,
      bonusCoins: bonusCoins,
      duration: duration,
    );
    state = state.copyWith(isVip: true, hasPurchasedBefore: true, loading: false);
  }
}
