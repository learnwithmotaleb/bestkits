import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bestkits/service/api_service.dart';
import 'package:bestkits/service/api_url.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_brand_model.dart';
import 'package:bestkits/presentation/bottom_nav/page/sell/page/product_verification/model/legitgrails_photo_category_model.dart';

class ProductVerificationController extends GetxController {
  final _picker = ImagePicker();

  // ── Product ID (received from AddProduct via Get.arguments) ──────────────
  late final int productId;

  // ── Loading flags ────────────────────────────────────────────────────────
  final RxBool isLoadingBrands = false.obs;
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

  /// Map: photo_requirement_code → list of picked files
  final RxMap<String, List<File>> pickedPhotos = <String, List<File>>{}.obs;

  // ── Product name (forwarded from AddProductController for the payload) ─────
  String productName = '';

  @override
  void onInit() {
    super.onInit();

    // ── Read productId from route arguments set by AddProduct ────────────────
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
      final url = '${ApiUrl.legitgrailsBrandAPI}?limit=1000';
      print('=== [fetchBrands] Request URL: $url ===');

      final apiClient = ApiClient();
      final response = await apiClient.get(
        url: url,
        isToken: true,
      );

      print('=== [fetchBrands] Response Status: ${response.statusCode} ===');
      print('=== [fetchBrands] Response Body: ${response.body} ===');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = LegitgrailsBrandModel.fromJson(response.body);
        if (model.data?.data != null) {
          brands.assignAll(model.data!.data!);
        }
      }
    } catch (e) {
      print('=== [fetchBrands] Error: $e ===');
    } finally {
      isLoadingBrands.value = false;
    }
  }

  void _updateAvailableCategories() {
    final brand = selectedBrand.value;
    if (brand == null || brand.categories == null) {
      availableCategories.clear();
      return;
    }
    availableCategories.assignAll(brand.categories!);
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
        if (body is Map && body['data'] != null) {
          final wrapper = body['data'];
          if (wrapper is Map && wrapper['data'] != null) {
            final list = (wrapper['data'] as List)
                .map((e) => PhotoRequirementData.fromJson(e))
                .toList();
            photoRequirements.assignAll(list);

            // Initialise an empty slot for each requirement
            final newMap = <String, List<File>>{};
            for (final req in list) {
              if (req.code != null) newMap[req.code!] = [];
            }
            pickedPhotos.assignAll(newMap);
          }
        }
      }
    } catch (e) {
      print('=== [fetchPhotoRequirements] Error: $e ===');
    } finally {
      isLoadingPhotoRequirements.value = false;
    }
  }

  // ── Image picking ─────────────────────────────────────────────────────────
  Future<void> pickPhotosForRequirement(String code, int limit) async {
    final current = pickedPhotos[code] ?? [];
    final remaining = limit - current.length;
    if (remaining <= 0) return;

    final result = await _picker.pickMultiImage(imageQuality: 80);
    if (result.isEmpty) return;

    final updated = List<File>.from(current);
    for (final xFile in result) {
      if (updated.length >= limit) break;
      updated.add(File(xFile.path));
    }
    pickedPhotos[code] = updated;
    pickedPhotos.refresh();
  }

  void removePhotoForRequirement(String code, int index) {
    final current = List<File>.from(pickedPhotos[code] ?? []);
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

  // ── Upload photos + submit to authentication API ──────────────────────────
  /// Returns the mock_outcome string on success (e.g. 'authentic', 'fake', 'UTV'),
  /// or null on failure.
  Future<String?> submitVerification() async {
    isSubmitting.value = true;
    try {
      final apiClient = ApiClient();
      final List<Map<String, String>> photos = [];

      // Upload each picked file to the LegitGrails photo endpoint
      for (final req in photoRequirements) {
        final code = req.code ?? '';
        final files = pickedPhotos[code] ?? [];
        for (final file in files) {
          print(
              '=== [uploadPhoto] Uploading index_code: $code, Path: ${file.path} ===');
          final uploadResponse = await apiClient.multipart(
            url: ApiUrl.uploadPhotoProductVerification,
            fields: {'index_code': code},
            files: [MultipartFileData(key: 'photo', path: file.path)],
            isToken: true,
          );

          print(
              '=== [uploadPhoto] Response Status: ${uploadResponse.statusCode} ===');
          print('=== [uploadPhoto] Response Body: ${uploadResponse.body} ===');

          if (uploadResponse.statusCode == 200 ||
              uploadResponse.statusCode == 201) {
            final uploadBody = uploadResponse.body;
            String? url;
            if (uploadBody is Map) {
              url = uploadBody['data']?['url']?.toString() ??
                  uploadBody['data']?['filePath']?.toString();
            }
            if (url != null && url.isNotEmpty) {
              photos.add({'index_code': code, 'url': url});
            }
          }
        }
      }

      // Build request body — matches the API contract
      final body = {
        'category_code': selectedCategory.value?.code ?? '',
        'brand_code': selectedBrand.value?.code ?? '',
        'answer_time': 1440,
        'mock_outcome': mockOutcome.value,
        'photos': photos,
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
  List<String> get brandNames => brands.map((b) => b.name ?? '').toList();

  List<String> get categoryNames =>
      availableCategories.map((c) => c.name ?? '').toList();

  void selectBrandByName(String name) {
    selectedBrand.value = brands.firstWhereOrNull((b) => b.name == name);
  }

  void selectCategoryByName(String name) {
    selectedCategory.value =
        availableCategories.firstWhereOrNull((c) => c.name == name);
  }
}
