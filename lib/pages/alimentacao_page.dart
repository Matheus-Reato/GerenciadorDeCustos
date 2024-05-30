import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_add_page.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_update_page.dart';
import 'package:gerenciador_de_custos/widgets/DropdownButtonAlimentacao.dart';
import 'package:get/get.dart';

import '../model/alimentacao/alimentacao.dart';

class AlimentacaoPage extends StatefulWidget {
  const AlimentacaoPage({Key? key}) : super(key: key);

  @override
  State<AlimentacaoPage> createState() => _AlimentacaoPageState();
}

class _AlimentacaoPageState extends State<AlimentacaoPage> {
  bool _isVisible = true;
  String searchTerm = '';
  List<Alimentacao> originalAlimentacaoList = [];
  List<Alimentacao> searchedAlimentacaoList = [];

  String? _selectedMonth = 'Todos';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final ctrl = Get.find<AlimentacaoController>();
      ctrl.fetchAlimentacao().then((_) {
        setState(() {
          originalAlimentacaoList = List<Alimentacao>.from(ctrl.alimentacaoList);
          _applySearch(ctrl);
        });
      });
    });
  }

  void _applySearch(AlimentacaoController ctrl) {
    if (searchTerm.isEmpty) {
      searchedAlimentacaoList = List<Alimentacao>.from(originalAlimentacaoList);
    } else {
      searchedAlimentacaoList = originalAlimentacaoList
          .where((alimentacao) => (alimentacao.nome ?? '').toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }
    searchedAlimentacaoList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));
  }

  void _refresh(AlimentacaoController ctrl){
    ctrl.fetchAlimentacao().then((_) {
      setState(() {
        originalAlimentacaoList = List<Alimentacao>.from(ctrl.alimentacaoList);
        _applySearch(ctrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {
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
                'Alimentação',
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
                        setState(() {
                          ctrl.setSelectedMonth(selectedItem);
                        });
                        ctrl.setSelectedMonthAlimentacao(selectedItem);
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
                itemCount: searchedAlimentacaoList.length,
                itemBuilder: (context, index) {
                  final alimentacao = searchedAlimentacaoList[index];
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
                                Text(alimentacao.nome?.toUpperCase() ?? '', style: TextStyle(fontWeight: FontWeight.w500),),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.off(UpdateAlimentacao(
                                          alimentacaoId: alimentacao.id ?? '',
                                        ));

                                        _refresh(ctrl);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ctrl.deleteAlimentacao(alimentacao.id ?? '').then((_) {
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
                                Text('R\$ ${alimentacao.preco?.toStringAsFixed(2) ?? 0}', style: TextStyle(fontWeight: FontWeight.w500),),
                                Text(alimentacao.data ?? '', style: TextStyle(fontWeight: FontWeight.w500)),
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
            Get.off(AddAlimentacao());
          },
          child: Icon(Icons.add, color: Colors.white, size: 35,),
        ),
      );
    });
  }
}
