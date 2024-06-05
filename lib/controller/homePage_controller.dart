import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/alimentacao/alimentacao.dart';
import '../model/lazer/lazer.dart';
import '../model/transporte/transporte.dart';

class HomePageController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Alimentacao> alimentacaoList = [];
  List<Transporte> transporteList = [];
  List<Lazer> lazerList = [];

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

    final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection(
        'alimentacao').get();
    final List<Alimentacao> retrievedAlimentacao = alimentacaoSnapshot.docs
        .map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    alimentacaoList.clear();
    alimentacaoList.assignAll(retrievedAlimentacao);

    final QuerySnapshot transporteSnapshot = await userDocRef.collection(
        'transporte').get();
    final List<Transporte> retrievedTransporte = transporteSnapshot.docs.map((
        doc) => Transporte.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    transporteList.clear();
    transporteList.assignAll(retrievedTransporte);

    final QuerySnapshot lazerSnapshot = await userDocRef.collection('lazer')
        .get();
    final List<Lazer> retrievedLazer = lazerSnapshot.docs.map((doc) =>
        Lazer.fromJson(doc.data() as Map<String, dynamic>)).toList();
    lazerList.clear();
    lazerList.assignAll(retrievedLazer);


    if (selectedModalidade == "Todos") {
      for (int i = 0; i < alimentacaoList.length; i++) {
        if (alimentacaoList[i].mesAtual == selectedMonth &&
            alimentacaoList[i].anoAtual == selectedYear) {
          filtroGastoTotal += alimentacaoList[i].preco!;
        }
      }

      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth &&
            transporteList[i].anoAtual == selectedYear) {
          filtroGastoTotal += transporteList[i].preco!;
        }
      }

      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth &&
            lazerList[i].anoAtual == selectedYear) {
          filtroGastoTotal += lazerList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Alimentação") {
      for (int i = 0; i < alimentacaoList.length; i++) {
        if (alimentacaoList[i].mesAtual == selectedMonth &&
            alimentacaoList[i].anoAtual == selectedYear) {
          filtroGastoTotal += alimentacaoList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Transporte") {
      for (int i = 0; i < transporteList.length; i++) {
        if (transporteList[i].mesAtual == selectedMonth &&
            transporteList[i].anoAtual == selectedYear) {
          filtroGastoTotal += transporteList[i].preco!;
        }
      }
    }

    if (selectedModalidade == "Lazer") {
      for (int i = 0; i < lazerList.length; i++) {
        if (lazerList[i].mesAtual == selectedMonth &&
            lazerList[i].anoAtual == selectedYear) {
          filtroGastoTotal += lazerList[i].preco!;
        }
      }
    }

    return filtroGastoTotal;
  }

  @override
  Future<void> onInit() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String _userId = auth.currentUser!.uid;

    super.onInit();
  }
}