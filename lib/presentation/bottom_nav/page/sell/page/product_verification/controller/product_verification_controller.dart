import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/widget/show_snackbar.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_brand_model.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_category_model.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_photo_category_model.dart';

class UploadedPhoto {
  final File file;
  String? url;
  bool isUploading;
  bool isError;

  UploadedPhoto({
    required this.file,
    this.url,
    this.isUploading = false,
    this.isError = false,
  });
}

class ProductVerificationController extends GetxController {
  final _picker = ImagePicker();

  // ── Product ID (received from AddProduct via Get.arguments) ──────────────
  late final int productId;

  // ── Loading flags ────────────────────────────────────────────────────────
  final RxBool isLoadingBrands = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingPhotoRequirements = false.obs;
  final RxBool isSubmitting = false.obs;

  // ── Mock outcome (for testing: authentic | fake | UTV) ───────────────────
  static const List<String> mockOutcomeOptions = ['authentic', 'fake', 'UTV'];
  final RxString mockOutcome = 'authentic'.obs;

  // ── Brand data ────────────────────────────────────────────────────────────
  final RxList<BrandData> brands = <BrandData>[].obs;
  final Rx<BrandData?> selectedBrand = Rx<BrandData?>(null);

  // ── Categories derived from the selected brand ────────────────────────────
  final RxList<BrandCategoryData> availableCategories =
      <BrandCategoryData>[].obs;
  final Rx<BrandCategoryData?> selectedCategory = Rx<BrandCategoryData?>(null);

  // ── Photo requirements ────────────────────────────────────────────────────
  final RxList<PhotoRequirementData> photoRequirements =
      <PhotoRequirementData>[].obs;

  /// Map: photo_requirement_code → list of picked photos
  final RxMap<String, List<UploadedPhoto>> pickedPhotos =
      <String, List<UploadedPhoto>>{}.obs;

  // ── Product name (forwarded from AddProductController for the payload) ─────
  String productName = '';

  @override
  void onInit() {
    super.onInit();

    // ── Read productId from route arguments ──────────────────────────────────
    final dynamic args = Get.arguments;
    if (args is int) {
      productId = args;
    } else {
      productId = int.tryParse(args?.toString() ?? '') ?? 0;
    }

    fetchBrands();

    // When brand changes → refresh categories & clear dependent state
    ever(selectedBrand, (_) {
      selectedCategory.value = null;
      photoRequirements.clear();
      pickedPhotos.clear();
      _updateAvailableCategories();
    });

    // When category changes → fetch photo requirements
    ever(selectedCategory, (cat) {
      photoRequirements.clear();
      pickedPhotos.clear();
      if (cat != null && selectedBrand.value != null) {
        fetchPhotoRequirements(
          brandCode: selectedBrand.value!.code ?? '',
          categoryCode: cat.code ?? '',
        );
      }
    });
  }

