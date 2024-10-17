import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/data_service.dart';
import 'login_page.dart';
import 'cart_page.dart';  

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final AuthService _authService = AuthService();
  final DataService dataService = DataService();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> cart = []; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // ฟังก์ชันโหลดรายการสินค้า
  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedProducts = await dataService.getProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  // ฟังก์ชันเพิ่มสินค้าในตะกร้า
  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      // ตรวจสอบว่ามีสินค้าอยู่ในตะกร้าแล้วหรือไม่
      final index = cart.indexWhere((item) => item['product']['id'] == product['id']);
      if (index != -1) {
        // ถ้ามีแล้วเพิ่มจำนวนสินค้า
        cart[index]['quantity'] += 1;
      } else {
        // ถ้าไม่มีให้เพิ่มสินค้าใหม่พร้อมตั้งจำนวนเป็น 1
        cart.add({'product': product, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['title']} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member - Dashboard"),
        backgroundColor: const Color(0xFFD8A7B8),  
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();  // ล็อกเอาท์
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
                ? const Center(child: Text('No products found.'))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,  
                      childAspectRatio: 0.65,  
                      crossAxisSpacing: 20,  
                      mainAxisSpacing: 20, 
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      // ตรวจสอบว่ามีรูปภาพหรือไม่
                      final imageUrl = product['image'] != null && product['image'].isNotEmpty
                          ? 'http://127.0.0.1:8090/api/files/up1rgxahkrzx2bs/${product['id']}/${product['image']}'
                          : null;

                      return Card(
                        color: const Color(0xFFF6E6E9), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (imageUrl != null)
                                AspectRatio(
                                  aspectRatio: 1,  
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                product['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF5D4037),  
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product['description'],  
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8D6E63),  
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'price: ฿${product['price']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,  
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart, color: Color(0xFFA1887F)),  
                                  onPressed: () {
                                    _addToCart(product);  
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFD8A7B8),  
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(cart: cart),  
                      ),
                    );
                  },
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.length}',  
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            const Text(
              'Cart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}