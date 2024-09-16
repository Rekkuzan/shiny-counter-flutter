import 'package:flutter/material.dart';

class HomeScreenCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String spriteUrl;
  final int count;
  final VoidCallback onTap;

  const HomeScreenCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.spriteUrl,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          // Background number
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Main content
          ListTile(
            title: Center(child: Text(title)),
            subtitle: Center(child: Text(subtitle)),
            onTap: onTap,
          ),
          // Sprite in the bottom-right corner
          Positioned(
            bottom: -4,
            right: -4,
            child: Image.network(
              spriteUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
