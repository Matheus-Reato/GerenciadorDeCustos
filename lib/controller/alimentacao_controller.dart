import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/alimentacao/alimentacao.dart';

class AlimentacaoController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference alimentacaoCollection;

  List<Alimentacao> alimentacaoList = [];

  TextEditingController alimentacaoNomeCtrl = TextEditingController();
  TextEditingController alimentacaoPrecoCtrl = TextEditingController();
  TextEditingController alimentacaoDataCtrl = TextEditingController();

@override
  Future<void> onInit() async{
  //alimentacaoCollection = FirebaseFirestore.instance.collection('alimentacao');

  alimentacaoCollection = FirebaseFirestore.instance.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl').collection('alimentacao');
  await fetchAlimentacao();
    super.onInit();
  }

// addAlimentacao(){
//   DocumentReference doc = alimentacaoCollection.doc();
//   Alimentacao alimentacao = Alimentacao(
//     id: doc.id,
//     nome: alimentacaoNomeCtrl.text,
//     preco: double.tryParse(alimentacaoPrecoCtrl.text),
//     data: alimentacaoDataCtrl.text,
//   );
// }

fetchAlimentacao() async{
    try{
      final userDocRef = firestore.collection('usuario').doc('OhiJeZfpyl76qvqcyRtl');
      final QuerySnapshot alimentacaoSnapshot = await userDocRef.collection('alimentacao').get();

      final List<Alimentacao> retrievedAlimentacao =alimentacaoSnapshot.docs.map((doc) => Alimentacao.fromJson(doc.data() as Map<String, dynamic>)).toList();

      alimentacaoList.clear();
      alimentacaoList.assignAll(retrievedAlimentacao);

      Get.snackbar('Sucess', 'Product fetch successfully', colorText: Colors.green);

    } catch(e){
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally{
      update();
    }
}
}