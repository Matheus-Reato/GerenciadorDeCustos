import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/pages/transporte_add_page.dart';
import 'package:gerenciador_de_custos/pages/transporte_update_page.dart';
import 'package:gerenciador_de_custos/widgets/DropdownButtonAlimentacao.dart';
import 'package:get/get.dart';

import '../controller/transporte_controller.dart';
import '../model/transporte/transporte.dart';

class TransportePage extends StatefulWidget {
  const TransportePage({Key? key}) : super(key: key);

  @override
  State<TransportePage> createState() => _TransportePageState();
}

class _TransportePageState extends State<TransportePage> {
  bool _isVisible = true;
  String searchTerm = '';
  List<Transporte> originalTransporteList = [];
  List<Transporte> searchedTransporteList = [];

  String? _selectedMonth = 'Todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final ctrl = Get.find<TransporteController>();
      ctrl.fetchTransporte().then((_) {
        setState(() {
          originalTransporteList = List<Transporte>.from(ctrl.transporteList);
          _applySearch(ctrl);
        });
      });
    });
  }

  void _applySearch(TransporteController ctrl) {
    if (searchTerm.isEmpty) {
      searchedTransporteList = List<Transporte>.from(originalTransporteList);
    } else {
      searchedTransporteList = originalTransporteList
          .where((transporte) => (transporte.nome ?? '').toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
    searchedTransporteList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));
  }

  void _refresh(TransporteController ctrl){
    ctrl.fetchTransporte().then((_) {
      setState(() {
        originalTransporteList = List<Transporte>.from(ctrl.transporteList);
        _applySearch(ctrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransporteController>(builder: (ctrl) {
      List<String> meses = [
        'Todos',
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


      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 249, 254, 1.0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(16, 79, 85, 1.0)
            ),
          ),
          toolbarHeight: 160,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Transporte',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 30),
              FutureBuilder<double>(
                future: ctrl.buscaGasto(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return Text(
                      '*****',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    );
                  } else {
                    String valueToShow = _isVisible ? 'R\$ ${snapshot.data?.toStringAsFixed(2)}' : '*****';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                        ),
                        Text(
                          valueToShow,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 80.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Pesquisar',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value;
                            _applySearch(ctrl);
                          });
                        },
                      ),
                    ),

                    Obx(() => DropdownButtonAlimentacao(
                      items: meses,
                      onChanged: (String? selectedItem) {

                        ctrl.setSelectedMonthTransporte(selectedItem);
                        _refresh(ctrl);
                      },
                      value: ctrl.mesPadrao.value,
                    )),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchedTransporteList.length,
                itemBuilder: (context, index) {
                  final transporte = searchedTransporteList[index];
                  return Container(
                    height: 85,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(transporte.nome?.toUpperCase() ?? '', style: TextStyle(fontWeight: FontWeight.w500),),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.off(UpdateTransporte(
                                          transporteId: transporte.id ?? '',
                                        ));

                                        _refresh(ctrl);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ctrl.deleteTransporte(transporte.id ?? '').then((_) {
                                          _refresh(ctrl); // Atualiza a lista após a exclusão
                                        });
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
                                Text('R\$ ${transporte.preco?.toStringAsFixed(2) ?? 0}', style: TextStyle(fontWeight: FontWeight.w500),),
                                Text(transporte.data ?? '', style: TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(50, 116, 109, 1.0),
          onPressed: () {
            Get.off(AddTransporte());
          },
          child: Icon(Icons.add, color: Colors.white, size: 35,),
        ),
      );
    });
  }
}
