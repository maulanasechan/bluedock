class PasswordFormReq {
  final bool obscure;
  final bool open;
  const PasswordFormReq({this.obscure = true, this.open = false});

  PasswordFormReq copyWith({bool? obscure, bool? open}) => PasswordFormReq(
    obscure: obscure ?? this.obscure,
    open: open ?? this.open,
  );
}
