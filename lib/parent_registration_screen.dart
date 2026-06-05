import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';
import 'sports_os_button.dart';

class ParentRegistrationScreen extends ConsumerStatefulWidget {
  final String role;
  const ParentRegistrationScreen({super.key, required this.role});

  @override
  ConsumerState<ParentRegistrationScreen> createState() =>
      _ParentRegistrationScreenState();
}

class _ParentRegistrationScreenState
    extends ConsumerState<ParentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isLoading = false;

  // Form Controllers
  final _parentNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();

  String _selectedSport = 'Football';
  final List<String> _sports = [
    'Football',
    'Cricket',
    'Basketball',
    'Tennis',
    'Swimming',
    'Martial Arts',
  ];

  @override
  void dispose() {
    _parentNameController.dispose();
    _phoneController.dispose();
    _childNameController.dispose();
    _childAgeController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
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
                            ? AppColors.green
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
                                ? 'CHILD\nDETAILS'
                                : 'PREFERENCES',
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
                            ? 'Tell us about the future champion.'
                            : 'Help us find the perfect match for your child.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.textSecondary
                              : Colors.black87,
                        ),
                      ).animate(key: ValueKey('sub_$_currentStep')).fadeIn(),
                      const SizedBox(height: 32),

                      // Step 1: Parent Details
                      if (_currentStep == 1) ...[
                        _buildTextField(
                          controller: _parentNameController,
                          label: 'Full Name',
                          icon: Icons.person_outline,
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

                      // Step 2: Child Details
                      if (_currentStep == 2) ...[
                        _buildTextField(
                          controller: _childNameController,
                          label: 'Child\'s Name',
                          icon: Icons.face_outlined,
                          isDark: isDark,
                        ),
                        _buildTextField(
                          controller: _childAgeController,
                          label: 'Age',
                          icon: Icons.cake_outlined,
                          keyboardType: TextInputType.number,
                          isDark: isDark,
                        ),
                      ],

                      // Step 3: Preferences
                      if (_currentStep == 3) ...[
                        Text(
                          'Preferred Sport',
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
                            final isSelected = _selectedSport == sport;
                            return ChoiceChip(
                              label: Text(sport),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedSport = sport);
                                }
                              },
                              selectedColor: AppColors.green.withValues(
                                alpha: 0.2,
                              ),
                              backgroundColor: Colors.transparent,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.green
                                    : (isDark
                                          ? Colors.white24
                                          : Colors.black12),
                              ),
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.green
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
                        _buildTextField(
                          controller: _locationController,
                          label: 'Location (City/Area)',
                          icon: Icons.location_on_outlined,
                          isDark: isDark,
                        ),
                        _buildTextField(
                          controller: _budgetController,
                          label: 'Monthly Budget (Optional)',
                          icon: Icons.attach_money_outlined,
                          keyboardType: TextInputType.number,
                          isDark: isDark,
                          isOptional: true,
                        ),
                      ],

                      const SizedBox(height: 32),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
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
