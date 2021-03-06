class User {
  String id;
  String username;
  String password;
  double balance;
  String firstName;
  String lastName;
  String email;
  String birthDate;
  String phoneNumber;
  String adress;
  String sex;
  String? createdAt;
  String? modifiedAt;

  User({
    required final this.id,
    required final this.username,
    required final this.password,
    required final this.balance,
    required final this.firstName,
    required final this.lastName,
    required final this.email,
    required final this.birthDate,
    required final this.phoneNumber,
    required final this.adress,
    required final this.sex,
    final this.createdAt,
    final this.modifiedAt,
  });

  User copyWith({
    String? id,
    String? username,
    String? password,
    double? balance,
    String? firstName,
    String? lastName,
    String? email,
    String? birthDate,
    String? phoneNumber,
    String? adress,
    String? sex,
    String? createdAt,
    String? modifiedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      balance: balance ?? this.balance,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      adress: adress ?? this.adress,
      sex: sex ?? this.sex,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'password': password});
    result.addAll({'balance': balance});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'email': email});
    result.addAll({'birthDate': birthDate});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'adress': adress});
    result.addAll({'sex': sex});
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (modifiedAt != null) {
      result.addAll({'modifiedAt': modifiedAt});
    }

    return result;
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      balance: map['balance']?.toDouble() ?? 0.0,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      birthDate: map['birthDate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      adress: map['adress'] ?? '',
      sex: map['sex'] ?? '',
      createdAt: map['createdAt'],
      modifiedAt: map['modifiedAt'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, password: $password, balance: $balance, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, phoneNumber: $phoneNumber, adress: $adress, sex: $sex, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.password == password &&
        other.balance == balance &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.phoneNumber == phoneNumber &&
        other.adress == adress &&
        other.sex == sex &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        password.hashCode ^
        balance.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        phoneNumber.hashCode ^
        adress.hashCode ^
        sex.hashCode ^
        createdAt.hashCode ^
        modifiedAt.hashCode;
  }
}
