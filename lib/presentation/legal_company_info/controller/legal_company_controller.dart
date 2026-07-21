import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../../../../service/api_service.dart';
import '../../../../service/api_url.dart';
import '../model/LegalCompanyInformationModel.dart';

class LegalCompanyController extends GetxController {
  final RxList<Map<String, String>> companyFields = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    _loadStaticFields();
    fetchLegalCompanyInfo();
  }

  void _loadStaticFields() {
    companyFields.assignAll([
      {'label': AppStrings.companyName.tr, 'value': AppStrings.companyNameValue.tr},
      {'label': AppStrings.businessType.tr, 'value': AppStrings.businessTypeValue.tr},
      {'label': AppStrings.registeredAddress.tr, 'value': AppStrings.registeredAddressValue.tr},
      {'label': AppStrings.jurisdiction.tr, 'value': AppStrings.jurisdictionValue.tr},
      {'label': AppStrings.contactEmailLabel.tr, 'value': AppStrings.supportEmail.tr},
      {'label': AppStrings.officialWebsite.tr, 'value': 'https://www.bestkid.com'},
    ]);
  }

  Future<void> fetchLegalCompanyInfo() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        url: ApiUrl.legalCompanyInformation,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final infoModel = LegalCompanyInformationModel.fromJson(response.body);
        if (infoModel.success == true && infoModel.data != null) {
          final data = infoModel.data!;
          companyFields.assignAll([
            {'label': AppStrings.companyName.tr, 'value': data.companyName ?? ''},
            {'label': AppStrings.businessType.tr, 'value': data.businessType ?? ''},
            {'label': AppStrings.registeredAddress.tr, 'value': data.contactAddress ?? ''},
            {'label': AppStrings.jurisdiction.tr, 'value': data.jurisdiction ?? ''},
            {'label': AppStrings.contactEmailLabel.tr, 'value': data.contactEmail ?? ''},
            {'label': AppStrings.officialWebsite.tr, 'value': data.website ?? ''},
          ]);
        }
      }
    } catch (e) {
      print("Error fetching legal company info: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

