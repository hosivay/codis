import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Codis/features/cipher/data/cipher_repository.dart';
import 'package:Codis/features/cipher/data/cipher_repository_impl.dart';
import 'package:Codis/features/cipher/presentation/cipher_viewmodel.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final localeProvider = StateProvider<Locale>((ref) => const Locale('fa', 'IR'));

final cipherRepositoryProvider = Provider<CipherRepository>((ref) {
  return CipherRepositoryImpl();
});

final cipherViewModelProvider =
    ChangeNotifierProvider<CipherViewModel>((ref) {
  final repository = ref.watch(cipherRepositoryProvider);
  return CipherViewModel(repository: repository);
});
