import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/alimentacao/alimentacao.dart';

class AlimentacaoController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference alimentacaoCollection;

  List<Alimentacao> alimentacaoList = [];
  List<Alimentacao> alimentacaoListOriginal = [];

  Alimentacao? alimentacaoAtual;

  TextEditingController alimentacaoNomeCtrl = TextEditingController();
  TextEditingController alimentacaoPrecoCtrl = TextEditingController();
  TextEditingController alimentacaoDataCtrl = TextEditingController();

  TextEditingController alimentacaoSearchCtrl = TextEditingController();

  TextEditingController dateController = TextEditingController();

@override
  Future<void> onInit() async {
  //alimentacaoCollection = FirebaseFirestore.instance.collection('alimentacao');

  alimentacaoCollection = FirebaseFirestore.instance.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl').collection('alimentacao');

  await fetchAlimentacao();
    super.onInit();
  }

addAlimentacao(){
  try {


    DocumentReference doc = alimentacaoCollection.doc();
    Alimentacao alimentacao = Alimentacao(
      id: doc.id,
      data: dateController.text,
      nome: alimentacaoNomeCtrl.text,
      preco: double.tryParse(alimentacaoPrecoCtrl.text),
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
      final userDocRef = firestore.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl');
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
      final userDocRef = firestore.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl');
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
  final userDocRef = firestore.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl');
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
  final userDocRef = firestore.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl');
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