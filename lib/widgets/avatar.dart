import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  const Avatar({super.key, required this.imageUrl, this.size = 50.0});
  @override

  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, _) {},
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.grey.shade600,
      ),
    );
  }
}
