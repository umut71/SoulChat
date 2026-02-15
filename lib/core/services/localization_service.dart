import 'package:flutter/material.dart';

class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('tr', 'TR'), // Turkish
    Locale('es', 'ES'), // Spanish
    Locale('ar', 'SA'), // Arabic
    Locale('de', 'DE'), // German
    Locale('fr', 'FR'), // French
    Locale('it', 'IT'), // Italian
    Locale('pt', 'PT'), // Portuguese
    Locale('ru', 'RU'), // Russian
    Locale('zh', 'CN'), // Chinese
    Locale('ja', 'JP'), // Japanese
    Locale('ko', 'KR'), // Korean
  ];

  static Map<String, String> getLanguageName(String languageCode) {
    const languageNames = {
      'en': 'English',
      'tr': 'Türkçe',
      'es': 'Español',
      'ar': 'العربية',
      'de': 'Deutsch',
      'fr': 'Français',
      'it': 'Italiano',
      'pt': 'Português',
      'ru': 'Русский',
      'zh': '中文',
      'ja': '日本語',
      'ko': '한국어',
    };
    return {'code': languageCode, 'name': languageNames[languageCode] ?? 'English'};
  }
}
