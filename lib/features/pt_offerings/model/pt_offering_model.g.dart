// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_offering_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtOfferingImpl _$$PtOfferingImplFromJson(Map<String, dynamic> json) =>
    _$PtOfferingImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      totalSessions: (json['totalSessions'] as num).toInt(),
      trainerId: (json['trainerId'] as num?)?.toInt(),
      gymId: (json['gymId'] as num).toInt(),
      trainerName: json['trainerName'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$PtOfferingImplToJson(_$PtOfferingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'totalSessions': instance.totalSessions,
      'trainerId': instance.trainerId,
      'gymId': instance.gymId,
      'trainerName': instance.trainerName,
      'status': instance.status,
    };

_$CreatePtOfferingRequestImpl _$$CreatePtOfferingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePtOfferingRequestImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      totalSessions: (json['totalSessions'] as num).toInt(),
      trainerId: (json['trainerId'] as num).toInt(),
    );

Map<String, dynamic> _$$CreatePtOfferingRequestImplToJson(
        _$CreatePtOfferingRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'totalSessions': instance.totalSessions,
      'trainerId': instance.trainerId,
    };

_$PtOfferingsResponseImpl _$$PtOfferingsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtOfferingsResponseImpl(
      ptOfferings: (json['ptOfferings'] as List<dynamic>)
          .map((e) => PtOffering.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PtOfferingsResponseImplToJson(
        _$PtOfferingsResponseImpl instance) =>
    <String, dynamic>{
      'ptOfferings': instance.ptOfferings,
    };
