import 'package:flutter/material.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class CustomInfoCard extends StatelessWidget {
  final String? image; // nullable
  final String title;
  final String? subtitle;
  final String address;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const CustomInfoCard({
    super.key,
    this.image,
    required this.title,
    this.subtitle,
    required this.address,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Leading Image or Placeholder Initials
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: _getPlaceholderColor(title),
                    alignment: Alignment.center,
                    child: (image != null && image!.isNotEmpty)
                        ? Image.network(
                      image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholder();
                      },
                    )
                        : _placeholder(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Favorite Icon
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Heart icon toggle
                          GestureDetector(
                            onTap: onFavoriteTap,
                            child: Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color:AppColors.primaryColor
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Address / Bottom Text
            Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder initials
  Widget _placeholder() {
    String initials = "";
    if (title.isNotEmpty) {
      final parts = title.split(" ");
      if (parts.length > 1) {
        initials =
        "${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}";
      } else {
        initials = title.substring(0, 1).toUpperCase();
      }
    }
    return Text(
      initials,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Generate dynamic placeholder color based on name hash
  Color _getPlaceholderColor(String text) {
    final hash = text.codeUnits.fold(0, (prev, elem) => prev + elem);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash % colors.length].withOpacity(0.8);
  }
}
