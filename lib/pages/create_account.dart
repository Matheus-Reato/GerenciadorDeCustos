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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Container(
          padding: EdgeInsets.only(top: 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Me Poupe', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){}, icon: Icon(Icons.monetization_on, size: 40, color: Color.fromRGBO(50, 116, 109, 1.0),)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Cadastro de Usuário',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nome',
                  border: OutlineInputBorder( // Use OutlineInputBorder para definir um raio de borda
                    borderRadius: BorderRadius.circular(20), // Defina o raio da borda
                    borderSide: BorderSide(color: Colors.grey, width: 1), // Defina a cor e a largura da borda
                  ),
                ),
                controller: _name,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder( // Use OutlineInputBorder para definir um raio de borda
                    borderRadius: BorderRadius.circular(20), // Defina o raio da borda
                    borderSide: BorderSide(color: Colors.grey, width: 1), // Defina a cor e a largura da borda
                  ),
                ),
                controller: _email,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Senha',
                  border: OutlineInputBorder( // Use OutlineInputBorder para definir um raio de borda
                    borderRadius: BorderRadius.circular(20), // Defina o raio da borda
                    borderSide: BorderSide(color: Colors.grey, width: 1), // Defina a cor e a largura da borda
                  ),
                ),
                controller: _password,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _criarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cadastrar conta',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
