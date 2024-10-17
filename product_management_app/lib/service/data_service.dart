import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data'; // ใช้สำหรับจัดการไฟล์บน Web
import 'package:flutter/foundation.dart'; // ใช้สำหรับเช็คแพลตฟอร์ม
import 'package:image_picker/image_picker.dart'; // ใช้สำหรับการเลือกไฟล์ภาพในมือถือ


class DataService {
  final String baseUrl = 'http://127.0.0.1:8090'; // URL ของ PocketBase
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb2xsZWN0aW9uSWQiOiJfcGJfdXNlcnNfYXV0aF8iLCJleHAiOjE3MzAzNTc1MDEsImlkIjoiZ3dtNzV1MTUyM3l4eXJhIiwidHlwZSI6ImF1dGhSZWNvcmQifQ.QRWvFyAvQpP9NU1tzFopvYrJ3LhyAmRn1A6paapgruA'; // Token สำหรับการยืนยันตัวตน

  // ฟังก์ชันดึงรายการสินค้า
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/collections/products/records'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'];
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw e;
    }
  }

  // ฟังก์ชันเพิ่มสินค้า
  Future<void> addProduct(String title, String description, double price, dynamic imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/collections/products/records'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['price'] = price.toString();

      // ตรวจสอบแพลตฟอร์ม (Web หรือ Mobile)
      if (imageFile != null) {
        if (kIsWeb) {
          // การจัดการรูปภาพสำหรับ Web
          Uint8List bytes = await imageFile.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.name,
          ));
        } else {
          // การจัดการรูปภาพสำหรับมือถือ (iOS/Android)
          final bytes = await imageFile.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.path.split('/').last,
          ));
        }
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  // ฟังก์ชันแก้ไขสินค้า
  Future<void> updateProduct(String productId, String title, String description, double price) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/collections/products/records/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'price': price,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

// ฟังก์ชันลบสินค้า
Future<void> deleteProduct(String productId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/collections/products/records/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {  // สำหรับ HTTP DELETE, status 204 หมายถึงสำเร็จ
      print('Product deleted successfully');
    } else {
      print('Failed to delete product: ${response.body}');
      throw Exception('Failed to delete product');
    }
  } catch (e) {
    print('Error deleting product: $e');
    throw e;
    }
  }
}
