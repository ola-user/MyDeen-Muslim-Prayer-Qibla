import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaqFeedbackScreen extends StatefulWidget {
  const FaqFeedbackScreen({super.key});

  @override
  State<FaqFeedbackScreen> createState() => _FaqFeedbackScreenState();
}

class _FaqFeedbackScreenState extends State<FaqFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedCategoryIndex = 0;
  List<Map<String, String>> _submittedItems = [];

  static const List<String> _categories = [
    'General Feedback',
    'Bug Report',
    'Feature Request',
    'Prayer / Qibla',
  ];

  static const List<Map<String, String>> _faqItems = [
    {
      'question': 'How are prayer times calculated in MyDeen?',
      'answer':
          'MyDeen fetches accurate daily and monthly prayer timings for your selected city or GPS location. You can switch your calculation method (MWL, ISNA, Umm Al-Qura, etc.) and Asr juristic method (Shafi\'i or Hanafi) anytime under Me -> Settings.',
    },
    {
      'question': 'Why did an Adhan notification not ring on time?',
      'answer':
          'Make sure your prayer reminders are enabled in Settings, grant notification and exact alarm permissions when prompted, and disable battery optimization for MyDeen: Muslim Prayer & Qibla in your phone\'s Android settings.',
    },
    {
      'question': 'How do I calibrate the Qibla compass?',
      'answer':
          'Hold your phone flat away from metal objects or magnetic phone covers and move it gently in a figure-8 motion for a few seconds until the compass sensor locks onto the Kaaba direction.',
    },
    {
      'question': 'How does the Daily Streak counter work?',
      'answer':
          'Opening MyDeen each day automatically adds +1 to your streak. If you miss a full calendar day, the counter resets to 1 while keeping your all-time Best Streak saved.',
    },
    {
      'question': 'Is MyDeen: Muslim Prayer & Qibla completely free?',
      'answer':
          'Yes. MyDeen is 100% free and ad-free—there are no banner ads, video interruptions, or locked prayer and Quran features.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFeedbackHistory();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _loadFeedbackHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('mydeen_feedback_history');
    if (raw == null || !mounted) return;

    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    setState(() {
      _submittedItems = decoded
          .map((item) => Map<String, String>.from(item as Map))
          .toList();
    });
  }

  Future<void> _submitFeedback() async {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your message before submitting.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await HapticFeedback.mediumImpact();
    final category = _categories[_selectedCategoryIndex];
    final today = DateTime.now().toString().substring(0, 10);

    final updated = [
      {
        'category': category,
        'message': text,
        'date': today,
      },
      ..._submittedItems,
    ];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mydeen_feedback_history', json.encode(updated));

    await Clipboard.setData(
      ClipboardData(
        text: '[MyDeen: Muslim Prayer & Qibla • $category]\n$text',
      ),
    );

    if (!mounted) return;
    setState(() {
      _submittedItems = updated;
      _feedbackController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'JazakAllahu Khayran! Feedback saved and copied to clipboard.',
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
          'FAQ & Feedback',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_faqItems.length, (index) {
                  final faq = _faqItems[index];
                  final isLast = index == _faqItems.length - 1;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpansionTile(
                        iconColor: const Color(0xFF00B060),
                        collapsedIconColor: Colors.white54,
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        title: Text(
                          faq['question']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Text(
                            faq['answer']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      if (!isLast)
                        const Divider(
                          color: Color(0xFF2B3033),
                          height: 1,
                          thickness: 1,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Send Feedback or Report an Issue',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategoryIndex;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCategoryIndex = index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00B060)
                          : const Color(0xFF1F2325),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText:
                  'Tell us how we can improve MyDeen: Muslim Prayer & Qibla...',
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B060),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _submitFeedback,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text(
                'Submit & Copy Feedback',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_submittedItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Your Submitted Notes',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._submittedItems.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2325),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry['category'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF00B060),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          entry['date'] ?? '',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry['message'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}