  // ── Fetch all brands ──────────────────────────────────────────────────────
  Future<void> fetchBrands() async {
    isLoadingBrands.value = true;
    try {
      final url = ApiUrl.legitgrailsBrandAPI;
      print('=== [fetchBrands] Request URL: $url ===');

      final apiClient = ApiClient();
      final response = await apiClient.get(
        url: url,
        isToken: true,
      );

      print('=== [fetchBrands] Response Status: ${response.statusCode} ===');
      print('=== [fetchBrands] Response Body: ${response.body} ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body is Map) {
          final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(body);
          final model = LegitgrailsBrandModel.fromJson(jsonMap);
          if (model.data?.data != null) {
            brands.assignAll(model.data!.data!);
            print(
                '=== [fetchBrands] Successfully loaded ${brands.length} brands ===');
          }
        }
      }
    } catch (e, stack) {
      print('=== [fetchBrands] Error: $e ===');
      print('=== [fetchBrands] StackTrace: $stack ===');
    } finally {
      isLoadingBrands.value = false;
    }
  }

  void _updateAvailableCategories() {
    final brand = selectedBrand.value;
    if (brand != null &&
        brand.categories != null &&
        brand.categories!.isNotEmpty) {
      availableCategories.assignAll(brand.categories!);
      print(
          '=== [_updateAvailableCategories] Loaded ${availableCategories.length} categories from selected brand: ${brand.name} ===');
    } else {
      // Fallback: fetch categories from legitgrailsCategoriesAPI
      fetchCategories();
    }
  }

  // ── Fetch categories from API ──────────────────────────────────────────────
  Future<void> fetchCategories() async {
    isLoadingCategories.value = true;
    try {
      final url = '${ApiUrl.legitgrailsCategoriesAPI}?limit=1000';
      print('=== [fetchCategories] Request URL: $url ===');

      final apiClient = ApiClient();
      final response = await apiClient.get(
        url: url,
        isToken: true,
      );

      print(
          '=== [fetchCategories] Response Status: ${response.statusCode} ===');
      print('=== [fetchCategories] Response Body: ${response.body} ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body is Map) {
          final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(body);
          final model = LegitgrailsCategoryModel.fromJson(jsonMap);
          if (model.data?.data != null) {
            final list = model.data!.data!
                .map((c) => BrandCategoryData(
                      code: c.code,
                      name: c.name,
                      nameLocale: c.nameLocale,
                      iconUrl: c.iconUrl,
                    ))
                .toList();
            availableCategories.assignAll(list);
            print(
                '=== [fetchCategories] Loaded ${availableCategories.length} categories from API ===');
          }
        }
      }
    } catch (e, stack) {
      print('=== [fetchCategories] Error: $e ===');
      print('=== [fetchCategories] StackTrace: $stack ===');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ── Fetch photo-index requirements ────────────────────────────────────────
  Future<void> fetchPhotoRequirements({
    required String brandCode,
    required String categoryCode,
  }) async {
    isLoadingPhotoRequirements.value = true;
    try {
      final url = ApiUrl.photoIndexForCategory(categoryCode, brandCode);
      print('=== [fetchPhotoRequirements] Request URL: $url ===');
      print(
          '=== [fetchPhotoRequirements] Params: brand_code=$brandCode, category_code=$categoryCode ===');

      final apiClient = ApiClient();
      final response = await apiClient.get(
        url: url,
        isToken: true,
      );

      print(
          '=== [fetchPhotoRequirements] Response Status: ${response.statusCode} ===');
      print('=== [fetchPhotoRequirements] Response Body: ${response.body} ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body is Map) {
          final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(body);
          final wrapper = jsonMap['data'];
          if (wrapper != null && wrapper is Map) {
            final Map<String, dynamic> wrapperMap =
                Map<String, dynamic>.from(wrapper);
            if (wrapperMap['data'] != null && wrapperMap['data'] is List) {
              final list = (wrapperMap['data'] as List)
                  .map((e) => PhotoRequirementData.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList();
              photoRequirements.assignAll(list);
              print(
                  '=== [fetchPhotoRequirements] Loaded ${photoRequirements.length} photo requirements ===');

              // Initialise an empty slot for each requirement
              final newMap = <String, List<UploadedPhoto>>{};
              for (final req in list) {
                if (req.code != null) newMap[req.code!] = [];
              }
              pickedPhotos.assignAll(newMap);
            }
          }
        }
      }
    } catch (e, stack) {
      print('=== [fetchPhotoRequirements] Error: $e ===');
      print('=== [fetchPhotoRequirements] StackTrace: $stack ===');
    } finally {
      isLoadingPhotoRequirements.value = false;
    }
  }

  // ── Image picking & Auto-Upload ───────────────────────────────────────────
  Future<void> pickPhotosForRequirement(String code, int limit) async {
    final current = pickedPhotos[code] ?? [];
    final remaining = limit - current.length;
    if (remaining <= 0) return;

    final result = await _picker.pickMultiImage(imageQuality: 80);
    if (result.isEmpty) return;

    final updated = List<UploadedPhoto>.from(current);
    final newlyAdded = <UploadedPhoto>[];

    for (final xFile in result) {
      if (updated.length >= limit) break;
      final photo = UploadedPhoto(file: File(xFile.path), isUploading: true);
      updated.add(photo);
      newlyAdded.add(photo);
    }
    pickedPhotos[code] = updated;
    pickedPhotos.refresh();

    if (newlyAdded.isNotEmpty) {
      _uploadPhotosBatch(code, newlyAdded);
    }
  }

  Future<void> _uploadPhotosBatch(
      String code, List<UploadedPhoto> photosToUpload) async {
    try {
      final apiClient = ApiClient();

      final multipartFiles = photosToUpload
          .map((p) => MultipartFileData(key: 'photos', path: p.file.path))
          .toList();

      final uploadResponse = await apiClient.multipart(
        url: ApiUrl.uploadPhotoProductVerification,
        fields: {'index_code': code},
        files: multipartFiles,
        isToken: true,
      );

      if (uploadResponse.statusCode == 200 ||
          uploadResponse.statusCode == 201) {
        final body = uploadResponse.body;
        if (body is Map && body['data'] is List) {
          final dataList = body['data'] as List;
          for (int i = 0; i < photosToUpload.length; i++) {
            if (i < dataList.length) {
              photosToUpload[i].url = dataList[i]['url']?.toString();
            }
            photosToUpload[i].isUploading = false;
            photosToUpload[i].isError = photosToUpload[i].url == null;
          }
          pickedPhotos.refresh();
          return;
        }
      }

      for (var p in photosToUpload) {
        p.isUploading = false;
        p.isError = true;
      }
      pickedPhotos.refresh();
    } catch (e) {
      for (var p in photosToUpload) {
        p.isUploading = false;
        p.isError = true;
      }
      pickedPhotos.refresh();
    }
  }

  void removePhotoForRequirement(String code, int index) {
    final current = List<UploadedPhoto>.from(pickedPhotos[code] ?? []);
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      pickedPhotos[code] = current;
      pickedPhotos.refresh();
    }
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool get allRequiredPhotosFilled {
    for (final req in photoRequirements) {
      if (req.required == true) {
        final photos = pickedPhotos[req.code ?? ''] ?? [];
        if (photos.isEmpty) return false;
      }
    }
    return true;
  }

  // ── Submit to authentication API ─────────────────────────────────────────
  /// Returns the mock_outcome string on success (e.g. 'authentic', 'fake', 'UTV'),
  /// or null on failure.
  Future<String?> submitVerification() async {
    // 1. Validate that no uploads are still pending or failed
    for (final req in photoRequirements) {
      final photos = pickedPhotos[req.code ?? ''] ?? [];
      if (photos.any((p) => p.isUploading)) {
        ShowAppSnackBar.info('Please wait for all photos to finish uploading.');
        return null;
      }
      if (photos.any((p) => p.isError)) {
        ShowAppSnackBar.fail(
            'Some photos failed to upload. Please remove and re-add them.');
        return null;
      }
    }

    isSubmitting.value = true;
    try {
      final apiClient = ApiClient();
      final List<Map<String, String>> photosPayload = [];

      for (final req in photoRequirements) {
        final code = req.code ?? '';
        final files = pickedPhotos[code] ?? [];
        for (final photo in files) {
          if (photo.url != null) {
            photosPayload.add({'index_code': code, 'url': photo.url!});
          }
        }
      }

      // Build request body — matches the API contract
      final body = {
        'category_code': selectedCategory.value?.code ?? '',
        'brand_code': selectedBrand.value?.code ?? '',
        'answer_time': 1440,
        'mock_outcome': mockOutcome.value,
        'photos': photosPayload,
      };

      final submitUrl = ApiUrl.authenticationSubmitAPI(productId.toString());
      print('=== [submitVerification] Request URL: $submitUrl ===');
      print('=== [submitVerification] Request Body: $body ===');

      final response = await apiClient.post(
        url: submitUrl,
        body: body,
        isToken: true,
      );

      print(
          '=== [submitVerification] Response Status: ${response.statusCode} ===');
      print('=== [submitVerification] Response Body: ${response.body} ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract mock_outcome from the API response
        final responseBody = response.body;
        String? outcome;
        if (responseBody is Map) {
          outcome = responseBody['data']?['mock_outcome']?.toString() ??
              responseBody['mock_outcome']?.toString();
        }
        // Fall back to the value we sent if the response doesn't echo it
        return outcome ?? mockOutcome.value;
      }
      return null;
    } catch (e) {
      print('=== [submitVerification] Error: $e ===');
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  List<String> get brandDisplayList => brands
      .map((b) =>
          (b.code != null && b.code!.isNotEmpty) ? b.code! : (b.name ?? ''))
      .where((s) => s.isNotEmpty)
      .toList();

  List<String> get categoryDisplayList => availableCategories
      .map((c) =>
          (c.code != null && c.code!.isNotEmpty) ? c.code! : (c.name ?? ''))
      .where((s) => s.isNotEmpty)
      .toList();

  void selectBrandByCode(String code) {
    selectedBrand.value = brands.firstWhereOrNull(
      (b) =>
          b.code?.trim().toLowerCase() == code.trim().toLowerCase() ||
          b.name?.trim().toLowerCase() == code.trim().toLowerCase(),
    );
    print(
        '=== [selectBrandByCode] Selected brand: ${selectedBrand.value?.name} (code: ${selectedBrand.value?.code}), Categories: ${selectedBrand.value?.categories?.length} ===');
  }

  void selectCategoryByCode(String code) {
    selectedCategory.value = availableCategories.firstWhereOrNull(
      (c) =>
          c.code?.trim().toLowerCase() == code.trim().toLowerCase() ||
          c.name?.trim().toLowerCase() == code.trim().toLowerCase(),
    );
    print(
        '=== [selectCategoryByCode] Selected category: ${selectedCategory.value?.name} (code: ${selectedCategory.value?.code}) ===');
  }
}
