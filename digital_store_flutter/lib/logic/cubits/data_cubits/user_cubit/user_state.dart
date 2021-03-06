part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserUnauthenticated extends UserState {}

class UserConsumer extends UserState {
  final User user;

  const UserConsumer({
    required final this.user,
  });

  @override
  List<Object> get props => [user];

  UserConsumer copyWith({
    User? user,
  }) {
    return UserConsumer(
      user: user ?? this.user,
    );
  }
}

class UserAdministrator extends UserState {
  final User user;
  final String accessToken;
  final String refreshToken;

  const UserAdministrator({
    required final this.user,
    required final this.accessToken,
    required final this.refreshToken,
  });

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
