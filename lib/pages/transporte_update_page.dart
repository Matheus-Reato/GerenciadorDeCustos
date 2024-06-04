import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/transporte_page.dart';
import 'package:get/get.dart';
import '../controller/transporte_controller.dart';

class UpdateTransporte extends StatefulWidget {
  final String transporteId;


  UpdateTransporte({super.key, required this.transporteId});

  @override
  State<UpdateTransporte> createState() => _UpdateTransporteState();
}

class _UpdateTransporteState extends State<UpdateTransporte> {

  final TransporteController ctrl = Get.put(TransporteController());

  @override
  void initState() {
    super.initState();
    // Carregar detalhes do documento usando o ID recebido
    ctrl.fetchTransporteDetalhes(widget.transporteId).then((_) {
      // Preencher os controladores de texto com os detalhes da alimentação
      ctrl.dateController.text = ctrl.transporteAtual?.data ?? '';
      ctrl.transporteNomeCtrl.text = ctrl.transporteAtual?.nome ?? '';
      ctrl.transportePrecoCtrl.text = ctrl.transporteAtual?.preco.toString() ?? '';
      setState(() {}); // Garantir que o widget seja reconstruído após atribuir os valores
    });
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransporteController>(builder: (ctrl) {

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
        backgroundColor: Color.fromRGBO(255, 249, 254, 1.0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(16, 79, 85, 1.0),
          toolbarHeight: 160,
          title: const Center(
            child: Column(
              children: [
                Text(
                  'Atualização',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),

              ],
            ),
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
                    hintText: 'yyyy-MM-dd',
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                ),

                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.transporteNomeCtrl,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                      hintText: 'Nome para a despesa'
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.transportePrecoCtrl,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      labelText: 'Preço',
                      hintText: '\$\$.\$\$'
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                  foregroundColor: Colors.black,
                ), onPressed: () async {
                  if(ctrl.transporteNomeCtrl.text == '' || ctrl.transportePrecoCtrl.text == '' || ctrl.dateController.text == ''){
                    Get.snackbar('Error', 'Campos obrigatórios em branco', colorText: Colors.red);
                  } else {
                    await ctrl.updateTransporte(widget.transporteId);
                    await ctrl.fetchTransporte();
                    Get.off(TransportePage());
                  }
                }, child: Text('Atualizar', style: TextStyle(fontSize: 24, color: Colors.white),))
              ],
            ),
          ),
        ),
      );
    });
  }
}