import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  int _selectedTemplateIndex = 0;
  int _sharedCount = 0;

  static const List<Map<String, String>> _inviteTemplates = [
    {
      'label': 'WhatsApp & Family',
      'message':
          'Assalamu Alaikum! I\'ve been using MyDeen: Muslim Prayer & Qibla — it\'s completely free and 100% ad-free with accurate Prayer Times, Al-Quran audio, Qibla compass, Azkar, and Tasbih. Download it on Google Play!',
    },
    {
      'label': 'Quran & Azkar',
      'message':
          'Assalamu Alaikum! Looking for a clean, distraction-free Islamic app without ads? Try MyDeen: Muslim Prayer & Qibla for daily Adhan alerts, Mushaf reading, morning & evening Azkar, and digital Tasbih.',
    },
    {
      'label': 'Short Message',
      'message':
          'Assalamu Alaikum! Check out MyDeen: Muslim Prayer & Qibla — a clean, 100% ad-free Muslim app for Prayer Times, Quran, Qibla, and Azkar.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadShareCount();
  }

  Future<void> _loadShareCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _sharedCount = prefs.getInt('invite_share_count') ?? 0;
    });
  }

  Future<void> _copyInvitation() async {
    await HapticFeedback.mediumImpact();
    final message = _inviteTemplates[_selectedTemplateIndex]['message']!;
    await Clipboard.setData(ClipboardData(text: message));

    final nextCount = _sharedCount + 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('invite_share_count', nextCount);

    if (!mounted) return;
    setState(() {
      _sharedCount = nextCount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'Invitation copied! Paste it in WhatsApp, Telegram, or SMS to share.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMessage = _inviteTemplates[_selectedTemplateIndex]['message']!;

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invite Friends',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B060).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.people_alt_outlined,
                        color: Color(0xFF00B060),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Share the Goodness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_sharedCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B060).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Shared $_sharedCount',
                          style: const TextStyle(
                            color: Color(0xFF00B060),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '"Whoever guides someone to goodness will have a reward like one who did it." (Sahih Muslim)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Choose Invitation Style',
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
              itemCount: _inviteTemplates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedTemplateIndex;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedTemplateIndex = index);
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
                        _inviteTemplates[index]['label']!,
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2325),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF2B3033)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Message Preview',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
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
              onPressed: _copyInvitation,
              icon: const Icon(Icons.copy_rounded, size: 20),
              label: const Text(
                'Copy Invitation Message',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}