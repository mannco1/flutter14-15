import 'package:flutter/material.dart';
import 'package:pks/models/products.dart';
import 'package:pks/pages/home_page.dart';
import 'package:pks/components/api_service.dart';

class AddItem extends StatefulWidget {
  final HomePageState homeState;
  final Product? editingProduct;

  const AddItem({Key? key, required this.homeState, this.editingProduct}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController imageURLController;
  late TextEditingController priceController;
  late TextEditingController stockController;


  final ApiService apiService = ApiService();
  late bool isImageUrl;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.editingProduct?.Name ?? '');
    descriptionController = TextEditingController(text: widget.editingProduct?.Description ?? '');
    imageURLController = TextEditingController(text: widget.editingProduct?.img ?? '');
    priceController = TextEditingController(text: widget.editingProduct?.Price.toString() ?? '');
    isImageUrl = widget.editingProduct?.isImageUrl ?? true;
    stockController = TextEditingController(
        text: widget.editingProduct?.stock?.toString() ?? '0');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageURLController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  bool _isValidImageUrl(String url) {
    return Uri.parse(url).isAbsolute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editingProduct != null ? "Редактировать товар" : "Создать товар"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Название"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Описание"),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
            ),
            SizedBox(height: 10),
            TextField(
              controller: imageURLController,
              decoration: InputDecoration(labelText: "URL картинки"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Цена"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              child: Text(
                "Сохранить",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              onPressed: () async {

                String imageUrl = imageURLController.text;


                Product newItem = Product(
                  widget.editingProduct?.id ?? -1,
                  titleController.text,
                  descriptionController.text,
                  int.parse(priceController.text),
                  imageUrl,
                  int.parse(stockController.text),
                );
                newItem.isImageUrl = false;
                print("Данные для отправки: ${newItem.toJson()}");
                print("Title: ${titleController.text}");
                print("Description: ${descriptionController.text}");
                print("Image URL: ${imageURLController.text}");
                print("Price: ${priceController.text}");
                print("Stock: ${stockController.text}");

                if (widget.editingProduct == null) {
                  widget.homeState.addItem(newItem);
                } else {

                  try {
                    await apiService.updateProduct(widget.editingProduct!.id, newItem);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Товар обновлён")));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ошибка обновления товара")),
                    );
                  }
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
