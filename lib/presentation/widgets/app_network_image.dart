import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    required this.size,
    this.radius = AppDimensions.radiusM,
  });

  final String? url;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child:
            url == null
                ? _placeholder(Icons.inventory_2_outlined)
                : CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _placeholder(Icons.image_outlined),
                  errorWidget:
                      (_, __, ___) => _placeholder(Icons.broken_image_outlined),
                ),
      ),
    );
  }

  Widget _placeholder(IconData icon) => ColoredBox(
    color: AppColors.border,
    child: Icon(icon, color: AppColors.textSecondary),
  );
}
