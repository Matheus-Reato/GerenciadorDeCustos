import 'package:flutter/material.dart';
import 'package:gerenciador_de_custos/controller/alimentacao_controller.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_add_page.dart';
import 'package:gerenciador_de_custos/pages/alimentacao_update_page.dart';
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

  void _refreshList(AlimentacaoController ctrl) {
    setState(() {
      originalAlimentacaoList = List<Alimentacao>.from(ctrl.alimentacaoList);
      _applySearch(ctrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlimentacaoController>(builder: (ctrl) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 249, 254, 1.0),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(247, 53, 53, 0.9),
                  Color.fromRGBO(243, 85, 86, 1.0),
                  Color.fromRGBO(240, 70, 70, 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
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
                      style: TextStyle(fontSize: 30),
                    );
                  } else {
                    String valueToShow = _isVisible ? 'R\$ ${snapshot.data?.toStringAsFixed(2)}' : '*****';
                    return Row(
                      children: [
                        IconButton(
                          icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                        ),
                        Text(
                          valueToShow,
                          style: TextStyle(fontSize: 30),
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
                          border: InputBorder.none,
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
                                        ctrl.deleteAlimentacao(alimentacao.id ?? '').then((_) {
                                          _refreshList(ctrl); // Atualiza a lista após a exclusão
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
                                Text('R\$ ${alimentacao.preco?.toStringAsFixed(2) ?? 0}'),
                                Text(alimentacao.data ?? ''),
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
          onPressed: () {
            Get.off(AddAlimentacao());
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
