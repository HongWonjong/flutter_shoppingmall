import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../components/custom_app_bar.dart';
import '../models/item.dart';
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
  ItemType? _selectedItemType; // ItemType 추가

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

      // itemProvider의 addItem 메서드가 ItemType을 받도록 가정하고 수정 필요
      ref
          .read(itemListProvider.notifier)
          .addItem(name, companyName, price, description, _selectedImage, _selectedItemType!);

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
          child: SingleChildScrollView( // 스크롤 가능하도록 추가
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
                    child: _selectedImage != null
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
                  isNumeric: true,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _descriptionController,
                  '상품 설명',
                  '상품 설명을 입력해주세요',
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                _buildDropdown(), // ItemType 선택 드롭다운 추가
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
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String errorText, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        bool isNumeric = false,
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

  Widget _buildDropdown() {
    return DropdownButtonFormField<ItemType?>(
      value: _selectedItemType,
      decoration: InputDecoration(
        labelText: '아이템 타입',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: [
        const DropdownMenuItem<ItemType?>(
          value: null,
          child: Text('선택 안 함'),
        ),
        ...ItemType.values.map((type) => DropdownMenuItem<ItemType>(
          value: type,
          child: Text(
            type == ItemType.food
                ? '식품'
                : type == ItemType.clothing
                ? '의류'
                : type == ItemType.appliance
                ? '가전제품'
                : '기타'
          ),
        )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedItemType = value;
        });
      },
      validator: (value) => null, // 필수 입력이 아니므로 null 허용
    );
  }
}