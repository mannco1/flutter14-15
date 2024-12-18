import 'package:flutter/material.dart';
import '../components/api_service.dart';
import '../components/auth_service.dart';
import '../models/products.dart';
import '../models/user_model.dart';
import 'item_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService apiService = ApiService();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  Set<int> favoriteProductIds = {};
  bool isLoading = true;
  String searchQuery = '';
  bool isSearchByName = true;
  String sortOrder = 'По возрастанию';
  late Future<User> user;
  late int userId;

  @override
  void initState() {
    super.initState();

    user = ApiService().getUserByEmail(AuthService().getCurrentUserEmail());
    user.then((currentUser) {
      setState(() {
        userId = currentUser.id;
      });
      fetchProducts();
      fetchFavorites();
    }).catchError((e) {
      debugPrint("Error fetching user: $e");
    });
  }

  Future<void> fetchProducts() async {
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        allProducts = products;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки товаров: $e')),
      );
    }
  }

  Future<void> fetchFavorites() async {
    try {
      List<Product> favoriteProducts = await apiService.getFavorites(userId);
      setState(() {
        favoriteProductIds =
            favoriteProducts.map((product) => product.id).toSet();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      if (favoriteProductIds.contains(product.id)) {
        await apiService.removeFromFavorites(product.id, userId);
        setState(() {
          favoriteProductIds.remove(product.id);
        });
      } else {
        await apiService.addToFavorites(product.id, userId);
        setState(() {
          favoriteProductIds.add(product.id);
        });
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  void filterProducts(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = allProducts.where((product) {
        if (isSearchByName) {
          return product.Name.toLowerCase().contains(query.toLowerCase());
        } else {
          return product.Description.toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
    });
  }

  void sortProductsByPrice(String order) {
    setState(() {
      sortOrder = order;
      filteredProducts.sort((a, b) {
        final aPrice = a.Price ?? 0;
        final bPrice = b.Price ?? 0;
        return order == 'По возрастанию'
            ? aPrice.compareTo(bPrice)
            : bPrice.compareTo(aPrice);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск товаров'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Поиск',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: filterProducts,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Поиск по:'),
                    const SizedBox(width: 10),
                    DropdownButton<bool>(
                      value: isSearchByName,
                      items: const [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Названию'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Описанию'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          isSearchByName = value!;
                          filterProducts(searchQuery);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Сортировка:'),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: sortOrder,
                      items: const [
                        DropdownMenuItem(
                          value: 'По возрастанию',
                          child: Text('По возрастанию'),
                        ),
                        DropdownMenuItem(
                          value: 'По убыванию',
                          child: Text('По убыванию'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          sortProductsByPrice(value);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('Товары не найдены'))
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final isFavorite = favoriteProductIds.contains(product.id);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ItemView(productItem: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                product.img,
                                fit: BoxFit.fill,
                                height: 100,
                                width:double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.Name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.Price != null
                                        ? '${product.Price} ₽'
                                        : 'Цена не указана',
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: () => toggleFavorite(product),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
