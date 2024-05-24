import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transporte.g.dart';

@JsonSerializable()
class Transporte {
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



  Transporte({
    this.id,
    required this.data,
    this.nome,
    this.preco,
    this.mesAtual,
    this.anoAtual,
  });

  factory Transporte.fromJson(Map<String, dynamic> json) => _$TransporteFromJson(json);
  Map<String, dynamic> toJson() => _$TransporteToJson(this);
}