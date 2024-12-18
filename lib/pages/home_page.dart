import 'package:flutter/material.dart';
import 'package:pks/models/products.dart';
import 'package:pks/components/api_service.dart';
import 'package:pks/pages/add_product.dart';
import 'package:pks/pages/search_page.dart';
import '../components/card_prew.dart';
import '../main.dart';
import 'item_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Product> productItem = [];
  final ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProductItem();
  }

  void addItem(Product item) async {
    try {
      await apiService.createProduct(item);
      loadProductItem();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
    loadProductItem();
  }

  Future<void> _confirmDismiss(BuildContext context, int index) async {
    final bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить товар?'),
          content: Text('Вы точно хотите удалить этот товар?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Нет'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Да'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      try {
        await apiService.deleteProduct(productItem[index].id);
        setState(() {
          productItem.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Товар удалён')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении товара: $e')),
        );
      }
    }
  }

  Future<void> loadProductItem() async {
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        productItem = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при загрузке данных: $e')),
      );
    }
  }

  void editItem(Product item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItem(
          homeState: this,
          editingProduct: item,
        ),
      ),
    ).then((_) {
      loadProductItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.05 / 1),
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemCount: productItem.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(productItem[index].Name),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                await _confirmDismiss(context, index);
                return false;
              },
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete_forever_outlined, color: Colors.white),
              ),
              child: GestureDetector(
                child: CardPreview(
                  productItem: productItem[index],
                  isFavorite: appData.indexofFavItems(productItem[index]) != -1,
                  onEdit: () => editItem(productItem[index]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemView(productItem: productItem[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem(homeState: this)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
