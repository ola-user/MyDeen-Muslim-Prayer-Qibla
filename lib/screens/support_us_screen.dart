import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportUsScreen extends StatefulWidget {
  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen> {
  bool _hasSentDua = false;

  @override
  void initState() {
    super.initState();
    _loadDuaState();
  }

  Future<void> _loadDuaState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hasSentDua = prefs.getBool('support_dua_sent') ?? false;
    });
  }

  Future<void> _sendDua() async {
    await HapticFeedback.mediumImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('support_dua_sent', true);
    if (!mounted) return;
    setState(() {
      _hasSentDua = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'JazakAllahu Khayran! May Allah accept your Du\'a and reward you abundantly.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _copyShareMessage() async {
    await HapticFeedback.selectionClick();
  const shareText =
        'Assalamu Alaikum! Check out MyDeen: Muslim Prayer & Qibla — a clean, 100% ad-free Islamic app for accurate Prayer Times, Al-Quran, Qibla, Azkar, and Tasbih.';
    await Clipboard.setData(const ClipboardData(text: shareText));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF00B060),
        content: Text(
          'Invitation message copied! Paste it in WhatsApp or any chat to share.',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showRateInfo() {
    HapticFeedback.selectionClick();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2325),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 26),
            SizedBox(width: 8),
            Text(
              'Rate 5 Stars',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Your 5-star rating on Google Play helps other Muslims discover a clean, distraction-free Islamic app without ads.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Insha\'Allah',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
          'Support Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                        Icons.verified_outlined,
                        color: Color(0xFF00B060),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        '100% Free & Ad-Free',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'This app was built for the sake of Allah so every Muslim can read the Quran, track prayers, and make Dhikr without intrusive ads or locked features.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'How You Can Support',
              style: TextStyle(
                color: Color(0xFF00B060),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
          ),
          _buildSupportCard(
            icon: Icons.volunteer_activism_outlined,
            title: 'Remember Us in Your Du\'a',
            subtitle: 'Ask Allah to accept this effort, forgive our shortcomings, and grant barakah to everyone behind this project.',
            buttonLabel: _hasSentDua
                ? 'Du\'a Sent • JazakAllahu Khayran'
                : 'Say Ameen & Make Du\'a',
            isCompleted: _hasSentDua,
            onPressed: _sendDua,
          ),
          const SizedBox(height: 14),
          _buildSupportCard(
            icon: Icons.share_outlined,
            title: 'Share as Sadaqah Jariyah',
            subtitle: 'Whoever guides someone to goodness receives a reward similar to the one who does it. Share this app with family and friends.',
            buttonLabel: 'Copy Invitation Message',
            onPressed: _copyShareMessage,
          ),
          const SizedBox(height: 14),
          _buildSupportCard(
            icon: Icons.star_outline_rounded,
            title: 'Rate Us on Play Store',
            subtitle: 'Leaving a 5-star review helps rank this ad-free app higher so more Muslims can benefit from it.',
            buttonLabel: 'Support with a 5-Star Rating',
            onPressed: _showRateInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onPressed,
    bool isCompleted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2325),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B060).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF00B060), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? const Color(0xFF1E3C2F)
                    : const Color(0xFF00B060),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCompleted
                      ? const BorderSide(color: Color(0xFF00B060))
                      : BorderSide.none,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
