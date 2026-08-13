import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bestkits/core/responsive_layout/dimensions.dart';
import 'package:bestkits/utils/app_colors/app_colors.dart';
import 'package:bestkits/utils/app_text_style/app_text_style.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_photo_category_model.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/controller/product_verification_controller.dart';

/// A card that renders a single photo requirement:
/// - Icon + name + required badge
/// - Image slots (pick / remove)
/// - Optional example images row
class PhotoRequirementWidget extends StatelessWidget {
  final PhotoRequirementData requirement;

  const PhotoRequirementWidget({super.key, required this.requirement});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductVerificationController>();
    final code = requirement.code ?? '';
    final limit = requirement.photoLimit ?? 1;
    final isRequired = requirement.required ?? false;
    final exampleUrls = requirement.exampleUrls ?? [];
    final hasExamples = exampleUrls.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.h(14)),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.r(14)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.w(14),
              Dimensions.h(12),
              Dimensions.w(14),
              Dimensions.h(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Requirement icon
                _RequirementIcon(iconUrl: requirement.iconUrl),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              requirement.name ?? '',
                              style: AppTextStyles.body.copyWith(
                                fontSize: Dimensions.fs(14),
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          if (isRequired) ...[
                            SizedBox(width: Dimensions.w(6)),
                            _RequiredBadge(),
                          ],
                        ],
                      ),
                      SizedBox(height: Dimensions.h(2)),
                      Text(
                        'Up to $limit photo${limit > 1 ? 's' : ''}',
                        style: AppTextStyles.hint.copyWith(
                          fontSize: Dimensions.fs(11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.greyColor.withOpacity(0.1),
            indent: Dimensions.w(14),
            endIndent: Dimensions.w(14),
          ),

          // ── Image slots ──────────────────────────────────────────────────
          Obx(() {
            final photos = ctrl.pickedPhotos[code] ?? [];
            final canAdd = photos.length < limit;

            return Padding(
              padding: EdgeInsets.all(Dimensions.w(12)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // Existing picked images
                    ...List.generate(photos.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(right: Dimensions.w(10)),
                        child: _PickedImageTile(
                          photo: photos[i],
                          onRemove: () =>
                              ctrl.removePhotoForRequirement(code, i),
                        ),
                      );
                    }),

                    // Add photo button
                    if (canAdd)
                      GestureDetector(
                        onTap: () => ctrl.pickPhotosForRequirement(code, limit),
                        child: Container(
                          width: Dimensions.w(78),
                          height: Dimensions.h(78),
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(10)),
                            border: Border.all(
                              color: AppColors.greyColor.withOpacity(0.25),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.greyColor,
                                size: Dimensions.icon(22),
                              ),
                              SizedBox(height: Dimensions.h(4)),
                              Text(
                                'Add',
                                style: AppTextStyles.hint.copyWith(
                                  fontSize: Dimensions.fs(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

          // ── Example photos (if any) ──────────────────────────────────────
          if (hasExamples) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.greyColor.withOpacity(0.1),
              indent: Dimensions.w(14),
              endIndent: Dimensions.w(14),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.w(14),
                vertical: Dimensions.h(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: Dimensions.icon(13),
                        color: AppColors.greyColor,
                      ),
                      SizedBox(width: Dimensions.w(4)),
                      Text(
                        'Example photo',
                        style: AppTextStyles.hint.copyWith(
                          fontSize: Dimensions.fs(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.h(8)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: exampleUrls.map((url) {
                        return Padding(
                          padding: EdgeInsets.only(right: Dimensions.w(8)),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.r(8)),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              width: Dimensions.w(60),
                              height: Dimensions.h(60),
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                width: Dimensions.w(60),
                                height: Dimensions.h(60),
                                color: AppColors.textFieldBackgroundColor,
                              ),
                              errorWidget: (_, __, ___) => Container(
                                width: Dimensions.w(60),
                                height: Dimensions.h(60),
                                color: AppColors.textFieldBackgroundColor,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: Dimensions.icon(18),
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Private helpers ────────────────────────────────────────────────────────────

class _RequirementIcon extends StatelessWidget {
  final String? iconUrl;
  const _RequirementIcon({this.iconUrl});

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    if (iconUrl != null && iconUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.r(8)),
        child: CachedNetworkImage(
          imageUrl: iconUrl!,
          width: Dimensions.w(size),
          height: Dimensions.h(size),
          fit: BoxFit.cover,
          placeholder: (_, __) => _IconPlaceholder(size: size),
          errorWidget: (_, __, ___) => _IconPlaceholder(size: size),
        ),
      );
    }
    return _IconPlaceholder(size: size);
  }
}

class _IconPlaceholder extends StatelessWidget {
  final double size;
  const _IconPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.w(size),
      height: Dimensions.h(size),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.r(8)),
      ),
      child: Icon(
        Icons.photo_camera_outlined,
        size: Dimensions.icon(18),
        color: AppColors.greyColor,
      ),
    );
  }
}

class _RequiredBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(6),
        vertical: Dimensions.h(2),
      ),
      decoration: BoxDecoration(
        color: AppColors.redColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.r(4)),
      ),
      child: Text(
        'Required',
        style: AppTextStyles.hint.copyWith(
          fontSize: Dimensions.fs(10),
          fontWeight: FontWeight.w700,
          color: AppColors.redColor,
        ),
      ),
    );
  }
}

class _PickedImageTile extends StatelessWidget {
  final UploadedPhoto photo;
  final VoidCallback onRemove;

  const _PickedImageTile({required this.photo, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.r(10)),
          child: Image.file(
            photo.file,
            width: Dimensions.w(78),
            height: Dimensions.h(78),
            fit: BoxFit.cover,
          ),
        ),
        // Upload overlay
        if (photo.isUploading)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r(10)),
              child: Container(
                color: AppColors.blackColor.withOpacity(0.4),
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Error indicator
        if (photo.isError)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.redColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.whiteColor,
                size: 14,
              ),
            ),
          ),
        // Remove button
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.blackColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.whiteColor,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
