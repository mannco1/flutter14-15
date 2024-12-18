import 'package:pks/pages/item_list.dart';
import 'package:pks/models/products.dart';
import 'package:flutter/material.dart';
import '../components/api_service.dart';
import '../components/auth_service.dart';
import '../components/card_prew.dart';
import '../models/user_model.dart';


class Favourite extends StatefulWidget{
  const Favourite({super.key});
  @override
    createState()=> FavouriteState();
}
class FavouriteState extends State<Favourite> {
  List<Product> favouriteItems = [];
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
      _fetchFavorites();
    }).catchError((e) {
      debugPrint("Error fetching user: $e");
    });
  }

  Future<void> _fetchFavorites() async {
    try {
      ApiService apiService = ApiService();
      List<Product> products = await apiService.getFavorites(userId);
      setState(() {
        favouriteItems = products;
      });
    } catch (e) {
      debugPrint('Error fetching favorite items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: favouriteItems.isEmpty
            ? Center(child: Text("Тут пока ничего нет (⌐■_■)"))
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.05 / 1),
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemCount: favouriteItems.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: CardPreview(
                productItem: favouriteItems[index],
                isFavorite: true,
                onEdit: () {},
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ItemView(productItem: favouriteItems[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
