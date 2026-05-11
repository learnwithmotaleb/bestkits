// ─────────────────────────────────────────────
// controller/legal_company_controller.dart
// ─────────────────────────────────────────────
import 'package:get/get.dart';

class LegalCompanyController extends GetxController {
  final List<Map<String, String>> companyFields = [
    {'label': 'Company Name', 'value': 'BestKid'},
    {'label': 'Business Type', 'value': 'Online Marketplace Platform'},
    {'label': 'Registered Address', 'value': 'To be confirmed – Bulgaria'},
    {'label': 'Jurisdiction', 'value': 'Bulgaria / European Union'},
    {'label': 'Contact Email', 'value': 'support@bestkid.com'},
    {'label': 'Official Website', 'value': 'https://www.bestkid.com'},
  ];
}

