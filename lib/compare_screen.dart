import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';
import 'sports_os_button.dart';

class CompareScreen extends ConsumerWidget {
  final List<String> selectedAcademies;

  const CompareScreen({super.key, required this.selectedAcademies});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    // Mock data for the comparison based on user selections
    final mockAcademies = [
      _AcademyStats(
        name: 'WICKET HUB',
        rating: 4.8,
        fee: 1500,
        distance: 1.2,
        safety: 96,
        isBest: false,
      ),
      _AcademyStats(
        name: 'Unstoppable Sports Academy',
        rating: 4.9,
        fee: 2000,
        distance: 2.5,
        safety: 98,
      ),
      _AcademyStats(
        name: 'Prime Sports Arena',
        rating: 4.8,
        fee: 1800,
        distance: 4.1,
        safety: 92,
        isBest: false,
      ),
      _AcademyStats(
        name: 'SUV’s Sports Arena',
        rating: 4.7,
        fee: 1200,
        distance: 3.0,
        safety: 95,
        isBest: false,
      ),
      _AcademyStats(
        name: 'LEE MARTIAL ARTS',
        rating: 4.9,
        fee: 1000,
        distance: 1.5,
        safety: 97,
        isBest: false,
      ),
      _AcademyStats(
        name: 'AGYM Fitness',
        rating: 4.6,
        fee: 1500,
        distance: 0.8,
        safety: 90,
        isBest: false,
      ),
    ];

    // Filter down to only what was selected, or show default 3 if none passed (for safety)
    final displayAcademies = selectedAcademies.isEmpty
        ? mockAcademies.take(3).toList()
        : mockAcademies
              .where((a) => selectedAcademies.contains(a.name))
              .toList();

    final recommendedAcademy = displayAcademies.isNotEmpty
        ? displayAcademies.reduce(
            (a, b) =>
                (a.rating + (a.safety / 20)) > (b.rating + (b.safety / 20))
                ? a
                : b,
          )
        : mockAcademies.first;

    for (var a in displayAcademies) {
      a.isBest = a.name == recommendedAcademy.name;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.inkDark : AppColors.inkLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Smart Compare',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: AppColors.green,
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -50,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green.withValues(
                          alpha: isDark ? 0.1 : 0.05,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .blurXY(end: 80)
                    .scaleXY(end: 1.2, duration: 4.seconds),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child:
                Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.blue.withValues(
                          alpha: isDark ? 0.1 : 0.05,
                        ),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .blurXY(end: 80)
                    .scaleXY(end: 1.2, duration: 5.seconds),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'AI ANALYSIS',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.textLight,
                    ),
                  ).animate().fadeIn().slideX(begin: -0.1),
                  const SizedBox(height: 20),

                  // AI Recommendation Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.cardDark : Colors.white)
                              .withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.green.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.green.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI RECOMMENDS',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '98% Match',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              recommendedAcademy.name,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Based on your profile, we recommend this academy because it offers a great balance of safety rating (${recommendedAcademy.safety}/100), verified professional coaches, and excellent parent reviews within a close distance.',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textTertiary
                                    : Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

                  const SizedBox(height: 40),

                  // Comparison Matrix Title
                  Text(
                    'COMPARISON MATRIX',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16),

                  // Comparison Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories Column
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50), // Header spacing
                              _buildCategoryLabel('Rating', isDark),
                              _buildCategoryLabel('Monthly Fee', isDark),
                              _buildCategoryLabel('Distance', isDark),
                              _buildCategoryLabel('Safety Score', isDark),
                              _buildCategoryLabel('Facilities', isDark),
                            ],
                          ),
                        ),

                        // Academy Columns
                        ...displayAcademies.map((academy) {
                          return Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: academy.isBest
                                  ? AppColors.green.withValues(alpha: 0.05)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: academy.isBest
                                  ? Border.all(
                                      color: AppColors.green.withValues(
                                        alpha: 0.3,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Column(
                              children: [
                                // Header
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (academy.isBest)
                                        const Icon(
                                          Icons.workspace_premium,
                                          color: AppColors.green,
                                          size: 16,
                                        ),
                                      Text(
                                        academy.name.split(' ').first,
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textPrimary
                                              : Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                                // Values
                                _buildValueCell(
                                  academy.rating.toString(),
                                  isHighlight: academy.rating >= 4.8,
                                  isDark: isDark,
                                ),
                                _buildValueCell(
                                  '₹${academy.fee}',
                                  isHighlight: academy.fee <= 1500,
                                  isDark: isDark,
                                ),
                                _buildValueCell(
                                  '${academy.distance} km',
                                  isHighlight: academy.distance <= 2.5,
                                  isDark: isDark,
                                ),
                                _buildValueCell(
                                  '${academy.safety}/100',
                                  isHighlight: academy.safety >= 95,
                                  isDark: isDark,
                                ),
                                _buildValueCell(
                                  academy.isBest ? 'Premium' : 'Standard',
                                  isHighlight: academy.isBest,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Bottom Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SportsOSButton(
                          text: 'Book Free Trial',
                          isGhost: true,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SportsOSButton(
                          text: 'Join Winner',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLabel(String label, bool isDark) {
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? AppColors.textSecondary : Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildValueCell(
    String value, {
    required bool isHighlight,
    required bool isDark,
  }) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(
          color: isHighlight
              ? AppColors.green
              : (isDark ? AppColors.textPrimary : Colors.black87),
          fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _AcademyStats {
  final String name;
  final double rating;
  final int fee;
  final double distance;
  final int safety;
  bool isBest;

  _AcademyStats({
    required this.name,
    required this.rating,
    required this.fee,
    required this.distance,
    required this.safety,
    this.isBest = false,
  });
}
