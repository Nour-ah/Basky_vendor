import 'dart:math';
import 'package:flutter/material.dart';
import '../models/azkar_model.dart';

class AzkarManager {
  static final List<AzkarModel> _azkarList = [
    AzkarModel(
      arabic: 'سبحان الله وبحمده',
      transliteration: 'SubhanAllah wa bihamdihi',
      count: 100,
    ),
    AzkarModel(
      arabic: 'سبحان الله العظيم',
      transliteration: 'SubhanAllah al-Azeem',
      count: 100,
    ),
    AzkarModel(
      arabic:
          'لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
      transliteration: 'La ilaha illallah wahdahu la sharika lah',
      count: 100,
    ),
    AzkarModel(
      arabic: 'استغفر الله وأتوب إليه',
      transliteration: 'Astaghfirullah wa atubu ilayh',
      count: 100,
    ),
    AzkarModel(
      arabic: 'الله أكبر كبيراً والحمد لله كثيراً وسبحان الله بكرة وأصيلاً',
      transliteration: 'Allahu Akbar kabeera',
      count: 100,
    ),
    AzkarModel(
      arabic: 'لا حول ولا قوة إلا بالله العلي العظيم',
      transliteration: 'La hawla wa la quwwata illa billah',
      count: 100,
    ),
    AzkarModel(
      arabic: 'حسبي الله ونعم الوكيل',
      transliteration: 'Hasbiyallahu wa ni\'mal wakeel',
      count: 7,
    ),
    AzkarModel(
      arabic: 'اللهم بك أصبحنا وبك أمسينا وبك نحيا وبك نموت وإليك النشور',
      transliteration: 'Allahumma bika asbahna',
      count: 1,
    ),
    AzkarModel(
      arabic:
          'رضيت بالله رباً وبالإسلام ديناً وبمحمد صلى الله عليه وسلم نبياً ورسولاً',
      transliteration: 'Raditu billahi rabba',
      count: 3,
    ),
    AzkarModel(
      arabic:
          'يا حي يا قيوم برحمتك أستغيث أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين',
      transliteration: 'Ya Hayyu Ya Qayyum',
      count: 1,
    ),
  ];

  static final List<String> _prophetPrayers = [
    'اللهم صل وسلم على نبينا محمد',
    'اللهم صل على محمد وعلى آل محمد كما صليت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد',
    'اللهم بارك على محمد وعلى آل محمد كما باركت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد',
    'صلوا على من بكى شوقاً لرؤيتنا.. اللهم صل وسلم على نبينا محمد',
    'اللهم صل على محمد عبدك ورسولك كما صليت على إبراهيم، وبارك على محمد وعلى آل محمد كما باركت على إبراهيم وعلى آل إبراهيم',
  ];

  static String getRandomAzkar() {
    final random = Random();
    final azkar = _azkarList[random.nextInt(_azkarList.length)];
    return azkar.arabic;
  }

  static String getRandomProphetPrayer() {
    final random = Random();
    return _prophetPrayers[random.nextInt(_prophetPrayers.length)];
  }

  static String getRandomReminder() {
    final random = Random();
    if (random.nextBool()) {
      return getRandomAzkar();
    } else {
      return getRandomProphetPrayer();
    }
  }

  static List<Map<String, dynamic>> getAzkarSchedule() {
    return [
      {
        'id': 1,
        'title': 'أذكار الصباح',
        'time': const TimeOfDay(hour: 6, minute: 0),
      },
      {
        'id': 2,
        'title': 'أذكار الظهر',
        'time': const TimeOfDay(hour: 12, minute: 0),
      },
      {
        'id': 3,
        'title': 'أذكار المساء',
        'time': const TimeOfDay(hour: 18, minute: 0),
      },
      {
        'id': 4,
        'title': 'أذكار الليل',
        'time': const TimeOfDay(hour: 21, minute: 0),
      },
    ];
  }

  static List<AzkarModel> getAllAzkar() {
    return _azkarList;
  }
}
