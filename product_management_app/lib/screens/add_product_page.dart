import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import '../service/data_service.dart';
import 'dart:typed_data'; 
import 'package:flutter/foundation.dart'; 
import 'dart:io' as io; 

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final DataService dataService = DataService();
  XFile? _pickedImage; 
  Uint8List? _webImage; 

  // ฟังก์ชันเลือกไฟล์รูปภาพ
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    if (kIsWeb) {
      // สำหรับ Web
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageData = await image.readAsBytes();
        setState(() {
          _pickedImage = image;
          _webImage = imageData;  
        });
      }
    } else {
    
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: const Color(0xFFEFEFEF), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D6E63), 
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Product Title',
                  labelStyle: TextStyle(color: Color(0xFFBCAAA4)), 
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                  labelStyle: TextStyle(color: Color(0xFFBCAAA4)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                  labelStyle: TextStyle(color: Color(0xFFBCAAA4)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8D6E63)),
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7CCC8), 
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
              const SizedBox(height: 20),
              // แสดงภาพที่เลือก
              Center(
                child: _pickedImage != null
                    ? (kIsWeb
                        ? Image.memory(_webImage!, height: 200, width: 200, fit: BoxFit.cover)
                        : Image.file(io.File(_pickedImage!.path), height: 200, width: 200, fit: BoxFit.cover))
                    : const Text(
                        'No Image Selected',
                        style: TextStyle(color: Color(0xFFBCAAA4)),
                      ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String description = descriptionController.text;
                    final double price = double.tryParse(priceController.text) ?? 0;

                    if (title.isEmpty || description.isEmpty || price <= 0 || _pickedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields and pick an image')),
                      );
                      return;
                    }

                    try {
                      await dataService.addProduct(title, description, price, _pickedImage);
                      Navigator.pop(context, true);  
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding product: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D6E63), 
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 18, color: Colors.white), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
