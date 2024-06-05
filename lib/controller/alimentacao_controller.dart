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

  int? selectedMonthAlimentacao;

  var mesPadrao = 'Todos'.obs;

  void setSelectedMonthAlimentacao(String? monthName) {
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


    selectedMonthAlimentacao = monthsMap[monthName];

    fetchAlimentacao();
  }

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

    double filtroGastoTotal = 0.0;

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
          filtroGastoTotal += alimentacaoList[i].preco!;
        }
      }

      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth && transporteList[i].anoAtual == selectedYear) {
          filtroGastoTotal += transporteList[i].preco!;
        }
      }

      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth && lazerList[i].anoAtual == selectedYear) {
          filtroGastoTotal += lazerList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Alimentação") {
      for (int i = 0; i < alimentacaoList.length; i++) {
        if (alimentacaoList[i].mesAtual == selectedMonth && alimentacaoList[i].anoAtual == selectedYear) {
          filtroGastoTotal += alimentacaoList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Transporte") {
      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth && transporteList[i].anoAtual == selectedYear) {
          filtroGastoTotal += transporteList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Lazer") {
      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth && lazerList[i].anoAtual == selectedYear) {
          filtroGastoTotal += lazerList[i].preco!;
        }
      }
    }

    return filtroGastoTotal;
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

    String dateString = dateController.text;
    DateTime parsedDate = DateTime.parse(dateString);
    int month = parsedDate.month;
    int year = parsedDate.year;


    DocumentReference doc = alimentacaoCollection.doc();
    Alimentacao alimentacao = Alimentacao(
      id: doc.id,
      data: dateController.text,
      nome: alimentacaoNomeCtrl.text,
      preco: double.tryParse(alimentacaoPrecoCtrl.text.replaceAll(',', '.')),
      mesAtual: month,
      anoAtual: year
    );

    final alimentacaoJson = alimentacao.toJson();
    doc.set(alimentacaoJson);
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

  Future<void> fetchAlimentacao() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String _userId = auth.currentUser!.uid;
      final userDocRef = firestore.collection('usuario').doc(_userId);
      QuerySnapshot alimentacaoSnapshot;

      DateTime now = DateTime.now();
      int currentYear = now.year;

      if (selectedMonthAlimentacao == 0 || selectedMonthAlimentacao == null) {
        alimentacaoSnapshot = await userDocRef.collection('alimentacao')
            .orderBy('data', descending: true).get();
      } else {
        alimentacaoSnapshot = await userDocRef.collection('alimentacao')
            .where('mesAtual', isEqualTo: selectedMonthAlimentacao)
            .where('anoAtual', isEqualTo: currentYear)
            .orderBy('data', descending: true).get();
      }

      final List<Alimentacao> retrievedAlimentacao = alimentacaoSnapshot.docs
          .map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      alimentacaoList.clear();
      alimentacaoList.addAll(retrievedAlimentacao);

      alimentacaoListOriginal.clear();
      alimentacaoListOriginal.addAll(retrievedAlimentacao);
    } catch (e) {
     avisoErroPadrao(e);
    } finally {
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
      avisoErroPadrao(e);
    }
  }

  Future<double> buscaGasto() async {
  double gastoTotal = 0.0;

  FirebaseAuth auth = FirebaseAuth.instance;
  String _userId = auth.currentUser!.uid;
  final userDocRef = firestore.collection('usuario').doc(_userId);
  final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').get();

  DateTime now = DateTime.now();
  int currentYear = now.year;

  final List<Alimentacao> retrievedAlimentacao =alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();

  alimentacaoList.clear();
  alimentacaoList.assignAll(retrievedAlimentacao);

  if(selectedMonthAlimentacao == null || selectedMonthAlimentacao == 0){
    for(int i = 0; i < alimentacaoList.length; i++){
      gastoTotal += alimentacaoList[i].preco!;
    }
  } else{
    for(int i = 0; i < alimentacaoList.length; i++){
      if(alimentacaoList[i].mesAtual == selectedMonthAlimentacao && alimentacaoList[i].anoAtual == currentYear){
        gastoTotal += alimentacaoList[i].preco!;
      }
    }
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

  updateAlimentacao(String? id) async {
    try {
      String dateString = dateController.text;
      DateTime parsedDate = DateTime.parse(dateString);
      int month = parsedDate.month;
      int year = parsedDate.year;

      DocumentReference doc = alimentacaoCollection.doc(id);
      Alimentacao alimentacao = Alimentacao(
          id: doc.id,
          data: dateController.text,
          nome: alimentacaoNomeCtrl.text,
          preco: double.tryParse(alimentacaoPrecoCtrl.text.replaceAll(',', '.')),
          mesAtual: month,
          anoAtual: year
      );

      final alimentacaoJson = alimentacao.toJson();
      await doc.update(alimentacaoJson);

      // Após a atualização, reordena a lista
      final ctrl = Get.find<AlimentacaoController>();
      ctrl.alimentacaoList.sort((a, b) => (b.data ?? '').compareTo(a.data ?? ''));

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


  Future<void> deleteAlimentacao(String id) async {
    try {
      await alimentacaoCollection.doc(id).delete();
      alimentacaoList.removeWhere((alimentacao) => alimentacao.id == id); // Remover da lista local
    } catch (e) {
      avisoErroPadrao(e);
    }
  }

  setValuesDefault(){
    dateController.clear();
    alimentacaoNomeCtrl.clear();
    alimentacaoPrecoCtrl.clear();

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