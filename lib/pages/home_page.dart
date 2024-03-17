import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_page.dart';
import 'package:get/get.dart';

import '../controller/alimentacao_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 250, 238, 1.0),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bem vindo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Text('Matheus',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Text(
              'Mês: Março',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gasto total: RS 4000,00',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(237, 242, 244, 1.0),
                        foregroundColor: Colors.black),
                    onPressed: () {},
                    child: Text('Relatórios'))
              ],
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(230, 57, 70, 1.0),
        toolbarHeight: 160,
      ),
      body: Center(
        child: Column(
          //FAZER UM WIDGET PARA O ELEVATED BUTTON TENDO COMO REQUIRED O TEXT, ASSIM SÓ CHAMA O MÉTODO PASSANDO O NOME
          children: [
            SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size.fromWidth(310),
                backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
              ),
              onPressed: () {
                Get.to(AlimentacaoPage());
              },
              icon: Icon(
                Icons.fastfood,
                color: Colors.black,
                size: 35,
              ),
              label: Text(
                'Alimentação',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size.fromWidth(310),
                backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.car_rental,
                color: Colors.black,
                size: 35,
              ),
              label: Text(
                'Transporte',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                fixedSize: Size.fromWidth(310),
                backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.beach_access,
                color: Colors.black,
                size: 35,
              ),
              label: Text(
                'Lazer',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
