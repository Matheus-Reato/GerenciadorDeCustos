import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenciador_de_custos/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/login.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController _email = TextEditingController();

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _email.text.trim());

      Get.snackbar(
        '', // Título vazio porque estamos usando `titleText` personalizado
        '',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        icon: Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        titleText: Text(
          'Sucesso',
          style: TextStyle(
            fontSize: 20, // Tamanho da fonte do título
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Redefinição de senha enviada! Cheque seu email',
          style: TextStyle(
            fontSize: 16, // Tamanho da fonte da mensagem
            color: Colors.white,
          ),
        ),
      );

      await Future.delayed(Duration(seconds: 3));
      Get.off(() => Login());

    } on FirebaseAuthException catch (e) {

      print(e.message.toString());

      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = 'O email fornecido está mal formatado.';
      }
      if (e.code == 'user-not-found') {
        errorMessage = 'Não existe um usuário correspondente ao email fornecido.';
      } else{
      errorMessage = 'Ocorreu um erro. Por favor, tente novamente.';
      }

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
          errorMessage,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      } catch (e){
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
          'Ocorreu um erro inesperado, tente novamente',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
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
          padding: const EdgeInsets.only(left: 20,right: 20, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                'Redefinir senha',
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

              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                  padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Redefinir senha',
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

