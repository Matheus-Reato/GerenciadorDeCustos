// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alimentacao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alimentacao _$AlimentacaoFromJson(Map<String, dynamic> json) => Alimentacao(
      id: json['id'] as String?,
      data: json['data'] as String?,
      nome: json['nome'] as String?,
      preco: (json['preco'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AlimentacaoToJson(Alimentacao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'nome': instance.nome,
      'preco': instance.preco,
    };
