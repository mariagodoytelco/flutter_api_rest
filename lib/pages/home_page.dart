import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../models/user.dart';
import '../api/account_api.dart';
import '../data/authentication_client.dart';
import '../utils/logs.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AccountAPI _accountAPI = GetIt.instance<AccountAPI>();
  final AuthenticationClient _authenticationClient =
      GetIt.instance<AuthenticationClient>();

  User? _user;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadUser();
    });
    super.initState();
  }

  Future<void> _loadUser() async {
    final response = await _accountAPI.getUserInfo();
    Logs.p.i(response);
    _user = response;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //no espera al await en el init state, por lo que llame al metodo en el build
    //averiguar por que no espera
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (_user == null) const CircularProgressIndicator(),
        if (_user != null)
          Column(
            children: [
              if (_user!.avatar != null) ClipOval(
                child: Image.network(
                  'https://curso-api-flutter.herokuapp.com${_user!.avatar!}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  ),
              ),
              const SizedBox(height: 20),
              Text(_user!.id),
              Text(_user!.email),
              Text(_user!.username),
              Text(_user!.createdAt.toIso8601String())
            ],
          ),
        const SizedBox(height: 300),
        if (_user != null) 
        TextButton(onPressed: _pickImage, child: const Text('Update Avatar', style: TextStyle(color: Colors.white)), style: TextButton.styleFrom(backgroundColor: Colors.pink)),
        TextButton(onPressed: _signOut, child: const Text('Sign Out', style: TextStyle(color: Colors.white)), style: TextButton.styleFrom(backgroundColor: Colors.deepOrangeAccent))
      ]),
    ));
  }

  Future<void> _signOut() async {
    await _authenticationClient.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.routeName, (route) => false);
  }

  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();

    final XFile imageFile =
        await imagePicker.pickImage(source: ImageSource.camera) as XFile;
    final image = File(imageFile.path);
    final bytes = await image.readAsBytes();
    final fileName = path.basename(image.path);

    final response = await _accountAPI.updateAvatar(bytes, fileName);

    if (response.isNotEmpty) {
      _user = _user!.copyWith(avatar: response);
      final String imageurl =
          'https://curso-api-flutter.herokuapp.com$response';
      Logs.p.i(imageurl);
    }
  }
}
