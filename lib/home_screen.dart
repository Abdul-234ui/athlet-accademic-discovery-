import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final Set<String> _selectedSports = {'All'};
  final Set<String> _selectedAcademies = {};

  final List<String> _sports = [
    'All',
    'Cricket',
    'Football',
    'Badminton',
    'Martial Arts',
    'Fitness',
    'Yoga',
  ];

  final List<Map<String, dynamic>> _allAcademies = [
    {
      'name': 'WICKET HUB',
      'sport': 'Cricket',
      'icon': '🏏',
      'accentColor': AppColors.green,
      'rating': '4.8',
      'distance': '1.2 km',
      'price': '₹1500/mo',
      'features': ['Pro Turf', 'Nets', 'Coaching'],
      'badges': ['AI Match', 'Top Rated'],
    },
    {
      'name': 'Unstoppable Sports Academy',
      'sport': 'Cricket',
      'icon': '🏏',
      'accentColor': AppColors.green,
      'rating': '4.9',
      'distance': '2.5 km',
      'price': '₹2000/mo',
      'features': ['Bowling Machine', 'Match Practice', 'Cafe'],
      'badges': ['Verified', 'Kids Friendly'],
    },
    {
      'name': 'SUV’s Sports Arena',
      'sport': 'Badminton',
      'icon': '🏸',
      'accentColor': AppColors.amber,
      'rating': '4.7',
      'distance': '3.0 km',
      'price': '₹1200/mo',
      'features': ['Wooden Floor', 'A/C', 'Pro Coaching'],
      'badges': ['Verified'],
    },
    {
      'name': 'Prime Sports Arena',
      'sport': 'Football',
      'icon': '⚽',
      'accentColor': AppColors.blue,
      'rating': '4.8',
      'distance': '4.1 km',
      'price': '₹1800/mo',
      'features': ['Night Matches', 'Turf', 'Tournaments'],
      'badges': ['AI Match', 'Verified'],
    },
    {
      'name': 'LEE MARTIAL ARTS',
      'sport': 'Martial Arts',
      'icon': '🥋',
      'accentColor': Colors.redAccent,
      'rating': '4.9',
      'distance': '1.5 km',
      'price': '₹1000/mo',
      'features': ['Self Defense', 'Yoga', 'Pro Coaches'],
      'badges': ['Top Rated'],
    },
    {
      'name': 'AGYM Fitness',
      'sport': 'Fitness',
      'icon': '💪',
      'accentColor': Colors.purpleAccent,
      'rating': '4.6',
      'distance': '0.8 km',
      'price': '₹1500/mo',
      'features': ['Cardio', 'Weights', 'Personal Trainer'],
      'badges': ['Popular'],
    },
  ];

  List<Map<String, dynamic>> get _filteredAcademies {
    if (_selectedSports.contains('All') || _selectedSports.isEmpty) {
      return _allAcademies;
    }
    return _allAcademies
        .where((a) => _selectedSports.contains(a['sport']))
        .toList();
  }

  void _toggleAcademySelection(String name) {
    setState(() {
      if (_selectedAcademies.contains(name)) {
        _selectedAcademies.remove(name);
      } else {
        _selectedAcademies.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.inkDark : AppColors.inkLight,
      bottomNavigationBar: _buildBottomNav(isDark),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_selectedAcademies.isNotEmpty)
            _CompareButton(
              count: _selectedAcademies.length,
              isDark: isDark,
              onPressed: () {
                context.push('/compare', extra: _selectedAcademies.toList());
              },
            ),
          if (_selectedAcademies.isNotEmpty) const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'location_fab',
            onPressed: () => context.push('/location'),
            backgroundColor: isDark ? AppColors.card2Dark : Colors.white,
            icon: const Icon(Icons.location_on, color: AppColors.green),
            label: const Text(
              'Live Location',
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
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
            top: 300,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
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
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.go('/welcome'),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardDark
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.black12,
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good Morning,',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Future Champion',
                                  style: GoogleFonts.barlowCondensed(
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.textLight,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.green.withValues(
                            alpha: 0.2,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color:
                              isDark ? AppColors.textPrimary : Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search academies, sports, coaches...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.green,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                  ),
                ),

                // Sports Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 90,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: _sports.length,
                      itemBuilder: (context, index) {
                        final sport = _sports[index];
                        final isSelected = _selectedSports.contains(sport);
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ChoiceChip(
                            label: Text(sport),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (sport == 'All') {
                                  _selectedSports.clear();
                                  _selectedSports.add('All');
                                } else {
                                  _selectedSports.remove('All');
                                  if (selected) {
                                    _selectedSports.add(sport);
                                  } else {
                                    _selectedSports.remove(sport);
                                    if (_selectedSports.isEmpty) {
                                      _selectedSports.add('All');
                                    }
                                  }
                                }
                              });
                            },
                            selectedColor: AppColors.green.withValues(
                              alpha: 0.2,
                            ),
                            backgroundColor:
                                isDark ? AppColors.cardDark : Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.green
                                  : (isDark ? Colors.white12 : Colors.black12),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.green
                                  : (isDark
                                      ? AppColors.textPrimary
                                      : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ).animate().fadeIn(
                                delay: Duration(
                                  milliseconds: 150 + (index * 50),
                                ),
                              ),
                        );
                      },
                    ),
                  ),
                ),

                // Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      'AI RECOMMENDED ACADEMIES',
                      style: TextStyle(
                        color:
                            isDark ? AppColors.textSecondary : Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ),
                ),

                // Academy Cards List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == _filteredAcademies.length) {
                        return const SizedBox(height: 40);
                      }
                      final academy = _filteredAcademies[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildAcademyCard(
                          name: academy['name'],
                          sport: academy['sport'],
                          icon: academy['icon'],
                          accentColor: academy['accentColor'],
                          rating: academy['rating'],
                          distance: academy['distance'],
                          price: academy['price'],
                          features: List<String>.from(academy['features']),
                          badges: List<String>.from(academy['badges']),
                          isDark: isDark,
                          delay: 400 + (index * 50),
                          isSelected: _selectedAcademies.contains(
                            academy['name'],
                          ),
                          onSelect: () =>
                              _toggleAcademySelection(academy['name']),
                        ),
                      );
                    }, childCount: _filteredAcademies.length + 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademyCard({
    required String name,
    required String sport,
    required String icon,
    required Color accentColor,
    required String rating,
    required String distance,
    required String price,
    required List<String> features,
    required List<String> badges,
    required bool isDark,
    required int delay,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.cardDark : Colors.white).withValues(
                alpha: isSelected ? 0.9 : 0.7,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.green
                    : accentColor.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.05),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner area (Simulated with Gradient)
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: badges
                            .map(
                              (badge) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: badge == 'AI Match'
                                      ? AppColors.green
                                      : Colors.black45,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  badge,
                                  style: TextStyle(
                                    color: badge == 'AI Match'
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black45 : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 20,
                          ),
                        ).animate().scale(),
                    ],
                  ),
                ),

                // Details Area
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$sport  •  $distance  •  $price',
                        style: TextStyle(
                          color:
                              isDark ? AppColors.textSecondary : Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: features
                            .map(
                              (f) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.inkDark
                                      : AppColors.inkLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.black12,
                                  ),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textTertiary
                                        : Colors.black87,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return NavigationBar(
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      indicatorColor: AppColors.green.withValues(alpha: 0.2),
      selectedIndex: _selectedIndex,
      onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: AppColors.green),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore, color: AppColors.green),
          label: 'Discover',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today, color: AppColors.green),
          label: 'Bookings',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: AppColors.green),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _CompareButton extends StatelessWidget {
  final int count;
  final bool isDark;
  final VoidCallback onPressed;

  const _CompareButton({
    required this.count,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'compare_fab',
      onPressed: onPressed,
      backgroundColor: AppColors.green,
      elevation: 6,
      icon: const Icon(
        Icons.auto_awesome,
        color: Colors.black87,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compare & Suggest',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count Selected',
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
            duration: 2.seconds, color: Colors.white.withValues(alpha: 0.3))
        .boxShadow(
          end: BoxShadow(
            color: AppColors.green.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        );
  }
}
