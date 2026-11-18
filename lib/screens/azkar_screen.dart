import 'package:flutter/material.dart';

import '../data/azkar_content.dart';
import 'azkar_reading_screen.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3C2F), Color(0xFF0F2018)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF00B060).withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (Navigator.canPop(context)) ...[
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                      const Text(
                        'Azkar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B060)
                              .withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFF00B060),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Fortress & Remembrance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Authentic supplications from Hisn al-Muslim',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF141718),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
                    child: Text(
                      'Azkar List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(child: _buildManualAzkarList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualAzkarList() {
    final categories = [
      {'title': 'Morning Azkar', 'target': 23, 'icon': Icons.wb_sunny},
      {'title': 'Evening Azkar', 'target': 22, 'icon': Icons.nights_stay},
      {'title': 'Before Sleeping Azkar', 'target': 14, 'icon': Icons.bed},
      {'title': 'Waking Up Azkar', 'target': 4, 'icon': Icons.wb_twilight},
      {'title': 'After Prayer Azkar', 'target': 8, 'icon': Icons.pan_tool},
      {
        'title': 'Dua After The Opening Takbeer',
        'target': 6,
        'icon': Icons.front_hand,
      },
      {
        'title': 'After Tashahhud Azkar',
        'target': 11,
        'icon': Icons.accessibility_new,
      },
      {'title': 'Duas During Ruku', 'target': 5, 'icon': Icons.accessibility},
      {
        'title': 'Duas During Sujood',
        'target': 7,
        'icon': Icons.airline_seat_flat,
      },
      {'title': 'Azkar On Hearing Athan', 'target': 5, 'icon': Icons.hearing},
      {
        'title': 'Between Two Sujood',
        'target': 2,
        'icon': Icons.airline_seat_legroom_reduced,
      },
      {'title': 'Upon Entering Mosque', 'target': 1, 'icon': Icons.mosque},
      {
        'title': 'Upon Leaving Mosque',
        'target': 1,
        'icon': Icons.directions_walk,
      },
      {
        'title': 'Before Performing Ablution',
        'target': 1,
        'icon': Icons.water_drop,
      },
      {
        'title': 'Upon Completing Ablution',
        'target': 3,
        'icon': Icons.clean_hands,
      },
      {'title': 'Leaving the Home', 'target': 2, 'icon': Icons.door_front_door},
      {'title': 'Entering the Home', 'target': 1, 'icon': Icons.home},
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F2325),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 12,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFF00B060).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                cat['icon'] as IconData,
                color: const Color(0xFF00B060),
                size: 22,
              ),
            ),
            title: Text(
              cat['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Today\'s reading 0/${cat['target']}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white38,
              size: 20,
            ),
            onTap: () {
              final title = cat['title'] as String;
              final contentList = AzkarContent.getListByTitle(title);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarReadingScreen(
                    categoryTitle: title,
                    azkarList: contentList,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
