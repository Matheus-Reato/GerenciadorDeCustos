import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/transporte_page.dart';
import 'package:gerenciador_de_custos/widgets/DropdownButtonModalidade.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_page.dart';
import 'package:get/get.dart';

import '../controller/alimentacao_controller.dart';
import '../widgets/DropdownButtonAno.dart';
import '../widgets/DropdownButtonMes.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedModalidade;

  String? _nomeUsuario;

  _pesquisaNomeUsuario() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;
    final userDocRef = firestore.collection('usuario').doc(_userId);

    var snapshot = await userDocRef.get();
    return _nomeUsuario = snapshot.data()?['nome'];
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((value) => {
      Get.offAll(Login())
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {
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
              color: Color.fromRGBO(16, 79, 85, 1.0),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bem vindo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    FutureBuilder<dynamic>(
                      future: _pesquisaNomeUsuario(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? 'Nome não encontrado', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),); // Mostra o nome ou uma mensagem padrão se o nome não for encontrado
                        }
                      },
                    ),

                  IconButton(
                    onPressed: () {
                      _deslogarUsuario();
                    },
                    icon: Icon(Icons.exit_to_app, color: Colors.white,),
                    iconSize: 30,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Mês: $mesAtual',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
          toolbarHeight: 160,
        ),
        body: SingleChildScrollView(
          child: Center(
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
                    backgroundColor: Color.fromRGBO(158, 197, 171, 1.0),
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
                    backgroundColor: Color.fromRGBO(158, 197, 171, 1.0),
                  ),
                  onPressed: () {
                    Get.to(TransportePage());
                  },
                  icon: Icon(
                    Icons.train,
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
                    backgroundColor: Color.fromRGBO(158, 197, 171, 1.0),
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
                SizedBox(
                  height: 50,
                ),
          
                Text('Calcule seus gastos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    DropdownButtonMes(
                      items: meses,
                      onChanged: (String? selectedItem) {
                        setState(() {
                          _selectedMonth = selectedItem;
                        });
                      },
                    ),
                    DropdownButtonAno(
                      items: anos,
                      onChanged: (String? selectedItem) {
                        setState(() {
                          _selectedYear = selectedItem;
                        });
                      },
                    ),
                    DropdownButtonModalidade(
                      items: modalidade,
                      onChanged: (String? selectedItem) {
                        setState(() {
                          _selectedModalidade = selectedItem;
                        });
                      },
                    ),
                  ],
                ),
          
                SizedBox(
                  height: 20,
                ),
          
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size.fromWidth(150),
                    backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                  ),
                  onPressed: () {
                    ctrl.setSelectedMonth(_selectedMonth);
                    ctrl.setSelectedYear(_selectedYear);
                    ctrl.setSelectedModalidade(_selectedModalidade);
                    ctrl.calculoDeGastos();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Buscar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
          
                FutureBuilder<double>(
                  future: ctrl.calculoDeGastos(),
                  builder: (context, snapshot) {
                     if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text(
                        'Nenhum dado disponível',
                        style: TextStyle(fontSize: 30),
                      );
                    } else {
                      return Text(
                        'R\$ ${snapshot.data!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 30),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}