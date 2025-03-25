import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = Locale('en');
  Map<String, String> _localizedStrings = {};

  Locale get locale => _locale;

  Future<void> loadLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    String jsonString =
        await rootBundle.loadString('localization/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    notifyListeners();
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
