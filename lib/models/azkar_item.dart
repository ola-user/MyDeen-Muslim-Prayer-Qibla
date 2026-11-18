class AzkarItem {
  final String arabic;
  final String translation;
  final String transliteration; // Optional, for how to pronounce it
  final String reference;       // e.g., "Sahih Bukhari 6306"
  final int targetCount;
  final String? audioUrl; // Optional, for the audio file path

  AzkarItem({
    required this.arabic,
    required this.translation,
    this.transliteration = '',
    required this.reference,
    required this.targetCount,
    this.audioUrl,
  });
}