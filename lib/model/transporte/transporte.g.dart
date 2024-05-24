// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transporte.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transporte _$TransporteFromJson(Map<String, dynamic> json) => Transporte(
      id: json['id'] as String?,
      data: json['data'] as String?,
      nome: json['nome'] as String?,
      preco: (json['preco'] as num?)?.toDouble(),
      mesAtual: json['mesAtual'] as int?,
      anoAtual: json['anoAtual'] as int?,
    );

Map<String, dynamic> _$TransporteToJson(Transporte instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'nome': instance.nome,
      'preco': instance.preco,
      'mesAtual': instance.mesAtual,
      'anoAtual': instance.anoAtual,
    };
