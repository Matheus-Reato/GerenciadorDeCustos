import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciador_de_custos/pages/home_page.dart';
import 'package:gerenciador_de_custos/pages/create_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  _login() async{
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text)
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
      });
    } catch (e) {
      Get.snackbar(
          '',
          '',
          colorText: Colors.white, // Cor do texto
          backgroundColor: Colors.red, // Cor de fundo
          snackPosition: SnackPosition.BOTTOM, // Posição do snackbar (TOP ou BOTTOM)
          borderRadius: 20, // Raio da borda
          margin: EdgeInsets.all(15), // Margem ao redor do snackbar
          icon: Icon(Icons.error, color: Colors.white), // Ícone
          shouldIconPulse: true, // Animação de pulsar do ícone
          barBlur: 20, // Desfocagem do fundo da barra
          isDismissible: true, // Se o snackbar pode ser dispensado
          duration: Duration(seconds: 3), // Duração do snackbar
          forwardAnimationCurve: Curves.easeOutBack, // Curva de animação de entrada
          reverseAnimationCurve: Curves.easeInBack, // Curva de animação de saída
          titleText: Text(
            'Erro',
            style: TextStyle(
              fontSize: 20, // Tamanho da fonte do título
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
              'Email ou senha inválido',
              style: TextStyle(
                fontSize: 16, // Tamanho da fonte da mensagem
                color: Colors.white,
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          padding: const EdgeInsets.only(left: 20,right: 20, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Seu email',
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
                  hintText: 'Sua senha',
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
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Log-In',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccount()),
                  );
                },
                child: Text(
                  'Cadastrar conta',
                  style: TextStyle(fontSize: 18, color: Color.fromRGBO(50, 116, 109, 1.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
