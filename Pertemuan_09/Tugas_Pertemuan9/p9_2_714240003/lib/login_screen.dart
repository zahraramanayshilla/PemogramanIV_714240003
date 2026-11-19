import 'package:flutter/material.dart';
import 'package:shared_preferences_714240003/2nd/botnav.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

@override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  late SharedPreferences loginData;
  late bool newUser;
  
  bool rememberMe = false;


  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  String? _validateUsername(String? value) {
    if (value != null && value.length < 4) {
      return 'Masukkan minimal 4 karakter';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value != null && value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Shared Preference')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      validator: _validateUsername,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        hintText: 'Write username here...',
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: _validatePassword,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password_rounded),
                        hintText: 'Write your password here...',
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        fillColor: Color.fromARGB(255, 242, 254, 255),
                        filled: true,
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    title: const Text('Remember Me'),
                    value: rememberMe,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValidForm = _formKey.currentState!.validate();

                       String username = _usernameController.text;

                        if (isValidForm) {
                          String username = _usernameController.text;

                          await loginData.setBool('login', false);
                          await loginData.setString('username', username);

                          if (rememberMe) {
                            await loginData.setString(
                              'remembered_username',
                              username,
                            );
                          } else {
                            await loginData.remove('remembered_username');
                          }

                          if (!mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DynamicBottomNavBar(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
   
Future<void> checkLogin() async {
    loginData = await SharedPreferences.getInstance();

    newUser = loginData.getBool('login') ?? true;

    // Membaca username yang disimpan
    String? savedUsername = loginData.getString('remembered_username');

    if (!mounted) return;

    setState(() {
      if (savedUsername != null) {
        _usernameController.text = savedUsername;
        rememberMe = true;
      } else {
        _usernameController.clear();
        rememberMe = false;
      }
    });

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DynamicBottomNavBar()),
        (route) => false,
      );
    }
  }
}


