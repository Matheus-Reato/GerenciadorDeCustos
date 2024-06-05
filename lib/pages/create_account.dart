import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciador_de_custos/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  _criarUsuario() async {
    // Instâncias
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_name.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty) {
      Get.snackbar(
        '',
        '',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        icon: Icon(Icons.error, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        titleText: Text(
          'Erro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Campos obrigatórios em branco',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      return;
    } else {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );

        Map<String, String> dadosUser = {
          "nome": _name.text,
          "email": _email.text,
        };

        await db.collection("usuario").doc(userCredential.user!.uid).set(dadosUser);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar(
            '',
            '',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.error, color: Colors.white),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: Duration(seconds: 3),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInBack,
            titleText: Text(
              'Erro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            messageText: Text(
              'Este email já está em uso',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }
        else if(e.code == 'invalid-email'){
          Get.snackbar(
            '',
            '',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.error, color: Colors.white),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: Duration(seconds: 3),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInBack,
            titleText: Text(
              'Erro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            messageText: Text(
              'Email não está no formato correto',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }

        else if(e.code == 'weak-password'){
          Get.snackbar(
            '',
            '',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.error, color: Colors.white),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: Duration(seconds: 3),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInBack,
            titleText: Text(
              'Erro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            messageText: Text(
              'Senha deve possuir 6 ou mais caracteres',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
      }
        else {
          Get.snackbar(
            '',
            '',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            icon: Icon(Icons.error, color: Colors.white),
            shouldIconPulse: true,
            barBlur: 20,
            isDismissible: true,
            duration: Duration(seconds: 3),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInBack,
            titleText: Text(
              'Erro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            messageText: Text(
              'Ocorreu um erro ao criar a conta',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }
      } catch (e) {
        Get.snackbar(
          '',
          '',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          icon: Icon(Icons.error, color: Colors.white),
          shouldIconPulse: true,
          barBlur: 20,
          isDismissible: true,
          duration: Duration(seconds: 3),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
          titleText: Text(
            'Erro',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Ocorreu um erro desconhecido',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      }
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 60),
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
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cadastrar conta',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Já é um membro?', style: TextStyle(fontSize: 18, color: Colors.black),),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18, color: Color.fromRGBO(50, 116, 109, 1.0)),
                      ),
                    ),
                  ],

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
