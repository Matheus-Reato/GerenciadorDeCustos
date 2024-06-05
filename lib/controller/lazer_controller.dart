import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/alimentacao/alimentacao.dart';
import '../model/lazer/lazer.dart';
import '../model/transporte/transporte.dart';

class LazerController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference lazerCollection;

  List<Lazer> lazerList = [];

  List<Lazer> lazerListOriginal = [];

  Lazer? lazerAtual;

  TextEditingController lazerNomeCtrl = TextEditingController();
  TextEditingController lazerPrecoCtrl = TextEditingController();
  TextEditingController lazerDataCtrl = TextEditingController();

  TextEditingController lazerSearchCtrl = TextEditingController();

  TextEditingController dateController = TextEditingController();

  int? selectedMonthLazer;

  var mesPadrao = 'Todos'.obs;

  void setSelectedMonthLazer(String? monthName) {
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


    selectedMonthLazer = monthsMap[monthName];

    fetchLazer();
  }

  @override
  Future<void> onInit() async {
    //alimentacaoCollection = FirebaseFirestore.instance.collection('alimentacao');

    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;
    lazerCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('lazer');

    await fetchLazer();
    super.onInit();
  }

  addLazer(){
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      lazerCollection = FirebaseFirestore.instance.collection('usuario').doc(_userId).collection('lazer');

      String dateString = dateController.text;
      DateTime parsedDate = DateTime.parse(dateString);
      int month = parsedDate.month;
      int year = parsedDate.year;


      DocumentReference doc = lazerCollection.doc();
      Lazer lazer = Lazer(
          id: doc.id,
          data: dateController.text,
          nome: lazerNomeCtrl.text,
          preco: double.tryParse(lazerPrecoCtrl.text.replaceAll(',', '.')),
          mesAtual: month,
          anoAtual: year
      );

      final lazerJson = lazer.toJson();
      doc.set(lazerJson);

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

  Future<void> fetchLazer() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      final userDocRef = firestore.collection('usuario').doc(_userId);
      QuerySnapshot lazerSnapshot;

      DateTime now = DateTime.now();
      int currentYear = now.year;

      if (selectedMonthLazer == 0 || selectedMonthLazer == null) {
        lazerSnapshot = await userDocRef.collection('lazer')
            .orderBy('data', descending: true).get();
      } else {
        lazerSnapshot = await userDocRef.collection('lazer')
            .where('mesAtual', isEqualTo: selectedMonthLazer)
            .where('anoAtual', isEqualTo: currentYear)
            .orderBy('data', descending: true).get();
      }

      final List<Lazer> retrievedLazer = lazerSnapshot.docs
          .map((doc) => Lazer.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      lazerList.clear();
      lazerList.addAll(retrievedLazer);

      lazerListOriginal.clear();
      lazerListOriginal.addAll(retrievedLazer);
    } catch (e) {
      avisoErroPadrao(e);
    } finally {
      update();
    }
  }

  fetchLazerDetalhes(String lazerId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;

      final userDocRef = firestore.collection('usuario').doc(_userId);
      final lazerDoc = await userDocRef.collection('lazer').doc(lazerId).get();

      // Transformar o documento em um objeto Alimentacao e atualizar o estado
      final lazerDetalhes = Lazer.fromJson(lazerDoc.data() as Map<String, dynamic>);
      lazerAtual = lazerDetalhes;

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
    final QuerySnapshot lazerSnapshot = await userDocRef.collection('lazer').get();

    DateTime now = DateTime.now();
    int currentYear = now.year;

    final List<Lazer> retrievedLazer = lazerSnapshot.docs.map((doc) => Lazer.fromJson(doc.data() as Map<String, dynamic>)).toList();

    lazerList.clear();
    lazerList.assignAll(retrievedLazer);

    if(selectedMonthLazer == null || selectedMonthLazer == 0){
      for(int i = 0; i < lazerList.length; i++){
        gastoTotal += lazerList[i].preco!;
      }
    } else{
      for(int i = 0; i < lazerList.length; i++){
        if(lazerList[i].mesAtual == selectedMonthLazer && lazerList[i].anoAtual == currentYear){
          gastoTotal += lazerList[i].preco!;
        }
      }
    }

    return gastoTotal;
  }

  buscaPorNome() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;

    final userDocRef = firestore.collection('usuario').doc(_userId);
    final QuerySnapshot lazerSnapshot = await userDocRef.collection('lazer').orderBy('nome').get();

    final List<Lazer> retrievedLazer = lazerSnapshot.docs.map((doc) => Lazer.fromJson(doc.data() as Map<String, dynamic>)).toList();


    lazerList.clear();
    lazerList.assignAll(retrievedLazer);

    String termoProcurado = lazerSearchCtrl.text.toLowerCase();

    List<Lazer> filtradoPorNome = [];
    for(int i = 0; i< lazerList.length; i++){

      String? nome = lazerList[i].nome?.toLowerCase();
      nome?.contains(termoProcurado);
      filtradoPorNome.assign(nome as Lazer);
    }
  }

  updateLazer(String? id) async {
    try {
      String dateString = dateController.text;
      DateTime parsedDate = DateTime.parse(dateString);
      int month = parsedDate.month;
      int year = parsedDate.year;

      DocumentReference doc = lazerCollection.doc(id);
      Lazer lazer = Lazer(
          id: doc.id,
          data: dateController.text,
          nome: lazerNomeCtrl.text,
          preco: double.tryParse(lazerPrecoCtrl.text.replaceAll(',', '.')),
          mesAtual: month,
          anoAtual: year
      );

      final lazerJson = lazer.toJson();
      await doc.update(lazerJson);

      // Após a atualização, reordena a lista
      final ctrl = Get.find<LazerController>();
      ctrl.lazerList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));

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


  Future<void> deleteLazer(String id) async {
    try {
      await lazerCollection.doc(id).delete();
      lazerList.removeWhere((lazer) => lazer.id == id); // Remover da lista local
    } catch (e) {
      avisoErroPadrao(e);
    }
  }

  setValuesDefault(){
    dateController.clear();
    lazerNomeCtrl.clear();
    lazerPrecoCtrl.clear();

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