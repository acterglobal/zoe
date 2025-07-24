class LanguageModel {
  final String languageName;
  final String languageCode;

  LanguageModel({required this.languageName, required this.languageCode});

  factory LanguageModel.fromCode(String? locale) {
    return switch (locale) {
      'en' => const LanguageModel.english(),
      _ => const LanguageModel.english(), 
    };
  }

  const LanguageModel.english() : languageName = 'English', languageCode = 'en';


  static const allLanguagesList = [
    LanguageModel.english(),
  ];
}