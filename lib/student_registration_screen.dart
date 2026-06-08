import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';
import 'sports_os_button.dart';

class StudentRegistrationScreen extends ConsumerStatefulWidget {
  final String role;
  const StudentRegistrationScreen({super.key, required this.role});

  @override
  ConsumerState<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState
    extends ConsumerState<StudentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isLoading = false;

  // Form Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _goalsController = TextEditingController();

  Set<String> _selectedSports = {'Football'};
  final List<String> _sports = [
    'Football',
    'Cricket',
    'Basketball',
    'Tennis',
    'Swimming',
    'Martial Arts',
    'Fitness',
  ];

  String _selectedLevel = 'Beginner';
  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  void _nextStep() async {
    if (_formKey.currentState!.validate()) {
      if (_currentStep < _totalSteps) {
        setState(() => _currentStep++);
      } else {
        setState(() => _isLoading = true);

        // Simulate network request to submit registration to backend
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        setState(() => _isLoading = false);
        context.go('/home');
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isDark = true,
    bool isOptional = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != Icons.edit ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Required field';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            size: 20,
          ),
          onPressed: _prevStep,
        ),
        title: Text(
          '${widget.role} Setup',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index == _totalSteps - 1 ? 0 : 8,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index < _currentStep
                            ? AppColors.blue
                            : (isDark ? Colors.white24 : Colors.black12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ).animate().fadeIn(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentStep == 1
                            ? 'YOUR\nDETAILS'
                            : _currentStep == 2
                                ? 'SPORTS\nPROFILE'
                                : 'YOUR\nGOALS',
                        style: GoogleFonts.barlowCondensed(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.textLight,
                        ),
                      )
                          .animate(key: ValueKey(_currentStep))
                          .fadeIn()
                          .slideX(begin: -0.1),
                      const SizedBox(height: 12),
                      Text(
                        _currentStep == 1
                            ? 'Let\'s start with your basic contact information.'
                            : _currentStep == 2
                                ? 'Tell us about your sports interests.'
                                : 'What are you aiming to achieve?',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              isDark ? AppColors.textSecondary : Colors.black87,
                        ),
                      ).animate(key: ValueKey('sub_$_currentStep')).fadeIn(),
                      const SizedBox(height: 32),

                      // Step 1: Personal Details
                      if (_currentStep == 1) ...[
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
                          isDark: isDark,
                        ),
                        _buildTextField(
                          controller: _dobController,
                          label: 'Date of Birth (DD/MM/YYYY)',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.datetime,
                          isDark: isDark,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          isDark: isDark,
                        ),
                      ],

                      // Step 2: Sports Profile
                      if (_currentStep == 2) ...[
                        Text(
                          'Primary Sport',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondary
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _sports.map((sport) {
                            final isSelected = _selectedSports.contains(sport);
                            return ChoiceChip(
                              label: Text(sport),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSports.add(sport);
                                  } else {
                                    _selectedSports.remove(sport);
                                  }
                                });
                              },
                              selectedColor: AppColors.blue.withValues(
                                alpha: 0.2,
                              ),
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.blue
                                    : (isDark
                                        ? Colors.white24
                                        : Colors.black12),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.blue
                                    : (isDark
                                        ? AppColors.textPrimary
                                        : Colors.black87),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Current Skill Level',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondary
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _levels.map((level) {
                            final isSelected = _selectedLevel == level;
                            return ChoiceChip(
                              label: Text(level),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedLevel = level);
                                }
                              },
                              selectedColor: AppColors.blue.withValues(
                                alpha: 0.2,
                              ),
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.blue
                                    : (isDark
                                        ? Colors.white24
                                        : Colors.black12),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.blue
                                    : (isDark
                                        ? AppColors.textPrimary
                                        : Colors.black87),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      // Step 3: Goals
                      if (_currentStep == 3) ...[
                        _buildTextField(
                          controller: _goalsController,
                          label: 'Short term / Long term goals',
                          icon: Icons.edit,
                          isDark: isDark,
                          maxLines: 4,
                          isOptional: true,
                        ),
                      ],

                      const SizedBox(height: 32),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.blue,
                              ),
                            )
                          : SportsOSButton(
                              text: _currentStep < _totalSteps
                                  ? 'Continue'
                                  : 'Complete Setup',
                              onPressed: _nextStep,
                            ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
