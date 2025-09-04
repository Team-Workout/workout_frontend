// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtContractImpl _$$PtContractImplFromJson(Map<String, dynamic> json) =>
    _$PtContractImpl(
      contractId: (json['contractId'] as num).toInt(),
      trainerName: json['trainerName'] as String,
      memberName: json['memberName'] as String,
      totalSessions: (json['totalSessions'] as num).toInt(),
      remainingSessions: (json['remainingSessions'] as num).toInt(),
      status: json['status'] as String,
      paymentDate: json['paymentDate'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$$PtContractImplToJson(_$PtContractImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'trainerName': instance.trainerName,
      'memberName': instance.memberName,
      'totalSessions': instance.totalSessions,
      'remainingSessions': instance.remainingSessions,
      'status': instance.status,
      'paymentDate': instance.paymentDate,
      'price': instance.price,
    };

_$PtContractResponseImpl _$$PtContractResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtContractResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => PtContract.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PtContractResponseImplToJson(
        _$PtContractResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageInfo': instance.pageInfo,
    };

_$PageInfoImpl _$$PageInfoImplFromJson(Map<String, dynamic> json) =>
    _$PageInfoImpl(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$$PageInfoImplToJson(_$PageInfoImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
