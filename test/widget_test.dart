import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'mocks/mocks.mocks.dart';

void main() {
  late MockLocalAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockLocalAuthRepository();
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login succeeds',
      build: () {
        when(mockRepository.loginUser('test@mail.com', '1234'))
            .thenAnswer((_) async => true);
        return AuthCubit(mockRepository);
      },
      act: (cubit) => cubit.login('test@mail.com', '1234'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.email, 'email', 'test@mail.com'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(mockRepository.loginUser('fail@mail.com', 'wrong'))
            .thenAnswer((_) async => false);
        return AuthCubit(mockRepository);
      },
      act: (cubit) => cubit.login('fail@mail.com', 'wrong'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having((s) => s.message, 'message', 'Невірний логін або пароль'),
      ],
    );
  });
}
