import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String id;
  final String username;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? avatar;
  final bool conectado;
  final int? error;

  const UserState(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.updatedAt,
      required this.avatar,
      this.conectado = false, 
      this.error,
      });

  UserState copyWith(
          {String? id,
          String? username,
          String? email,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? avatar,
          bool? conectado,
          int? error,
          }) =>
      UserState(
          id: id ?? this.id,
          username: username ?? this.username,
          email: email ?? this.email,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          avatar: avatar ?? this.avatar,
          conectado: conectado ?? this.conectado,
          error: error ?? this.error);

  @override
  List<Object?> get props =>
      [id, username, email, createdAt, updatedAt, avatar, conectado, error];
}
