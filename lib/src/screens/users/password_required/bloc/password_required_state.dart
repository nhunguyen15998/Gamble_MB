part of 'password_required_bloc.dart';

class PasswordRequiredState extends Equatable {
  PasswordRequiredState({
    this.status = FormzStatus.pure,
    this.password = const RequiredPassword.pure(),
    this.isBtnDisabled = false,
    this.path = '',
    this.data = const <String, String>{},
    this.code = 0,
    this.message = '',
    this.receiverPhone = '',
    this.type = '',
  });

  FormzStatus status;
  RequiredPassword password;
  bool isBtnDisabled;
  String path;
  Map<String, String> data;
  int code;
  String message;
  String receiverPhone;
  String type;

  PasswordRequiredState copyWith({
    FormzStatus? status,
    RequiredPassword? password,
    bool? isBtnDisabled,
    String? path,
    Map<String, String>? data,
    int? code,
    String? message,
    String? receiverPhone,
    String? type,
  }){
    return PasswordRequiredState(
      status: status ?? this.status,
      password: password ?? this.password,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
      path: path ?? this.path,
      data: data ?? this.data,
      code: code ?? this.code,
      message: message ?? this.message,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [status, password, isBtnDisabled, path, data, code, message, receiverPhone, type];
}

