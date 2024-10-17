import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/data_service.dart';
import 'login_page.dart';
import 'edit_product_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AuthService _authService = AuthService();
  final DataService dataService = DataService();
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  final String collectionId = 'up1rgxahkrzx2bs'; 

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

  // ฟังก์ชันยืนยันการลบสินค้า
  Future<void> _confirmDeleteProduct(String productId, String productTitle) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "$productTitle"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      try {
        await dataService.deleteProduct(productId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
        setState(() {
          products.removeWhere((item) => item['id'] == productId);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Dashboard"),
        backgroundColor: const Color(0xFFD8A7B8), 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
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
                ? const Center(child: Text('No products found.', style: TextStyle(fontSize: 16, color: Colors.grey)))
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
                          ? 'http://127.0.0.1:8090/api/files/$collectionId/${product['id']}/${product['image']}'
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Color(0xFF5D4037)),  
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProductPage(
                                            productId: product['id'],
                                            title: product['title'],
                                            description: product['description'],
                                            price: product['price'].toDouble(),
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadProducts();  
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),  
                                    onPressed: () => _confirmDeleteProduct(product['id'], product['title']),  
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      // ปุ่มเพิ่มสินค้าด้านล่าง
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8D6E63),  
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_product');
          if (result == true) {
            _loadProducts();  
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFD8A7B8),  
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
