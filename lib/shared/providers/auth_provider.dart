import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulchat/core/services/firebase_auth_service.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) => FirebaseAuthService());

/// Auth Fortress: Stream önce currentUser ile başlar (initialData), sonra authStateChanges.
/// Giriş yapan kullanıcı Login ekranını bir daha görmez.
final authStateProvider = StreamProvider<User?>((ref) async* {
  yield FirebaseAuth.instance.currentUser;
  yield* ref.watch(firebaseAuthServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull ?? FirebaseAuth.instance.currentUser;
});
