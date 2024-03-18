import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_add_page.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_update_page.dart';
import 'package:get/get.dart';

import '../model/alimentacao/alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({super.key});

  //MaterialPageRoute

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Executar fetchAlimentacao após o primeiro quadro para garantir que o widget seja construído
      final ctrl = Get.find<AlimentacaoController>();
      ctrl.fetchAlimentacao();
    });
  }

  Map<String, Alimentacao> alimentacaoMap = {};

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
              Text(
                'Alimentação',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FutureBuilder<double>(
                future: ctrl.buscaGasto(),
                builder: (context, snapshot) {
                  return Text(
                    'R\$ ${snapshot.data?.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 30),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80.0),
          child: Column(
            children: [
            ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ctrl.alimentacaoList.length,
            itemBuilder: (context, index) {
              final alimentacao = ctrl.alimentacaoList[index];
              return Container(
                height: 85,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(alimentacao.nome?.toUpperCase() ?? ''),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.to(UpdateAlimentacao(
                                      alimentacaoId: alimentacao.id ?? '',
                                    ));
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ctrl.deleteAlimentacao(alimentacao.id ?? '');
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('R\$ ${alimentacao.preco?.toStringAsFixed(2) ?? 0}'),
                            Text(alimentacao.data ?? ''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddAlimentacao());
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
