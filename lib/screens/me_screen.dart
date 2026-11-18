import 'package:flutter/material.dart';

import 'settings_screen.dart';
import 'rate_us_screen.dart';
import 'faq_feedback_screen.dart';
import 'invite_friends_screen.dart';
import 'support_us_screen.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = <_MeMenuItem>[
      const _MeMenuItem(
        icon: Icons.monetization_on_outlined,
        title: 'Support Us',
        destination: SupportUsScreen(),
      ),

      const _MeMenuItem(
        icon: Icons.thumb_up_alt_outlined,
        title: 'Rate Us',
        destination: RateUsScreen(),
      ),
      const _MeMenuItem(
        icon: Icons.open_in_new_rounded,
        title: 'Invite Friends',
        destination: InviteFriendsScreen(),
      ),

      const _MeMenuItem(
        icon: Icons.help_outline_rounded,
        title: 'FAQ & Feedback',
        destination: FaqFeedbackScreen(),
      ),

      const _MeMenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        destination: SettingsScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141718),
        elevation: 0,
        title: const Text(
          'MyDeen: Muslim Prayer & Qibla',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2325),
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(menuItems.length, (index) {
              final item = menuItems[index];
              final isLast = index == menuItems.length - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => item.destination),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon, color: Colors.white, size: 24),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white54,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      color: Color(0xFF2B3033),
                      height: 1,
                      thickness: 1,
                      indent: 60,
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MeMenuItem {
  final IconData icon;
  final String title;
  final Widget destination;

  const _MeMenuItem({
    required this.icon,
    required this.title,
    required this.destination,
  });
}
