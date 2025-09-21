import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Search field (à gauche)
          Expanded(
            child: _buildSearchField(),
          ),
          
          const Spacer(),
          
          // Notification + Profile section (à droite)
          Row(
            children: [
              _buildNotificationIcon(),
              const SizedBox(width: 16),
              _buildProfileSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 400,
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
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: const AssetImage('assets/images/profile.jpg'),
          backgroundColor: Colors.grey,
          onBackgroundImageError: (exception, stackTrace) {
            // Gérer l'erreur silencieusement
          },
          child: const Text(
            'M',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Maxbert',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_arrow_down, size: 16),
      ],
    );
  }
}
