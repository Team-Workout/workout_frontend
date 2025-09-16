import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Icon(
              Icons.person,
              size: radius * 1.2,
              color: Colors.grey[600],
            )
          : ClipOval(
              child: Image.network(
                imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: radius * 1.2,
                    color: Colors.grey[600],
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: radius * 2,
                    height: radius * 2,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}