import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';

class SportsOSButton extends ConsumerWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGhost;

  const SportsOSButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGhost = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: onPressed,
      child:
          Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: isGhost
                      ? null
                      : const LinearGradient(
                          colors: [AppColors.green, AppColors.green2],
                        ),
                  border: isGhost
                      ? Border.all(
                          color: isDark
                              ? AppColors.textPrimary
                              : Colors.black87,
                        )
                      : null,
                  boxShadow: isGhost
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.greenGlow,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    color: isGhost
                        ? (isDark ? AppColors.textPrimary : Colors.black87)
                        : AppColors.inkDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(duration: 2.seconds, color: Colors.white24, angle: 1),
    );
  }
}
