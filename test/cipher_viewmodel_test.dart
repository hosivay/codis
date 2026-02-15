import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Codis/core/l10n/app_strings.dart';
import 'package:Codis/core/providers/app_providers.dart';
import 'package:Codis/features/cipher/data/cipher_repository.dart';
void main() {
  late ProviderContainer container;
  late FakeCipherRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeCipherRepository();
    container = ProviderContainer(
      overrides: [
        cipherRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('encrypt with empty input sets error', () {
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('fa', 'IR');

    viewModel.encrypt('', 'secret', locale);

    expect(viewModel.encryptError, AppStrings.errorEmptyInput(locale));
    expect(viewModel.encryptResult, isNull);
    expect(viewModel.encryptLoading, false);
  });

  test('encrypt with empty secret sets error', () {
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('fa', 'IR');

    viewModel.encrypt('text', '', locale);

    expect(viewModel.encryptError, AppStrings.errorEmptySecret(locale));
    expect(viewModel.encryptResult, isNull);
  });

  testWidgets('encrypt success sets result', (WidgetTester tester) async {
    fakeRepository.encryptResult = 'cipher-out';
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('en');

    viewModel.encrypt('plain', 'key', locale);

    expect(viewModel.encryptLoading, true);
    await tester.pump();
    await tester.pump();

    expect(viewModel.encryptLoading, false);
    expect(viewModel.encryptResult, 'cipher-out');
    expect(viewModel.encryptError, isNull);
  });

  test('decrypt with empty input sets error', () {
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('fa', 'IR');

    viewModel.decrypt('', 'secret', locale);

    expect(viewModel.decryptError, AppStrings.errorEmptyInput(locale));
    expect(viewModel.decryptResult, isNull);
  });

  test('decrypt with empty secret sets error', () {
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('en');

    viewModel.decrypt('cipher', '', locale);

    expect(viewModel.decryptError, AppStrings.errorEmptySecret(locale));
    expect(viewModel.decryptResult, isNull);
  });

  testWidgets('decrypt success sets result', (WidgetTester tester) async {
    fakeRepository.decryptResult = 'decrypted-text';
    final viewModel = container.read(cipherViewModelProvider.notifier);
    const locale = Locale('en');

    viewModel.decrypt('valid-cipher', 'key', locale);

    expect(viewModel.decryptLoading, true);
    await tester.pump();
    await tester.pump();

    expect(viewModel.decryptLoading, false);
    expect(viewModel.decryptResult, 'decrypted-text');
    expect(viewModel.decryptError, isNull);
  });
}

class FakeCipherRepository implements CipherRepository {
  String? encryptResult;
  String? decryptResult;
  Object? encryptError;
  Object? decryptError;

  @override
  String encrypt(String plainText, String secret) {
    if (encryptError != null) throw encryptError!;
    return encryptResult ?? '';
  }

  @override
  String decrypt(String cipherBase64, String secret) {
    if (decryptError != null) throw decryptError!;
    return decryptResult ?? '';
  }

  @override
  Future<String> encryptAsync(String plainText, String secret) async {
    await Future<void>.delayed(Duration.zero);
    if (encryptError != null) throw encryptError!;
    return encryptResult ?? '';
  }

  @override
  Future<String> decryptAsync(String cipherText, String secret) async {
    await Future<void>.delayed(Duration.zero);
    if (decryptError != null) throw decryptError!;
    return decryptResult ?? '';
  }
}
