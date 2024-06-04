import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/alimentacao/alimentacao.dart';
import '../model/lazer/lazer.dart';
import '../model/transporte/transporte.dart';

class TransporteController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference transporteCollection;

  List<Transporte> transporteList = [];

  List<Transporte> transporteListOriginal = [];

  Transporte? transporteAtual;

  TextEditingController transporteNomeCtrl = TextEditingController();
  TextEditingController transportePrecoCtrl = TextEditingController();
  TextEditingController transporteDataCtrl = TextEditingController();

  TextEditingController transporteSearchCtrl = TextEditingController();

  TextEditingController dateController = TextEditingController();

  int? selectedMonthTransporte;

  var mesPadrao = 'Todos'.obs;

  void setSelectedMonthTransporte(String? monthName) {
    mesPadrao.value = monthName ?? 'Todos';

    final Map<String, int> monthsMap = {
      'Todos': 0,
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


    selectedMonthTransporte = monthsMap[monthName];

    fetchTransporte();
  }

  @override
  Future<void> onInit() async {
    //alimentacaoCollection = FirebaseFirestore.instance.collection('alimentacao');

    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;
    transporteCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('transporte');

    await fetchTransporte();
    super.onInit();
  }

  addTransporte(){
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      transporteCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('transporte');

      String dateString = dateController.text;
      DateTime parsedDate = DateTime.parse(dateString);
      int month = parsedDate.month;
      int year = parsedDate.year;


      DocumentReference doc = transporteCollection.doc();
      Transporte transporte = Transporte(
          id: doc.id,
          data: dateController.text,
          nome: transporteNomeCtrl.text,
          preco: double.tryParse(transportePrecoCtrl.text.replaceAll(',', '.')),
          mesAtual: month,
          anoAtual: year
      );

      final transporteJson = transporte.toJson();
      doc.set(transporteJson);
      Get.snackbar('Sucess', 'Product added successfully', colorText: Colors.green);

      setValuesDefault();
      update();

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> fetchTransporte() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      final userDocRef = firestore.collection('usuario').doc(_userId);
      QuerySnapshot transporteSnapshot;

      DateTime now = DateTime.now();
      int currentYear = now.year;

      if (selectedMonthTransporte == 0 || selectedMonthTransporte == null) {
        transporteSnapshot = await userDocRef.collection('transporte')
            .orderBy('data', descending: true).get();
      } else {
        transporteSnapshot = await userDocRef.collection('transporte')
            .where('mesAtual', isEqualTo: selectedMonthTransporte)
            .where('anoAtual', isEqualTo: currentYear)
            .orderBy('data', descending: true).get();
      }

      final List<Transporte> retrievedTransporte = transporteSnapshot.docs
          .map((doc) => Transporte.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      transporteList.clear();
      transporteList.addAll(retrievedTransporte);

      transporteListOriginal.clear();
      transporteListOriginal.addAll(retrievedTransporte);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally {
      update();
    }
  }

  fetchTransporteDetalhes(String transporteId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;

      final userDocRef = firestore.collection('usuario').doc(_userId);
      final transporteDoc = await userDocRef.collection('transporte').doc(transporteId).get();

      // Transformar o documento em um objeto Alimentacao e atualizar o estado
      final transporteDetalhes = Transporte.fromJson(transporteDoc.data() as Map<String, dynamic>);
      transporteAtual = transporteDetalhes;

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
    final QuerySnapshot transporteSnapshot = await userDocRef.collection('transporte').get();

    DateTime now = DateTime.now();
    int currentYear = now.year;

    final List<Transporte> retrievedTransporte = transporteSnapshot.docs.map((doc) => Transporte.fromJson(doc.data() as Map<String, dynamic>)).toList();

    transporteList.clear();
    transporteList.assignAll(retrievedTransporte);

    if(selectedMonthTransporte == null || selectedMonthTransporte == 0){
      for(int i = 0; i < transporteList.length; i++){
        gastoTotal += transporteList[i].preco!;
      }
    } else{
      for(int i = 0; i < transporteList.length; i++){
        if(transporteList[i].mesAtual == selectedMonthTransporte && transporteList[i].anoAtual == currentYear){
          gastoTotal += transporteList[i].preco!;
        }
      }
    }

    return gastoTotal;
  }

  buscaPorNome() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;

    final userDocRef = firestore.collection('usuario').doc(_userId);
    final QuerySnapshot transporteSnapshot = await userDocRef.collection('transporte').orderBy('nome').get();

    final List<Transporte> retrievedTransporte = transporteSnapshot.docs.map((doc) => Transporte.fromJson(doc.data() as Map<String, dynamic>)).toList();


    transporteList.clear();
    transporteList.assignAll(retrievedTransporte);

    String termoProcurado = transporteSearchCtrl.text.toLowerCase();

    List<Transporte> filtradoPorNome = [];
    for(int i = 0; i< transporteList.length; i++){

      String? nome = transporteList[i].nome?.toLowerCase();
      nome?.contains(termoProcurado);
      filtradoPorNome.assign(nome as Transporte);
    }
  }

  updateTransporte(String? id) async {
    try {
      String dateString = dateController.text;
      DateTime parsedDate = DateTime.parse(dateString);
      int month = parsedDate.month;
      int year = parsedDate.year;

      DocumentReference doc = transporteCollection.doc(id);
      Transporte transporte = Transporte(
          id: doc.id,
          data: dateController.text,
          nome: transporteNomeCtrl.text,
          preco: double.tryParse(transportePrecoCtrl.text.replaceAll(',', '.')),
          mesAtual: month,
          anoAtual: year
      );

      final transporteJson = transporte.toJson();
      await doc.update(transporteJson);

      // Após a atualização, reordena a lista
      final ctrl = Get.find<TransporteController>();
      ctrl.transporteList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));

      Get.snackbar('Sucesso', 'Produto atualizado com sucesso', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Erro', e.toString(), colorText: Colors.red);
    }
  }


  Future<void> deleteTransporte(String id) async {
    try {
      await transporteCollection.doc(id).delete();
      transporteList.removeWhere((transporte) => transporte.id == id); // Remover da lista local
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  setValuesDefault(){
    dateController.clear();
    transporteNomeCtrl.clear();
    transportePrecoCtrl.clear();

    update();
  }
}