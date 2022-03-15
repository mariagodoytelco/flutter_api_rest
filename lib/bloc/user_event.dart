import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class ObtenerInformacionUsuarioEvent extends UserEvent {
  const ObtenerInformacionUsuarioEvent();
}

class ActualizarImagenUsuario extends UserEvent {
  final Uint8List bytes;
  final String fileName;

  const ActualizarImagenUsuario({required this.bytes, required this.fileName});
}

class CerrarSesionUsuario extends UserEvent {
  const CerrarSesionUsuario();
}

class IniciarSesionUsuario extends UserEvent {
  final String email;
  final String pass;
  const IniciarSesionUsuario(this.email, this.pass);
}
