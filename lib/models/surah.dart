class Surah {
  final int number;
  final String name; // Arabic name
  final String englishName;
  final String englishNameTranslation;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
  });

  // This factory takes the JSON from the internet and turns it into a Surah object
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
    );
  }
}
