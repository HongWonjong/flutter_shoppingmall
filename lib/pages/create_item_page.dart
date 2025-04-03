import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/custom_app_bar.dart';
import '../providers/item_provider.dart';

class CreateItemPage extends ConsumerStatefulWidget {
  const CreateItemPage({super.key});

  @override
  ConsumerState<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends ConsumerState<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final description = _descriptionController.text;

      ref.read(itemListProvider.notifier).addItem(
        name,
        price,
        description,
        _selectedImage,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '상품 등록'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity)
                      : const Center(child: Text('이미지 선택')),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '상품이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '상품 이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Cost 원',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '가격을 입력해주세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '상품 설명',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '상품 설명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}