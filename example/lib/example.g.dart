// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  int? count;
  if (json['count'] != null) {
    final dynamic value = json['count'];
    count = value is int
        ? value
        : value is double
            ? value.toInt()
            : value is String
                ? int.parse(value)
                : null;
  }
  int? itemNumber;
  if (json['itemNumber'] != null) {
    final dynamic value = json['itemNumber'];
    itemNumber = value is int
        ? value
        : value is double
            ? value.toInt()
            : value is String
                ? int.parse(value)
                : null;
  }
  bool? isRushed;
  if (json['isRushed'] != null) {
    final dynamic value = json['isRushed'];
    isRushed = value is bool
        ? value
        : value is String
            ? value.toLowerCase() == 'true' || value.toLowerCase() == 'yes'
            : null;
  }
  String? name;
  if (json['name'] != null) {
    final dynamic value = json['name'];
    name = value is String ? value : value.toString();
  }
  return Item()
    ..count = count
    ..itemNumber = itemNumber
    ..isRushed = isRushed
    ..name = name;
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'count': instance.count,
      'itemNumber': instance.itemNumber,
      'isRushed': instance.isRushed,
      'name': instance.name,
    };
