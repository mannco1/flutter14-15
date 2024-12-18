import 'package:flutter/cupertino.dart';
import 'package:pks/models/products.dart';
import 'package:pks/pages/favourite.dart';

import '../pages/cart.dart';
class GlobalData {
  List<Product> productItem = [];
  List<Product> favItem = [];
  List<Product> cartItem=[];
  FavouriteState? favouriteState;
  CartState? cartState;
  int indexofFavItems(Product itemCheck)
  {
    for (int i=0; i<favItem.length ; i++){
      if (favItem[i].id==itemCheck.id)
        {
          return i;
        }
    }
    return -1;
  }
  int indexofCartItems(Product itemCheck) {
    for (int i = 0; i < cartItem.length; i++) {
      if (cartItem[i].id == itemCheck.id) {
        return i;
      }
    }
    return -1;
  }
}