import 'package:get/get.dart';
import 'bng/bng.dart';
import 'eng/eng.dart';


class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': english,
    'ar_SA': bangla,
  };
}