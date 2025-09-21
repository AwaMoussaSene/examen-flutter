import 'package:flutter/material.dart';

class Product {
  final String name;
  final String subtitle;
  final String price;
  final String stock;
  final String image;
  final Color color;

  Product({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.stock,
    required this.image,
    required this.color,
  });

  static List<Product> getSampleProducts() {
    return [
      Product(
        name: 'Amazon Echo Plus (3rd Gen)',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/amazon_echo.jpg',
        color: Colors.grey[300]!,
      ),
      Product(
        name: 'Amazon Echo Plus (3rd Gen)',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/camera.jpg',
        color: Colors.brown[200]!,
      ),
      Product(
        name: 'Digital Camera',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/camera.jpg',
        color: Colors.grey[400]!,
      ),
      Product(
        name: 'Wireless Headphones',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/headphones.jpg',
        color: Colors.yellow[400]!,
      ),
      Product(
        name: 'Smart Watch',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/watch.jpg',
        color: Colors.grey[300]!,
      ),
      Product(
        name: 'Leica Camera',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/leica_camera.jpg',
        color: Colors.grey[600]!,
      ),
      Product(
        name: 'Instant Camera',
        subtitle: 'Premium Quality',
        price: '\$45.00 - \$55.00',
        stock: 'Stock 57',
        image: 'assets/images/polaroid.jpg',
        color: Colors.grey[400]!,
      ),
    ];
  }

  IconData getProductIcon() {
    if (name.toLowerCase().contains('headphones')) {
      return Icons.headphones;
    } else if (name.toLowerCase().contains('camera')) {
      return Icons.camera_alt;
    } else if (name.toLowerCase().contains('watch')) {
      return Icons.watch;
    } else {
      return Icons.speaker;
    }
  }
}