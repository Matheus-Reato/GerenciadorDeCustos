import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'alimentacao.g.dart';

@JsonSerializable()
class Alimentacao {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "data")
  String? data;

  @JsonKey(name: "nome")
  String? nome;

  @JsonKey(name: "preco")
  double? preco;

  @JsonKey(name: "mesAtual")
  int? mesAtual;

  @JsonKey(name: "anoAtual")
  int? anoAtual;



  Alimentacao({
    this.id,
    required this.data,
    this.nome,
    this.preco,
    this.mesAtual,
    this.anoAtual,
  });

  factory Alimentacao.fromJson(Map<String, dynamic> json) => _$AlimentacaoFromJson(json);
  Map<String, dynamic> toJson() => _$AlimentacaoToJson(this);
}