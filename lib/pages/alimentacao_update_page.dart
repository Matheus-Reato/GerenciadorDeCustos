import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:get/get.dart';

import '../model/alimentacao/alimentacao.dart';
import 'alimentacao_page.dart';

class UpdateAlimentacao extends StatefulWidget {
  final Alimentacao alimentacao;

  const UpdateAlimentacao({super.key, required this.alimentacao});

  @override
  State<UpdateAlimentacao> createState() => _UpdateAlimentacaoState();
}

class _UpdateAlimentacaoState extends State<UpdateAlimentacao> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {
      ctrl.dateController.text = widget.alimentacao.data ?? '';
      ctrl.alimentacaoNomeCtrl.text = widget.alimentacao.nome ?? '';
      ctrl.alimentacaoPrecoCtrl.text = widget.alimentacao.preco?.toStringAsFixed(2) ?? '';

      return Scaffold(
        backgroundColor: Color.fromRGBO(241, 250, 238, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 57, 70, 1.0),
          toolbarHeight: 160,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Alimentação',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Column(
              children: [
                TextFormField(
                  controller: ctrl.dateController,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      labelText: 'Data',
                      hintText: 'dd/MM/yyyy'
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.alimentacaoNomeCtrl,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      hintText: 'Nome para a despesa'
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.alimentacaoPrecoCtrl,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      labelText: 'Preço',
                      hintText: '\$\$.\$\$'
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
                  foregroundColor: Colors.black,
                ), onPressed: () {
                  ctrl.updateAlimentacao(widget.alimentacao.id);
                  ctrl.fetchAlimentacao();

                  Get.off(AlimentacaoPage());
                }, child: Text('Atualizar', style: TextStyle(fontSize: 24),))
              ],
            ),
          ),
        ),
      );
    });
  }
}
