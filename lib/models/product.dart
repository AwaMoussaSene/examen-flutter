import 'package:flutter/material.dart';

class Product {
  final int? id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? category;
  final String? group;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.category,
    this.group,
    this.createdAt,
    this.updatedAt,
  });

  // Factory pour créer depuis JSON API
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image'],
      category: json['category'],
      group: json['group'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category': category,
      'group': group,
    };
  }

  // Getters pour compatibilité avec l'ancien code
  String get subtitle => description ?? category ?? 'Premium Quality';
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get stockText => 'Stock $stock';
  String get image => imageUrl ?? '';

  Color get color {
    // Couleur basée sur la catégorie/groupe
    switch (category?.toLowerCase()) {
      case 'electronics':
        return Colors.grey[300]!;
      case 'cameras':
        return Colors.brown[200]!;
      case 'audio':
        return Colors.yellow[400]!;
      case 'wearables':
        return Colors.grey[600]!;
      default:
        return Colors.grey[400]!;
    }
  }

  IconData getProductIcon() {
    String productName = name.toLowerCase();
    if (productName.contains('headphones') || productName.contains('audio')) {
      return Icons.headphones;
    } else if (productName.contains('camera')) {
      return Icons.camera_alt;
    } else if (productName.contains('watch')) {
      return Icons.watch;
    } else if (productName.contains('phone')) {
      return Icons.phone_android;
    } else {
      return Icons.devices;
    }
  }

  // Méthode pour copier avec modifications
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    String? category,
    String? group,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      group: group ?? this.group,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Données d'exemple pour le développement (à supprimer plus tard)
  static List<Product> getSampleProducts() {
    return [
      Product(
        id: 1,
        name: 'Amazon Echo Plus (3rd Gen)',
        description: 'Premium Quality Smart Speaker',
        price: 45.00,
        stock: 57,
        imageUrl: 'assets/images/amazon_echo.jpg',
        category: 'electronics',
        group: 'smart-devices',
      ),
      Product(
        id: 2,
        name: 'Digital Camera',
        description: 'Professional Photography Camera',
        price: 299.99,
        stock: 23,
        imageUrl: 'assets/images/camera.jpg',
        category: 'cameras',
        group: 'photography',
      ),
      Product(
        id: 3,
        name: 'Wireless Headphones',
        description: 'High-Quality Audio Experience',
        price: 79.99,
        stock: 45,
        imageUrl: 'assets/images/headphones.jpg',
        category: 'audio',
        group: 'accessories',
      ),
      Product(
        id: 4,
        name: 'Smart Watch',
        description: 'Fitness and Health Tracker',
        price: 199.99,
        stock: 12,
        imageUrl: 'assets/images/watch.jpg',
        category: 'wearables',
        group: 'fitness',
      ),
    ];
  }
}