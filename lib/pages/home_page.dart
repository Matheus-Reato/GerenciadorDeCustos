import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/DropdownButtonModalidade.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_page.dart';
import 'package:get/get.dart';

import '../controller/alimentacao_controller.dart';
import 'DropdownButtonAno.dart';
import 'DropdownButtonMes.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) => {
      Get.offAll(Login())
    });
  }



  @override
  Widget build(BuildContext context) {

    return GetBuilder<AlimentacaoController>(builder: (ctrl)
    {
      // Obter a data atual
      DateTime now = DateTime.now();

      // Extrair o mês da data atual
      int month = now.month;

      final Map<int, String> monthsMap = {
        1: 'Janeiro',
        2: 'Fevereiro',
        3: 'Março',
        4: 'Abril',
        5: 'Maio',
        6: 'Junho',
        7: 'Julho',
        8: 'Agosto',
        9: 'Setembro',
        10: 'Outubro',
        11: 'Novembro',
        12: 'Dezembro',
      };

      String? mesAtual = monthsMap[month];

      String? _selectedMonth;

      List<String> meses = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro'
      ];

      List<String> anos = ['2020', '2021', '2022', '2023', '2024'];

      List<String> modalidade = ['Todos', 'Alimentação', 'Transporte', 'Lazer'];


      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 249, 254, 1.0),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(128, 217, 132, 0.7), // Cor esquerda
                  Color.fromRGBO(224, 242, 225, 1.0), // Cor direita
                ],
                begin: Alignment.topCenter, // Início do gradiente no topo
                end: Alignment.bottomCenter, // Fim do gradiente na base
              ),
            ),
          ),

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bem vindo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Matheus Reato',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {
                    _deslogarUsuario();
                  }, icon: Icon(Icons.exit_to_app), iconSize: 30,)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Mês: $mesAtual',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
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
              Row(
                children: [
                  DropdownButtonMes(items: meses,
                    onChanged: (String? selectedItem) {
                      ctrl.setSelectedMonth(selectedItem);
                    },),
                  DropdownButtonAno(items: anos),
                  DropdownButtonModalidade(items: modalidade)
                ],
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fixedSize: Size.fromWidth(150),
                  backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
                ),
                onPressed: () {
                  ctrl.calculoDeGastos();
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
                label: Text(
                  'Buscar',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
