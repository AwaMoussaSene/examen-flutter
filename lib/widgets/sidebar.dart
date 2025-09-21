import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String selectedMenuItem;
  final Function(String) onMenuItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedMenuItem,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Search bar
          _buildSearchBar(),

          const SizedBox(height: 32),

          // Menu items
          Expanded(
            child: Column(
              children: [
                _buildMenuItem(Icons.dashboard, 'Overview'),
                _buildMenuItem(Icons.inventory, 'Product', hasSubmenu: true),
                Padding(
                  padding: const EdgeInsets.only(left: 56.0),
                  child: Column(
                    children: [
                      _buildSubMenuItem('All Products'),
                      _buildSubMenuItem('Categories'),
                      _buildSubMenuItem('Group', isSelected: selectedMenuItem == 'Group'),
                    ],
                  ),
                ),
                _buildMenuItem(Icons.shopping_cart, 'Orders', hasSubmenu: true),
                _buildMenuItem(Icons.people, 'Customers', hasSubmenu: true),
                _buildMenuItem(Icons.rate_review, 'Manage Reviews'),
                _buildMenuItem(Icons.shopping_bag, 'Checkout'),
                _buildMenuItem(Icons.settings, 'Settings'),
              ],
            ),
          ),

          // Bottom section
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.hexagon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Substance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool hasSubmenu = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
      child: InkWell(
        onTap: () => onMenuItemSelected(title),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasSubmenu)
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onMenuItemSelected(title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Technical help'),
          const SizedBox(height: 8),
          const Text('Contact us'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Upgrade to Pro',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Release you maximum\npotential software',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}