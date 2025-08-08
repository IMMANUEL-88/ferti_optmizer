import 'package:flutter/material.dart';
import 'package:img_picker/img_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String productName = '';
  String category = 'Vegetables'; // Default category
  double price = 0.0;
  double quantity = 0.0;
  String description = '';
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Product Name: $productName');
      print('Category: $category');
      print('Price per unit: $price');
      print('Quantity: $quantity');
      print('Description: $description');
      print('Image Path: ${_imageFile?.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine quantity unit based on category and product name
    String quantityUnit = 'kg'; // Default unit

    // Logic to set quantity unit based on category and product name
    if (category == 'Cereals and Grains' || category == 'Legumes') {
      quantityUnit = 'liters'; // Change unit for grains and legumes
    } else if (category == 'Dairy Products') {
      if (productName.toLowerCase().contains('cheese') || productName.toLowerCase().contains('yogurt')) {
        quantityUnit = 'grams'; // Change unit for cheese and yogurt
      } else {
        quantityUnit = 'liters'; // Change unit for other dairy products
      }
    } else if (category == 'Nuts and Seeds') {
      quantityUnit = 'grams'; // Change unit for nuts and seeds
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.green[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    onChanged: (value) {
                      productName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category Selection
                  DropdownButtonFormField<String>(
                    value: category,
                    items: [
                      'Vegetables',
                      'Fruits',
                      'Cereals and Grains',
                      'Legumes',
                      'Nuts and Seeds',
                      'Dairy Products',
                      'Herbs and Spices',
                      'Manures'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity ($quantityUnit)',
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quantity = double.tryParse(value) ?? 0.0; // Parse the value to double
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the total quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Price per unit',
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      price = double.tryParse(value) ?? 0.0; // Parse the value to double
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Input
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Image Picker
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Selected Image: ${_imageFile!.name}', style: const TextStyle(color: Colors.green)),
                    ),

                  // Submit Button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
