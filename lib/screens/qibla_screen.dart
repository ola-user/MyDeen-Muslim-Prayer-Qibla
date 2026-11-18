import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_device_compass/flutter_device_compass.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141718),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
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
              child: Row(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Qibla Compass',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Align the Kaaba marker with the top pointer',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B060).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00B060).withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Text(
                      '62° NE',
                      style: TextStyle(
                        color: Color(0xFF00B060),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00B060)),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.heading != null) {
                  final heading = snapshot.data!.heading!;
                  const qiblaDirection = 62.0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF00B060),
                        size: 44,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 290,
                        height: 290,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: -heading * (pi / 180),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 290,
                                    height: 290,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(
                                        colors: [
                                          Color(0xFF1F2325),
                                          Color(0xFF0F2018),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF00B060)
                                            .withValues(alpha: 0.6),
                                        width: 5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.45,
                                          ),
                                          blurRadius: 16,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Text(
                                              'N',
                                              style: TextStyle(
                                                color: Color(0xFF00B060),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Text(
                                              'E',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(14),
                                            child: Text(
                                              'W',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: qiblaDirection * (pi / 180),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF141718),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF00B060),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.mosque,
                                          color: Color(0xFF00B060),
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 44),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2325),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.screen_rotation,
                              color: Color(0xFF00B060),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Please lay your phone flat',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Waiting for compass data...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
