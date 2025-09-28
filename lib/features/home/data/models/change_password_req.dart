class ChangePasswordReq {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordReq({this.oldPassword = '', this.newPassword = ''});

  ChangePasswordReq copyWith({String? oldPassword, String? newPassword}) =>
      ChangePasswordReq(
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
      );
}
