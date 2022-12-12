import 'package:get/get.dart';
import 'package:uasppb_2019130006/model/product_model.dart';
import 'package:uasppb_2019130006/services/firestore_db.dart';

class ProductController extends GetxController {
  //Add a list of product objects.
  // 1. making observable

  final products = <Product>[].obs;

// get all product function
  @override
  void onInit() {
    products.refresh();
    products.bindStream(FirestoreDB().getAllProducts());
    super.onInit();
  }
}
