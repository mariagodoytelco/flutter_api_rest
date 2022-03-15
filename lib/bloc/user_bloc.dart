import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../api/account_api.dart';
import '../api/authentication_api.dart';
import '../data/authentication_client.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AccountAPI accountAPI = GetIt.instance<AccountAPI>();
  final authenticationAPI = GetIt.instance<AuthenticationAPI>();
  final AuthenticationClient authenticationClient =
      GetIt.instance<AuthenticationClient>();

  UserBloc()
      : super(const UserState(
            id: '',
            username: '',
            email: '',
            createdAt: null,
            updatedAt: null,
            avatar: '')) {
    on<ObtenerInformacionUsuarioEvent>((event, emit) async {
      final response = await accountAPI.getUserInfo();
      emit(state.copyWith(
          id: response.id,
          username: response.username,
          email: response.email,
          createdAt: response.createdAt,
          updatedAt: response.updatedAt,
          conectado: true, 
          error: null));
    });

    on<ActualizarImagenUsuario>(((event, emit) async {
      final response =
          await accountAPI.updateAvatar(event.bytes, event.fileName);
      emit(state.copyWith(
          avatar: 'https://curso-api-flutter.herokuapp.com$response'));
    }));
    on<CerrarSesionUsuario>(((event, emit) async {
      await authenticationClient.signOut();
      state.copyWith(conectado: false);
    }));
    on<IniciarSesionUsuario>(((event, emit) async {
      final response = await authenticationAPI.login(
          email: event.email, password: event.pass);
      if (response.data != null) {
        await authenticationClient.saveSession(response.data!);
        state.copyWith(conectado: true, error: null);
      } else {
        state.copyWith(conectado: false, error: response.error!.statusCode);
      }
    }));
  }
}
