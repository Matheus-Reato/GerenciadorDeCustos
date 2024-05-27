// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lazer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lazer _$LazerFromJson(Map<String, dynamic> json) => Lazer(
      id: json['id'] as String?,
      data: json['data'] as String?,
      nome: json['nome'] as String?,
      preco: (json['preco'] as num?)?.toDouble(),
      mesAtual: json['mesAtual'] as int?,
      anoAtual: json['anoAtual'] as int?,
    );

Map<String, dynamic> _$LazerToJson(Lazer instance) => <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'nome': instance.nome,
      'preco': instance.preco,
      'mesAtual': instance.mesAtual,
      'anoAtual': instance.anoAtual,
    };
