import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/transporte_controller.dart';
import 'package:gerenciador_de_custos/model/transporte/transporte.dart';
import 'package:gerenciador_de_custos/pages/transporte_page.dart';
import 'package:get/get.dart';

class AddTransporte extends StatefulWidget {
  const AddTransporte({Key? key});

  @override
  State<AddTransporte> createState() => _AddTransporteState();
}

class _AddTransporteState extends State<AddTransporte> {

  final TransporteController ctrl = Get.put(TransporteController());

  @override
  void initState() {
    super.initState();
    // Limpar os controllers quando o widget é inicializado
    ctrl.transporteNomeCtrl.clear();
    ctrl.transportePrecoCtrl.clear();
    ctrl.dateController.clear();
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
                  'Cadastro',
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
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Nome para a despesa',
                  ),
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: ctrl.transportePrecoCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Preço',
                    hintText: '\$\$.\$\$',
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if(ctrl.transporteNomeCtrl.text == '' || ctrl.transportePrecoCtrl.text == '' || ctrl.dateController.text == ''){
                      Get.snackbar(
                        'Erro',
                        'Campos obrigatórios em branco',
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
                        messageText: Text(
                          'Campos obrigatórios em branco',
                          style: TextStyle(
                          fontSize: 16, // Tamanho da fonte da mensagem
                          color: Colors.white,
                          )
                        )
                      );
                    } else {
                      await ctrl.addTransporte();
                      await ctrl.fetchTransporte();
                      Get.off(TransportePage());
                    }

                  },
                  child: Text('Adicionar', style: TextStyle(fontSize: 24, color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
