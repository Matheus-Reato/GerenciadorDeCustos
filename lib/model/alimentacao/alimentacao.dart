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



  Alimentacao({
    this.id,
    this.data,
    this.nome,
    this.preco,
  });

  factory Alimentacao.fromJson(Map<String, dynamic> json) => _$AlimentacaoFromJson(json);
  Map<String, dynamic> toJson() => _$AlimentacaoToJson(this);
}