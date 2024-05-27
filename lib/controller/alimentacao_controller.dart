import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/alimentacao/alimentacao.dart';
import '../model/lazer/lazer.dart';
import '../model/transporte/transporte.dart';

class AlimentacaoController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference alimentacaoCollection;

  List<Alimentacao> alimentacaoList = [];
  List<Transporte> transporteList = [];
  List<Lazer> lazerList = [];

  List<Alimentacao> alimentacaoListOriginal = [];

  Alimentacao? alimentacaoAtual;

  TextEditingController alimentacaoNomeCtrl = TextEditingController();
  TextEditingController alimentacaoPrecoCtrl = TextEditingController();
  TextEditingController alimentacaoDataCtrl = TextEditingController();

  TextEditingController alimentacaoSearchCtrl = TextEditingController();

  TextEditingController dateController = TextEditingController();

  int? selectedYear;
  String? selectedModalidade;
  int? selectedMonth;

  void setSelectedMonth(String? monthName) {
    final Map<String, int> monthsMap = {
      'Janeiro': 1,
      'Fevereiro': 2,
      'Março': 3,
      'Abril': 4,
      'Maio': 5,
      'Junho': 6,
      'Julho': 7,
      'Agosto': 8,
      'Setembro': 9,
      'Outubro': 10,
      'Novembro': 11,
      'Dezembro': 12,
    };

    selectedMonth = monthsMap[monthName];
    update();
  }

  void setSelectedYear(String? year) {
    selectedYear = int.tryParse(year ?? '');
    update();
  }

  void setSelectedModalidade(String? modalidade) {
    selectedModalidade = modalidade;
    update();
  }

  Future<double> calculoDeGastos() async {
    double gastoTotal = 0.0;

    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;
    final userDocRef = firestore.collection('usuario').doc(_userId);

    final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').get();
    final List<Alimentacao> retrievedAlimentacao = alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();
    alimentacaoList.clear();
    alimentacaoList.assignAll(retrievedAlimentacao);

    final QuerySnapshot transporteSnapshot = await userDocRef.collection('transporte').get();
    final List<Transporte> retrievedTransporte = transporteSnapshot.docs.map((doc) => Transporte.fromJson(doc.data() as Map<String, dynamic>)).toList();
    transporteList.clear();
    transporteList.assignAll(retrievedTransporte);

    final QuerySnapshot lazerSnapshot = await userDocRef.collection('lazer').get();
    final List<Lazer> retrievedLazer = lazerSnapshot.docs.map((doc) => Lazer.fromJson(doc.data() as Map<String, dynamic>)).toList();
    lazerList.clear();
    lazerList.assignAll(retrievedLazer);


    if (selectedModalidade == "Todos") {
      for (int i = 0; i < alimentacaoList.length; i++) {
        if (alimentacaoList[i].mesAtual == selectedMonth && alimentacaoList[i].anoAtual == selectedYear) {
          gastoTotal += alimentacaoList[i].preco!;
        }
      }

      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth && transporteList[i].anoAtual == selectedYear) {
          gastoTotal += transporteList[i].preco!;
        }
      }

      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth && lazerList[i].anoAtual == selectedYear) {
          gastoTotal += lazerList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Alimentação") {
      for (int i = 0; i < alimentacaoList.length; i++) {
        if (alimentacaoList[i].mesAtual == selectedMonth && alimentacaoList[i].anoAtual == selectedYear) {
          gastoTotal += alimentacaoList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Transporte") {
      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth && transporteList[i].anoAtual == selectedYear) {
          gastoTotal += transporteList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Lazer") {
      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth && lazerList[i].anoAtual == selectedYear) {
          gastoTotal += lazerList[i].preco!;
        }
      }
    }

    print(gastoTotal);

    return gastoTotal;
  }

@override
  Future<void> onInit() async {
  //alimentacaoCollection = FirebaseFirestore.instance.collection('alimentacao');

  FirebaseAuth auth = FirebaseAuth.instance;
  String _userId = auth.currentUser!.uid;
  alimentacaoCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('alimentacao');

  await fetchAlimentacao();
    super.onInit();
  }

addAlimentacao(){
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;
    alimentacaoCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('alimentacao');

    DateTime now = DateTime.now();
    int month = now.month;
    int year = now.year;

    DocumentReference doc = alimentacaoCollection.doc();
    Alimentacao alimentacao = Alimentacao(
      id: doc.id,
      data: dateController.text,
      nome: alimentacaoNomeCtrl.text,
      preco: double.tryParse(alimentacaoPrecoCtrl.text),
      mesAtual: month,
      anoAtual: year
    );

    final alimentacaoJson = alimentacao.toJson();
    doc.set(alimentacaoJson);
    Get.snackbar('Sucess', 'Product added successfully', colorText: Colors.green);

    setValuesDefault();
    update();

  } catch (e) {
    Get.snackbar('Error', e.toString(), colorText: Colors.red);
  }
}

