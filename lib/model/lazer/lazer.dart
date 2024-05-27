import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lazer.g.dart';

@JsonSerializable()
class Lazer {
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



  Lazer({
    this.id,
    required this.data,
    this.nome,
    this.preco,
    this.mesAtual,
    this.anoAtual,
  });

  factory Lazer.fromJson(Map<String, dynamic> json) => _$LazerFromJson(json);
  Map<String, dynamic> toJson() => _$LazerToJson(this);
}