// ─────────────────────────────────────────────
// controller/legal_company_controller.dart
// ─────────────────────────────────────────────
import 'package:get/get.dart';
import '../../../utils/static_strings/static_strings.dart';


class LegalCompanyController extends GetxController {
  final List<Map<String, String>> companyFields = [
    {'label': AppStrings.companyName.tr, 'value': AppStrings.companyNameValue.tr},
    {'label': AppStrings.businessType.tr, 'value': AppStrings.businessTypeValue.tr},
    {'label': AppStrings.registeredAddress.tr, 'value': AppStrings.registeredAddressValue.tr},
    {'label': AppStrings.jurisdiction.tr, 'value': AppStrings.jurisdictionValue.tr},
    {'label': AppStrings.contactEmailLabel.tr, 'value': AppStrings.supportEmail.tr},
    {'label': AppStrings.officialWebsite.tr, 'value': 'https://www.bestkid.com'},
  ];
}

