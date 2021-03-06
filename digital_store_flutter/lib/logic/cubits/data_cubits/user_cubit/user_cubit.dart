import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/global_variables.dart';
import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/tokens.dart';
import '../../../../data/models/user.dart';
import '../../../global_logics/refresh_authorization_season.dart';
import '../../../global_logics/local_storing_logic.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
      {required this.authenticationRepository, required this.userRepository})
      : super(UserUnauthenticated());

  bool shouldBeRemembered = false;
  AuthenticationRepository authenticationRepository;
  UserRepository userRepository;

  void setRememberMeValue() {
    if (shouldBeRemembered == false) {
      shouldBeRemembered = true;
    } else {
      shouldBeRemembered = false;
    }
  }

  Future<List> userLogin(final String username, final String password) async {
    try {
      Map<String, dynamic> tokens = await authenticationRepository
          .postSignIn({'username': username, 'password': password});

      getTokens.get<Tokens>().accessToken = tokens['accessToken'];
      getTokens.get<Tokens>().refreshToken = tokens['refreshToken'];

      final user = await userRepository
          .getUserProfile(getTokens.get<Tokens>().accessToken);

      if (shouldBeRemembered) {
        storeCredentials(getTokens.get<Tokens>().refreshToken);
      }

      emit(UserConsumer(user: user));
      return [true, 'signed in'];
    } on InvalidTokenRecievedException catch (ex) {
      return [false, ex.reason];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  Future<void> resumeLoginSeason() async {
    String? refreshToken = await readSavedRefreshTokenFromHive();

    if (refreshToken != null) {
      try {
        Map<String, dynamic> tokens =
            await authenticationRepository.postRefresh(refreshToken);

        getTokens.get<Tokens>().accessToken = tokens['accessToken'];
        getTokens.get<Tokens>().refreshToken = tokens['refreshToken'];

        final user = await userRepository
            .getUserProfile(getTokens.get<Tokens>().accessToken);

        if (shouldBeRemembered) {
          storeCredentials(getTokens.get<Tokens>().refreshToken);
        }

        emit(UserConsumer(user: user));
      } on Exception {
        emit(UserUnauthenticated());
      }
    } else {
      emit(UserUnauthenticated());
    }
  }

  Future<List> userSignUp({
    required final String username,
    required final String password,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phoneNumber,
    required final String adress,
    required final String birthDate,
    required final String sex,
  }) async {
    try {
      await authenticationRepository.postsignUp({
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'adress': adress,
        'birthDate': birthDate,
        'sex': sex
      });

      return [true, 'signed up'];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  void updateBalance(final double deposit) async {
    double newBalance = deposit + (state as UserConsumer).user.balance;

    try {
      await userRepository.patchUserBalance(
          getTokens.get<Tokens>().accessToken, {'amount': newBalance});
      final user = await userRepository
          .getUserProfile(getTokens.get<Tokens>().accessToken);
      emit((state as UserConsumer).copyWith(user: user));
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        updateBalance(deposit);
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    }
  }

  void refreshUserProfile() async {
    try {
      final user = await userRepository
          .getUserProfile(getTokens.get<Tokens>().accessToken);
      emit((state as UserConsumer).copyWith(user: user));
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        refreshUserProfile();
      } on InvalidRefreshTokenException {
        sessionExpired();
      }
    }
  }

  Future<List> updateProfile({
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phoneNumber,
    required final String adress,
    required final String sex,
  }) async {
    try {
      await userRepository
          .patchUserProfile(getTokens.get<Tokens>().accessToken, {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'adress': adress,
        'sex': sex
      });

      final user = await userRepository
          .getUserProfile(getTokens.get<Tokens>().accessToken);

      emit((state as UserConsumer).copyWith(user: user));

      return [true, 'profile updated'];
    } on InvalidTokenException {
      try {
        refreshSeason(authenticationRepository);
        return updateProfile(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            adress: adress,
            sex: sex);
      } on InvalidRefreshTokenException {
        sessionExpired();
        return [false, ''];
      }
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  void logout() {
    getTokens.get<Tokens>().accessToken == '';
    getTokens.get<Tokens>().refreshToken == '';
    removeOldRefreshTokenFromHive();
    emit(UserUnauthenticated());
  }
}
