class LoginFormReq {
  final String email;
  final String password;
  const LoginFormReq({this.email = '', this.password = ''});

  LoginFormReq copyWith({String? email, String? password}) => LoginFormReq(
    email: email ?? this.email,
    password: password ?? this.password,
  );
}
