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
  final _companyNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final companyName = _companyNameController.text;
      final price = double.parse(_priceController.text);
      final description = _descriptionController.text;

      ref
          .read(itemListProvider.notifier)
          .addItem(name, companyName, price, description, _selectedImage);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '상품 등록'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),
                  child:
                      _selectedImage != null
                          ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                          : const Center(child: Text('이미지 선택')),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_nameController, '상품명', '상품명을 입력해주세요'),
              const SizedBox(height: 20),
              _buildTextField(_companyNameController, '회사명', '회사명을 입력해주세요'),
              const SizedBox(height: 20),
              _buildTextField(
                _priceController,
                '가격',
                '가격을 입력해주세요',
                keyboardType: TextInputType.number,
                isNumeric: true
              ),
              const SizedBox(height: 20),
              _buildTextField(
                _descriptionController,
                '상품 설명',
                '상품 설명을 입력해주세요',
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 56),
                    backgroundColor: Color(0xFF4D81F0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    '등록하기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorText, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isNumeric = false, // 숫자인지 검사 여부 추가
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (isNumeric && double.tryParse(value) == null) {
          return '숫자만 입력 가능합니다';
        }
        return null;
      },
    );
  }
}
