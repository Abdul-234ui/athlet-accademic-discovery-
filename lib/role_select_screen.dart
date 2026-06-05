import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            size: 20,
          ),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: Stack(
        children: [
          // Base Futuristic Background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: isDark
                    ? [AppColors.ink2Dark, AppColors.inkDark]
                    : [AppColors.inkLight, Colors.white],
              ),
            ),
          ),

          // Neon Green Glow Effect (Top Right)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.green.withValues(
                  alpha: isDark ? 0.15 : 0.05,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scaleXY(end: 1.2, duration: 4.seconds)
                .blurXY(end: 60),
          ),

          // Blue Glow Effect (Bottom Left)
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blue.withValues(
                  alpha: isDark ? 0.1 : 0.03,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scaleXY(end: 1.3, duration: 5.seconds)
                .blurXY(end: 80),
          ),

          // Main UI Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'CHOOSE\nYOUR ROLE',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color:
                          isDark ? AppColors.textPrimary : AppColors.textLight,
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2),
                  const SizedBox(height: 12),
                  Text(
                    'Select how you want to use Sports OS to get a personalized experience.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.textSecondary : Colors.black87,
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 40),

                  // Parent Card
                  _RoleCard(
                    title: 'Parent',
                    description:
                        'Find academies and track your child\'s progress',
                    icon: '👨‍👩‍👧',
                    accentColor: AppColors.green,
                    isDark: isDark,
                    onTap: () {
                      context.push('/register/Parent');
                    },
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  const SizedBox(height: 16),

                  // Student Card
                  _RoleCard(
                    title: 'Student / Athlete',
                    description: 'Discover sports and monitor your training',
                    icon: '🏃',
                    accentColor: AppColors.blue,
                    isDark: isDark,
                    onTap: () {
                      context.push('/register/Student');
                    },
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                  const SizedBox(height: 16),

                  // Coach Card
                  _RoleCard(
                    title: 'Coach / Academy',
                    description: 'Manage students, batches, and your profile',
                    icon: '📋',
                    accentColor: AppColors.amber,
                    isDark: isDark,
                    onTap: () {
                      context.push('/register/Coach');
                    },
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

                  const Spacer(),

                  // Verified Notice Card (Glassmorphic)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.cardDark : Colors.white)
                              .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? AppColors.textSecondary.withValues(alpha: 0.2)
                                : Colors.black12,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.security,
                              color: AppColors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'All coach credentials independently verified for your safety.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatefulWidget {
  final String title;
  final String description;
  final String icon;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        // Small delay to let the animation play before navigating
        Future.delayed(const Duration(milliseconds: 150), widget.onTap);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? (_isPressed
                        ? widget.accentColor.withValues(alpha: 0.15)
                        : AppColors.cardDark.withValues(alpha: 0.6))
                    : (_isPressed
                        ? widget.accentColor.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.8)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isPressed
                      ? widget.accentColor
                      : widget.accentColor.withValues(alpha: 0.3),
                  width: _isPressed ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(
                      alpha: _isPressed ? 0.15 : 0.05,
                    ),
                    blurRadius: _isPressed ? 15 : 10,
                    spreadRadius: _isPressed ? 4 : 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.isDark
                                ? AppColors.textPrimary
                                : AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.isDark
                                ? AppColors.textTertiary
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: widget.accentColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
