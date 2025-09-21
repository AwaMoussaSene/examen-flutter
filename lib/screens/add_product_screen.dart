import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final Product? productToEdit;

  const AddProductScreen({Key? key, this.productToEdit}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();
  final _groupController = TextEditingController();
  final _imageUrlController = TextEditingController();

  File? _selectedImageFile;
  String _imageSource = 'url'; // 'url' ou 'file'
  
  bool get _isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeForEditing();
    }
  }

  void _initializeForEditing() {
    final product = widget.productToEdit!;
    _nameController.text = product.name;
    _descriptionController.text = product.description ?? '';
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _categoryController.text = product.category ?? '';
    _groupController.text = product.group ?? '';
    _imageUrlController.text = product.imageUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _groupController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
        _imageSource = 'file';
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    final product = Product(
      id: _isEditing ? widget.productToEdit!.id : null,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      category: _categoryController.text.trim().isEmpty 
          ? null 
          : _categoryController.text.trim(),
      group: _groupController.text.trim().isEmpty 
          ? null 
          : _groupController.text.trim(),
      imageUrl: _imageSource == 'url' 
          ? (_imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim())
          : null,
    );

    bool success;

    if (_isEditing) {
      success = await productProvider.updateProduct(product);
    } else {
      if (_imageSource == 'file' && _selectedImageFile != null) {
        success = await productProvider.createProductWithImage(product, _selectedImageFile!.path);
      } else {
        success = await productProvider.createProduct(product);
      }
    }

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing 
                ? 'Produit modifié avec succès' 
                : 'Produit créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(productProvider.errorMessage ?? 'Erreur inconnue'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Modifier le produit' : 'Ajouter un produit',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form content in scrollable view
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Nom du produit
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nom du produit *',
                      hint: 'Ex: iPhone 15 Pro',
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Le nom est obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Description du produit',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Prix et Stock
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _priceController,
                            label: 'Prix *',
                            hint: '99.99',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Le prix est obligatoire';
                              }
                              if (double.tryParse(value!) == null) {
                                return 'Prix invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _stockController,
                            label: 'Stock *',
                            hint: '50',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Le stock est obligatoire';
                              }
                              if (int.tryParse(value!) == null) {
                                return 'Stock invalide';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Catégorie et Groupe
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _categoryController,
                            label: 'Catégorie',
                            hint: 'Ex: Electronics',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _groupController,
                            label: 'Groupe',
                            hint: 'Ex: Smartphones',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Image
                    _buildImageSection(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 16),
                Consumer<ProductProvider>(
                  builder: (context, productProvider, _) {
                    return ElevatedButton(
                      onPressed: productProvider.isLoading ? null : _saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: productProvider.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(_isEditing ? 'Modifier' : 'Ajouter'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image du produit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // Choix du type d'image
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('URL'),
                value: 'url',
                groupValue: _imageSource,
                onChanged: (value) {
                  setState(() {
                    _imageSource = value!;
                    _selectedImageFile = null;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Fichier'),
                value: 'file',
                groupValue: _imageSource,
                onChanged: (value) {
                  setState(() {
                    _imageSource = value!;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Champ selon le choix
        if (_imageSource == 'url') ...[
          _buildTextField(
            controller: _imageUrlController,
            label: 'URL de l\'image',
            hint: 'https://exemple.com/image.jpg',
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedImageFile?.path.split('/').last ?? 'Aucune image sélectionnée',
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text('Parcourir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],

        // Aperçu de l'image
        if (_imageSource == 'url' && _imageUrlController.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _imageUrlController.text,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[200],
                  child: Icon(Icons.error, color: Colors.grey[400]),
                );
              },
            ),
          ),
        ] else if (_imageSource == 'file' && _selectedImageFile != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _selectedImageFile!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }
}