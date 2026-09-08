import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/auth/data/repositories_impl/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl authRepository;

  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.id);
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    authRepository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('AuthRepositoryImpl login error mapping tests', () {
    test('maps user-not-found to standardized anti-enumeration message', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'password'))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final result = await authRepository.signIn('12345', 'password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('NIP/NIS atau password salah')),
        (_) => fail('Should return Left'),
      );
    });

    test('maps wrong-password to standardized anti-enumeration message', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'wrongpass'))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await authRepository.signIn('12345', 'wrongpass');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('NIP/NIS atau password salah')),
        (_) => fail('Should return Left'),
      );
    });

    test('maps invalid-credential to standardized anti-enumeration message', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'wrongpass'))
          .thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      final result = await authRepository.signIn('12345', 'wrongpass');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('NIP/NIS atau password salah')),
        (_) => fail('Should return Left'),
      );
    });

    test('maps network-request-failed correctly', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'password'))
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

      final result = await authRepository.signIn('12345', 'password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('Tidak ada koneksi internet.')),
        (_) => fail('Should return Left'),
      );
    });

    test('maps too-many-requests correctly', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'password'))
          .thenThrow(FirebaseAuthException(code: 'too-many-requests'));

      final result = await authRepository.signIn('12345', 'password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('Terlalu banyak percobaan. Harap tunggu sesaat.')),
        (_) => fail('Should return Left'),
      );
    });

    test('maps generic Exception correctly', () async {
      when(() => mockRemoteDataSource.signIn('12345', 'password'))
          .thenThrow(Exception('Server error'));

      final result = await authRepository.signIn('12345', 'password');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, contains('Server error')),
        (_) => fail('Should return Left'),
      );
    });

    test('supports English localization via slang', () async {
      await LocaleSettings.setLocale(AppLocale.en);
      when(() => mockRemoteDataSource.signIn('12345', 'wrongpass'))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await authRepository.signIn('12345', 'wrongpass');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, equals('Invalid NIP/NIS or password')),
        (_) => fail('Should return Left'),
      );
      await LocaleSettings.setLocale(AppLocale.id);
    });
  });
}
