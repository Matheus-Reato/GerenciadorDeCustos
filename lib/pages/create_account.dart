import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciador_de_custos/pages/home_page.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  _criarUsuario() async {
    //instancias
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, String> dadosUser = {
      "nome": _name.text,
      "email": _email.text,
    };
    auth
        .createUserWithEmailAndPassword(email: _email.text, password: _password.text)
        .then((value) async => {
      await db.collection("usuario").doc(value.user!.uid).set(dadosUser),
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    hintText: 'Your name',
                  ),
                  controller: _name,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    hintText: 'Your email',
                  ),
                  controller: _email,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    hintText: 'Your password',
                  ),
                  controller: _password,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      child: Text("Create account"),
                      onPressed: () {
                        _criarUsuario();
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
