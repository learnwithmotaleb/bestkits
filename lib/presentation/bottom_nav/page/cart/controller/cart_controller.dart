import 'package:get/get.dart';
import '../../../../../utils/assets_image/app_images.dart';


class CartItem {
  final String name;
  final String image;
  final String category;
  final String price;
  final String oldPrice;
  final String seller;
  RxString selectedSize;
  RxInt quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.seller,
    String size = 'S',
    int qty = 1,
  })  : selectedSize = size.obs,
        quantity = qty.obs;
}

class CartController extends GetxController {
  // Group items by seller
  final RxList<CartItem> cartItems = <CartItem>[
    CartItem(
      name: 'Kolev and Kolev – Soft Fit',
      image: AppImages.kidsCottonSho,
      category: 'kids sneakers',
      price: '260.00',
      oldPrice: '21.99',
      seller: 'Mayoral Reseller',
    ),
    CartItem(
      name: 'D.D. Step – Comfort',
      image: AppImages.kidCottonShoStand,
      category: 'kids sneakers',
      price: '260.00',
      oldPrice: '23.99',
      seller: 'Mayoral Reseller',
    ),
    CartItem(
      name: 'Kids Cotton Hoodie – Soft Fit',
      image: AppImages.kidsCottonHoodie,
      category: 'kids sneakers',
      price: '260.00',
      oldPrice: '23.99',
      seller: 'Tochici Clothing',
    ),
  ].obs;

  // Get unique sellers
  List<String> get sellers =>
      cartItems.map((e) => e.seller).toSet().toList();

  // Get items by seller
  List<CartItem> itemsBySeller(String seller) =>
      cartItems.where((e) => e.seller == seller).toList();

  int get totalItemCount => cartItems.length;

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (double.parse(item.price) * item.quantity.value));

  double get shippingFee => 60.00;

  double get total => subtotal + shippingFee;

  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  void emptyCart() {
    cartItems.clear();
  }

  void incrementQty(CartItem item) => item.quantity.value++;
  void decrementQty(CartItem item) {
    if (item.quantity.value > 1) item.quantity.value--;
  }
}