import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;  // รายการสินค้าในตะกร้า

  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // ฟังก์ชันเพิ่มจำนวนสินค้า
  void _incrementQuantity(int index) {
    setState(() {
      widget.cart[index]['quantity'] += 1;
    });
  }

  // ฟังก์ชันลดจำนวนสินค้า
  void _decrementQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] > 1) {
        widget.cart[index]['quantity'] -= 1;
      }
    });
  }

  // ฟังก์ชันลบสินค้าออกจากตะกร้า
  void _removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
  }

  // ฟังก์ชันคำนวณราคารวมทั้งหมด
  double _calculateTotal() {
    return widget.cart.fold(
      0.0,
      (sum, item) => sum + (item['product']['price'] * item['quantity']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: const Color.fromARGB(255, 212, 171, 184),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.cart.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty.',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final cartItem = widget.cart[index];
                        final product = cartItem['product'];
                        final quantity = cartItem['quantity'];

                        // ตรวจสอบว่ามีข้อมูลรูปภาพหรือไม่
                        final imageUrl = product['image'] != null && product['image'].isNotEmpty
                            ? 'http://127.0.0.1:8090/api/files/up1rgxahkrzx2bs/${product['id']}/${product['image']}'
                            : null;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          // หากรูปภาพไม่สามารถโหลดได้
                                          return const Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
                                        },
                                      )
                                    : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                              ),
                              title: Text(
                                product['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Price: ฿${product['price']} x $quantity',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              trailing: SizedBox(
                                width: 150, 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => _decrementQuantity(index),  // ลดจำนวนสินค้า
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => _incrementQuantity(index),  // เพิ่มจำนวนสินค้า
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _removeFromCart(index),  // ลบสินค้าออกจากตะกร้า
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),  
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '฿${_calculateTotal().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proceed to payment')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: const Color.fromARGB(255, 243, 196, 212),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
