import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:get/get.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({super.key});

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(241, 250, 238, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 57, 70, 1.0),
          toolbarHeight: 160,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Alimentação',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Adicionar despesa', style: TextStyle(fontSize: 24),))
            ],
          ),
        ),
        body: ListView.builder(itemCount: ctrl.alimentacaoList.length,itemBuilder: (context, index){
          return ListTile(
            title: Text(ctrl.alimentacaoList[index].nome ?? ''),
            subtitle: Text((ctrl.alimentacaoList[index].preco ?? 0).toString()),
          );

        })
      );
    });
  }
}
