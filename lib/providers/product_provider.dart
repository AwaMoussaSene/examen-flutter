import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Getters
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Product> get _filteredProducts {
    List<Product> filtered = _products;

    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    // Filtrer par catégorie
    if (_selectedCategory != 'All') {
      filtered = filtered.where((product) =>
          product.category?.toLowerCase() == _selectedCategory.toLowerCase() ||
          product.group?.toLowerCase() == _selectedCategory.toLowerCase()
      ).toList();
    }

    return filtered;
  }

  // Charger tous les produits
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final productsData = await _apiService.getProducts();
      _products = productsData.map((data) => Product.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      // En cas d'erreur, utiliser les données d'exemple
      _products = Product.getSampleProducts();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Créer un produit
  Future<bool> createProduct(Product product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final productData = await _apiService.createProduct(product.toJson());
      final newProduct = Product.fromJson(productData);
      _products.insert(0, newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Créer un produit avec image
  Future<bool> createProductWithImage(Product product, String imagePath) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final productData = await _apiService.uploadProductWithImage(
        productData: product.toJson(),
        imagePath: imagePath,
      );
      final newProduct = Product.fromJson(productData);
      _products.insert(0, newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mettre à jour un produit
  Future<bool> updateProduct(Product product) async {
    if (product.id == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final productData = await _apiService.updateProduct(product.id!, product.toJson());
      final updatedProduct = Product.fromJson(productData);
      
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Supprimer un produit
  Future<bool> deleteProduct(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteProduct(productId);
      _products.removeWhere((product) => product.id == productId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Rechercher
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Changer de catégorie
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Obtenir les catégories disponibles
  List<String> get availableCategories {
    Set<String> categories = {'All'};
    for (var product in _products) {
      if (product.category != null) categories.add(product.category!);
      if (product.group != null) categories.add(product.group!);
    }
    return categories.toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Rafraîchir
  Future<void> refresh() async {
    await loadProducts();
  }
}