fetchAlimentacao() async{
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;

      final userDocRef = firestore.collection('usuario').doc(_userId);
      final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').orderBy('data', descending: true).get();

      final List<Alimentacao> retrievedAlimentacao =alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();

      //retrievedAlimentacao.sort((a, b) => (b.data ?? '').compareTo(a.data ?? '')); // Ordenar a lista

      alimentacaoList.clear();
      alimentacaoList.addAll(retrievedAlimentacao);

      alimentacaoListOriginal.clear();
      alimentacaoListOriginal.addAll(retrievedAlimentacao);




      // for(int i = 0; i < alimentacaoList.length; i++){
      //   DateTime suaData = DateFormat('yyyy-MM-dd').parse(alimentacaoList[i].data.toString());
      //   String dataFormatada = DateFormat('dd/MM/yyyy').format(suaData);
      //   alimentacaoList[i].data = dataFormatada;
      // }

    } catch(e){
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally{
      update();
    }
}

  fetchAlimentacaoDetalhes(String alimentacaoId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;

      final userDocRef = firestore.collection('usuario').doc(_userId);
      final alimentacaoDoc = await userDocRef.collection('alimentacao').doc(alimentacaoId).get();

      // Transformar o documento em um objeto Alimentacao e atualizar o estado
      final alimentacaoDetalhes = Alimentacao.fromJson(alimentacaoDoc.data() as Map<String, dynamic>);
      alimentacaoAtual = alimentacaoDetalhes;

      update(); // Notificar que o estado foi atualizado, o que faz com que o widget seja reconstruído

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }



  Future<double> buscaGasto() async {
  double gastoTotal = 0.0;

  FirebaseAuth auth = FirebaseAuth.instance;
  String _userId = auth.currentUser!.uid;
  final userDocRef = firestore.collection('usuario').doc(_userId);
  final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').get();

  final List<Alimentacao> retrievedAlimentacao =alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();

  alimentacaoList.clear();
  alimentacaoList.assignAll(retrievedAlimentacao);

  for(int i = 0; i < alimentacaoList.length; i++){
    gastoTotal += alimentacaoList[i].preco!;
  }

  return gastoTotal;
}

buscaPorNome() async{
  FirebaseAuth auth = FirebaseAuth.instance;
  String _userId = auth.currentUser!.uid;

  final userDocRef = firestore.collection('usuario').doc(_userId);
  final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').orderBy('nome').get();

  final List<Alimentacao> retrievedAlimentacao =alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();


  alimentacaoList.clear();
  alimentacaoList.assignAll(retrievedAlimentacao);

  String termoProcurado = alimentacaoSearchCtrl.text.toLowerCase();

  List<Alimentacao> filtradoPorNome = [];
  for(int i = 0; i< alimentacaoList.length; i++){

    String? nome = alimentacaoList[i].nome?.toLowerCase();
    nome?.contains(termoProcurado);
    filtradoPorNome.assign(nome as Alimentacao);
  }
}

// updateAlimentacao(String? id) async {
//
//     try {
//       DocumentReference doc = alimentacaoCollection.doc(id);
//       Alimentacao alimentacao = Alimentacao(
//         id: id,
//         data: dateController.text,
//         nome: alimentacaoNomeCtrl.text,
//         preco: double.tryParse(alimentacaoPrecoCtrl.text),
//       );
//
//       final alimentacaoJson = alimentacao.toJson();
//       doc.update(alimentacaoJson);
//       Get.snackbar('Sucess', 'Product updated successfully', colorText: Colors.green);
//
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     }
//   }

// deleteAlimentacao(String id) async{
//   try{
//     await alimentacaoCollection.doc(id).delete();
//     fetchAlimentacao();
//   } catch (e){
//     Get.snackbar('Error', e.toString(), colorText: Colors.red);
//   }
//
// }

  updateAlimentacao(String? id) async {
    try {
      DocumentReference doc = alimentacaoCollection.doc(id);
      Alimentacao alimentacao = Alimentacao(
        id: id,
        data: dateController.text,
        nome: alimentacaoNomeCtrl.text,
        preco: double.tryParse(alimentacaoPrecoCtrl.text),
      );

      final alimentacaoJson = alimentacao.toJson();
      await doc.update(alimentacaoJson);

      // Após a atualização, reordena a lista
      final ctrl = Get.find<AlimentacaoController>();
      ctrl.alimentacaoList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));

      Get.snackbar('Sucesso', 'Produto atualizado com sucesso', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Erro', e.toString(), colorText: Colors.red);
    }
  }


  Future<void> deleteAlimentacao(String id) async {
    try {
      await alimentacaoCollection.doc(id).delete();
      alimentacaoList.removeWhere((alimentacao) => alimentacao.id == id); // Remover da lista local
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }




  setValuesDefault(){
    dateController.clear();
    alimentacaoNomeCtrl.clear();
    alimentacaoPrecoCtrl.clear();

    update();
  }
}