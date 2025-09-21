import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';
import '../widgets/section_header.dart';
import '../widgets/product_card.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedMenuItem = 'Group';
  final List<Product> products = Product.getSampleProducts();

  void onMenuItemSelected(String menuItem) {
    setState(() {
      selectedMenuItem = menuItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6366F1), // Purple background
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            selectedMenuItem: selectedMenuItem,
            onMenuItemSelected: onMenuItemSelected,
          ),

          // Main content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Top bar (search + notification + profil)
                  const TopBar(),

                  // Section header (titre + search + add button)
                  SectionHeader(title: selectedMenuItem),

                  // Product grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}