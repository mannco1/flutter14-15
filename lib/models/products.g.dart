// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['product_id'] as num).toInt(),
      json['name'] as String,
      json['description'] as String,
      (json['price'] as num).toInt(),
      json['image_url'] as String,
    (json['stock'] as num).toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.id,
      'name': instance.Name,
      'description': instance.Description,
      'price': instance.Price,
      'image_url': instance.img,
      'stock': instance.stock,
    };
