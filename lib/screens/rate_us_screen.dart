import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateUsScreen extends StatefulWidget {
  const RateUsScreen({super.key});

  @override
  State<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 5;
  final Set<String> _selectedTags = <String>{};
  bool _isSubmitted = false;

  static const List<String> _highlightTags = [
    'Accurate Prayer Times',
    '100% Ad-Free',
    'Quran Audio',
    'Qibla Compass',
    'Azkar & Tasbih',
    'Clean Dark Design',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedRating();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedRating() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedRating = prefs.getInt('app_user_rating') ?? 5;
      _reviewController.text = prefs.getString('app_user_review') ?? '';
      final savedTags =
          prefs.getStringList('app_user_rating_tags') ?? <String>[];
      _selectedTags
        ..clear()
        ..addAll(savedTags);
      _isSubmitted = prefs.getBool('app_user_rating_submitted') ?? false;
    });
  }

  String _ratingHeadline() {
    switch (_selectedRating) {
      case 5:
        return 'Masha\'Allah! 5 Stars';
      case 4:
        return 'Alhamdulillah! 4 Stars';
      case 3:
        return '3 Stars • Good Experience';
      case 2:
        return '2 Stars • Needs Improvement';
      default:
        return '1 Star • Tell Us What Happened';
    }
  }

  String _ratingSubtext() {
    if (_selectedRating >= 4) {
      return 'Your 5-star review helps other Muslims discover MyDeen: Muslim Prayer & Qibla.';
    }
    return 'Let us know what we can improve to make MyDeen better for the Ummah.';
  }

  Future<void> _submitRating() async {
    await HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('app_user_rating', _selectedRating);
    await prefs.setString('app_user_review', _reviewController.text.trim());
    await prefs.setStringList('app_user_rating_tags', _selectedTags.toList());
    await prefs.setBool('app_user_rating_submitted', true);

    if (!mounted) return;
    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'JazakAllahu Khayran! Your rating for MyDeen has been saved.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _copyReviewForPlayStore() async {
    await HapticFeedback.selectionClick();
    final tagsText = _selectedTags.isNotEmpty
        ? ' Especially love: ${_selectedTags.join(', ')}.'
        : '';
    final userNote = _reviewController.text.trim();
    final reviewText = userNote.isNotEmpty
        ? userNote
        : 'Masha\'Allah, MyDeen: Muslim Prayer & Qibla is clean, fast, and 100% ad-free.$tagsText';

    await Clipboard.setData(ClipboardData(text: reviewText));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'Review text copied! Ready to paste on Google Play Store.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Rate MyDeen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00B060).withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B060).withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    color: Color(0xFF00B060),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'MyDeen: Muslim Prayer & Qibla',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _ratingHeadline(),
                  style: const TextStyle(
                    color: Color(0xFF00B060),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starNumber = index + 1;
                    final isFilled = starNumber <= _selectedRating;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedRating = starNumber;
                          _isSubmitted = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          isFilled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: isFilled ? Colors.amber : Colors.white38,
                          size: 40,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                Text(
                  _ratingSubtext(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'What Do You Like Most?',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _highlightTags.map((tag) {
              final selected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: selected,
                onSelected: (val) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    if (val) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                    _isSubmitted = false;
                  });
                },
                backgroundColor: const Color(0xFF1F2325),
                selectedColor: const Color(0xFF00B060).withValues(alpha: 0.25),
                checkmarkColor: const Color(0xFF00B060),
                side: BorderSide(
                  color: selected
                      ? const Color(0xFF00B060)
                      : const Color(0xFF2B3033),
                ),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Write a Short Review (Optional)',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ),
          TextField(
            controller: _reviewController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (_) {
              if (_isSubmitted) {
                setState(() => _isSubmitted = false);
              }
            },
            decoration: InputDecoration(
              hintText:
                  'Share your thoughts about MyDeen: Muslim Prayer & Qibla...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF1F2325),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF00B060)),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B060),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _submitRating,
              child: Text(
                _isSubmitted
                    ? 'Rating Saved • JazakAllahu Khayran'
                    : 'Submit Rating',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF2B3033)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _copyReviewForPlayStore,
              icon: const Icon(
                Icons.copy_rounded,
                color: Color(0xFF00B060),
                size: 18,
              ),
              label: const Text(
                'Copy Review for Play Store',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
