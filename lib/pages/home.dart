import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'login_page.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // @override
  // void initState() {
  //   context.read<UserBloc>().add(const ObtenerInformacionUsuarioEvent());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          child: BlocBuilder<UserBloc, UserState>(builder: ((context, state) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.id == '') const CircularProgressIndicator(),
                  if (state.id != '')
                    Column(
                      children: [
                        if (state.avatar != null)
                          ClipOval(
                              child: Image.network(
                            state.avatar!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )),
                        const SizedBox(height: 20),
                        Text(state.id),
                        Text(state.email),
                        Text(state.username),
                        Text(state.createdAt!.toIso8601String())
                      ],
                    ),
                  const SizedBox(height: 300),
                  if (state.id != '')
                    TextButton(
                        onPressed: _pickImage(context),
                        child: const Text('Update Avatar',
                            style: TextStyle(color: Colors.white)),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.pink)),
                  TextButton(
                      onPressed: _signOut(context),
                      child: const Text('Sign Out',
                          style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent))
                ]);
          }))),
    );
  }

  _signOut(BuildContext context) async {
    context.read<UserBloc>().add(const CerrarSesionUsuario());
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }

  _pickImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();

    final XFile imageFile =
        await imagePicker.pickImage(source: ImageSource.camera) as XFile;
    final image = File(imageFile.path);
    final bytes = await image.readAsBytes();
    final fileName = path.basename(image.path);

    context
        .read<UserBloc>()
        .add(ActualizarImagenUsuario(bytes: bytes, fileName: fileName));
  }
}
