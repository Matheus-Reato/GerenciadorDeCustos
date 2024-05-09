import 'package:gerenciador_de_custos/pages/home_page.dart';
import 'package:gerenciador_de_custos/pages/create_account.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  _login() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 20),
                  hintText: 'Seu email',
                ),
                controller: _email,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 20),
                  hintText: 'Sua senha',
                ),
                controller: _password,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 30),
                child: ElevatedButton(
                    child: Text("Log-In"),
                    onPressed: () {
                      _login();
                    }),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccount()));
                  },
                  child: Text('Create account'))
            ],
          ),
        ),
      ),
    );
  }
}
