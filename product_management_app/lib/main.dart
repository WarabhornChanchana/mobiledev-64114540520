import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/admin_page.dart';
import 'screens/member_page.dart';
import 'screens/add_product_page.dart';
import 'screens/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management App',
      initialRoute: '/login',
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminPage(),
        '/member': (context) => const MemberPage(),
        '/add_product': (context) => const AddProductPage(),
        '/products': (context) => const ProductListPage(),  // เพิ่มหน้าแสดงรายการสินค้า
      },
    );
  }
}
