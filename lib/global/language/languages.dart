import 'package:get/get.dart';
import 'bgg/bgg.dart';
import 'eng/eng.dart';
import 'message_translations.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          for (final key in bulgarianMessages.keys) key: key,
          ...english,
        },
        'bg_BG': {...bulgarianMessages, ...bulgarian},
      };
}
