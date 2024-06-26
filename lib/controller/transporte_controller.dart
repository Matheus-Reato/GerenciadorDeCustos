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

      Get.snackbar(
        '', // Título vazio porque estamos usando `titleText` personalizado
        '',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        icon: Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        titleText: Text(
          'Sucesso',
          style: TextStyle(
            fontSize: 20, // Tamanho da fonte do título
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Produto cadastrado com sucesso',
          style: TextStyle(
            fontSize: 16, // Tamanho da fonte da mensagem
            color: Colors.white,
          ),
        ),
      );

      setValuesDefault();
      update();

    } catch (e) {
      avisoErroPadrao(e);
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
      avisoErroPadrao(e);
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
      avisoErroPadrao(e);
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

      Get.snackbar(
        '', // Título vazio porque estamos usando `titleText` personalizado
        '',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        icon: Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        titleText: Text(
          'Sucesso',
          style: TextStyle(
            fontSize: 20, // Tamanho da fonte do título
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Produto atualizado com sucesso',
          style: TextStyle(
            fontSize: 16, // Tamanho da fonte da mensagem
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      avisoErroPadrao(e);
    }
  }


  Future<void> deleteTransporte(String id) async {
    try {
      await transporteCollection.doc(id).delete();
      transporteList.removeWhere((transporte) => transporte.id == id); // Remover da lista local
    } catch (e) {
      avisoErroPadrao(e);
    }
  }

  setValuesDefault(){
    dateController.clear();
    transporteNomeCtrl.clear();
    transportePrecoCtrl.clear();

    update();
  }
}

avisoErroPadrao(e){
  Get.snackbar(
      '',
      '',
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
      titleText: Text(
        'Erro',
        style: TextStyle(
          fontSize: 20, // Tamanho da fonte do título
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
          e.toString(),
          style: TextStyle(
            fontSize: 16, // Tamanho da fonte da mensagem
            color: Colors.white,
          )
      )
  );
}