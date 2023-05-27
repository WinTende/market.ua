import 'package:flutter/foundation.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (kDebugMode) {
      // Ваш тестовый идентификатор блока рекламы AdMob для режима отладки
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      // Ваш рабочий идентификатор блока рекламы AdMob для режима продукции
      return 'ca-app-pub-1375476684576254/4332102765';
    }
  }
}