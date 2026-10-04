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
    );
  }
}
