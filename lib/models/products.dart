import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class Product {
  Product(this.id, this.Name, this.Description,  this.Price, this.img, this.stock);
  int id;
  String Name;
  String Description;
  int? Price;
  String img;
  int stock;
  bool isImageUrl=true;
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
