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
            avatar: '',
            error: null,
            conectado: false,
            success: false,
            loading: false)) {
    on<ObtenerInformacionUsuarioEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final response = await accountAPI.getUserInfo();
      if (response.data != null) {
        emit(state.copyWith(
            id: response.data!.id,
            username: response.data!.username,
            email: response.data!.email,
            createdAt: response.data!.createdAt,
            updatedAt: response.data!.updatedAt,
            conectado: true,
            loading: false,
            success: true));
      } else {
        emit(state.copyWith(loading: false, error: response.error!.statusCode, success: false));
      }
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
