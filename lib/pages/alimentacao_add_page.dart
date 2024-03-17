import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_page.dart';
import 'package:get/get.dart';

class AddAlimentacao extends StatefulWidget {
  const AddAlimentacao({Key? key});

  @override
  State<AddAlimentacao> createState() => _AddAlimentacaoState();
}

class _AddAlimentacaoState extends State<AddAlimentacao> {

  final AlimentacaoController ctrl = Get.put(AlimentacaoController());

  @override
  void initState() {
    super.initState();
    // Limpar os controllers quando o widget é inicializado
    ctrl.alimentacaoNomeCtrl.clear();
    ctrl.alimentacaoPrecoCtrl.clear();
    ctrl.dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {

      Future<void> _selectDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),

        );
        if (picked != null) {

          setState(() {
            ctrl.dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

          });
        }
      }

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
                  readOnly: true,
                  controller: ctrl.dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data',
                    hintText: 'dd/MM/yyyy',
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.alimentacaoNomeCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Nome para a despesa',
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.alimentacaoPrecoCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Preço',
                    hintText: '\$\$.\$\$',
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(252, 231, 232, 1.0),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    ctrl.addAlimentacao();
                    ctrl.fetchAlimentacao();
                    Get.off(AlimentacaoPage());
                  },
                  child: Text('Adicionar', style: TextStyle(fontSize: 24),),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
