import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'colors.dart';
import 'theme.dart';
import 'sports_os_button.dart';

class CoachRegistrationScreen extends ConsumerStatefulWidget {
  const CoachRegistrationScreen({super.key});

  @override
  ConsumerState<CoachRegistrationScreen> createState() =>
      _CoachRegistrationScreenState();
}

class _CoachRegistrationScreenState
    extends ConsumerState<CoachRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Upload States
  final Map<String, bool> _uploadedDocs = {};
  final Map<String, bool> _uploadingDocs = {};
  double _verificationProgress = 0.15; // Base progress for just starting

  final List<String> _requiredDocs = [
    'Coaching Certificate',
    'Government ID',
    'Experience Certificate',
    'Academy Registration',
    'Sports Achievements',
    'Profile Photo',
  ];

  final List<String> _timelineSteps = [
    'Registration Submitted',
    'Documents Uploaded',
    'AI Authenticity Check',
    'Manual Review',
    'Background Check',
    'Verified Badge Granted',
  ];

  void _simulateUpload(String docName) async {
    setState(() => _uploadingDocs[docName] = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    if (!mounted) return;
    setState(() {
      _uploadingDocs[docName] = false;
      _uploadedDocs[docName] = true;

      // Update overall progress bar based on uploads
      int uploadedCount = _uploadedDocs.values.where((v) => v).length;
      _verificationProgress =
          0.15 + (0.50 * (uploadedCount / _requiredDocs.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

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
          'Coach Verification',
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.textLight,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Save Draft',
              style: TextStyle(color: AppColors.textTertiary),
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
                color: AppColors.blue.withValues(
                  alpha: isDark ? 0.1 : 0.05,
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .blurXY(end: 80)
                .scaleXY(end: 1.2, duration: 4.seconds),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'COMPLETE\nYOUR PROFILE',
                      style: GoogleFonts.barlowCondensed(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.textLight,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.1),
                    const SizedBox(height: 12),
                    Text(
                      'Become a verified coach to appear publicly on the platform.',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDark ? AppColors.textSecondary : Colors.black87,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),

                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Verification Progress',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(_verificationProgress * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppColors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _verificationProgress,
                            backgroundColor:
                                isDark ? Colors.white12 : Colors.black12,
                            color: AppColors.green,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 40),

                    // Timeline
                    _buildSectionTitle(
                      'VERIFICATION TIMELINE',
                      isDark,
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _timelineSteps.length,
                        itemBuilder: (context, index) {
                          bool isCompleted = index == 0 ||
                              (index == 1 && _verificationProgress >= 0.65);
                          bool isActive =
                              (index == 1 && _verificationProgress < 0.65) ||
                                  (index == 2 && _verificationProgress >= 0.65);
                          return _buildTimelineStep(
                            _timelineSteps[index],
                            isCompleted,
                            isActive,
                            index == _timelineSteps.length - 1,
                            isDark,
                          );
                        },
                      ),
                    ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1),

                    const SizedBox(height: 40),

                    // Verification Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.amber.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pending_actions,
                              color: AppColors.amber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status: Action Required',
                                  style: TextStyle(
                                    color: AppColors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Please upload all mandatory documents to proceed.',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 40),

                    // Section 1: Personal Info
                    _buildSectionTitle(
                      '1. PERSONAL INFORMATION',
                      isDark,
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Full Legal Name',
                      icon: Icons.person_outline,
                      isDark: isDark,
                      delay: 650,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Date of Birth',
                            icon: Icons.calendar_today_outlined,
                            isDark: isDark,
                            delay: 700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            isDark: isDark,
                            delay: 700,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isDark: isDark,
                      delay: 750,
                    ),
                    _buildTextField(
                      label: 'Full Address',
                      icon: Icons.home_outlined,
                      isDark: isDark,
                      delay: 800,
                    ),
                    _buildTextField(
                      label: 'Academy Name (If applicable)',
                      icon: Icons.business_outlined,
                      isOptional: true,
                      isDark: isDark,
                      delay: 850,
                    ),

                    const SizedBox(height: 32),

                    // Section 2: Coaching Details
                    _buildSectionTitle(
                      '2. COACHING DETAILS',
                      isDark,
                    ).animate().fadeIn(delay: 900.ms),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Sport Specialization',
                            icon: Icons.sports_outlined,
                            isDark: isDark,
                            delay: 950,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'Years of Exp.',
                            icon: Icons.timeline,
                            keyboardType: TextInputType.number,
                            isDark: isDark,
                            delay: 950,
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      label: 'Highest Coaching Level (e.g., National)',
                      icon: Icons.emoji_events_outlined,
                      isDark: isDark,
                      delay: 1000,
                    ),
                    _buildTextField(
                      label: 'Previous Academies / Clubs',
                      icon: Icons.history_edu_outlined,
                      isOptional: true,
                      isDark: isDark,
                      delay: 1050,
                    ),

                    const SizedBox(height: 32),

                    // Section 3: Document Upload
                    _buildSectionTitle(
                      '3. DOCUMENT UPLOAD',
                      isDark,
                    ).animate().fadeIn(delay: 1100.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Drag and drop or tap to upload required PDF/JPG/PNG files.',
                      style: TextStyle(
                        color:
                            isDark ? AppColors.textSecondary : Colors.black54,
                        fontSize: 12,
                      ),
                    ).animate().fadeIn(delay: 1150.ms),
                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _requiredDocs.length,
                      itemBuilder: (context, index) {
                        final doc = _requiredDocs[index];
                        return _buildUploadCard(doc, isDark)
                            .animate()
                            .fadeIn(
                              delay: Duration(
                                milliseconds: 1200 + (index * 100),
                              ),
                            )
                            .scaleXY();
                      },
                    ),

                    const SizedBox(height: 40),

                    // AI Verification System
                    _buildSectionTitle(
                      'SMART AI VERIFICATION',
                      isDark,
                    ).animate().fadeIn(delay: 1800.ms),
                    const SizedBox(height: 16),
                    _buildAiVerificationCard(
                      isDark,
                    ).animate().fadeIn(delay: 1850.ms).slideY(begin: 0.1),

                    const SizedBox(height: 40),

                    // Safety & Trust
                    _buildSectionTitle(
                      'SAFETY & TRUST PROMISE',
                      isDark,
                    ).animate().fadeIn(delay: 1900.ms),
                    const SizedBox(height: 16),
                    _buildTrustSection(isDark).animate().fadeIn(delay: 1950.ms),

                    const SizedBox(height: 48),

                    // Action Buttons
                    SportsOSButton(
                      text: 'Submit for Verification',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_verificationProgress < 0.65) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please upload all required documents.',
                                ),
                                backgroundColor: AppColors.amber,
                              ),
                            );
                            return;
                          }
                          // Process submission
                          context.go('/home');
                        }
                      },
                    ).animate().fadeIn(delay: 2000.ms),

                    const SizedBox(height: 16),

                    SportsOSButton(
                      text: 'Contact Support',
                      isGhost: true,
                      onPressed: () {},
                    ).animate().fadeIn(delay: 2100.ms),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.textSecondary : Colors.black54,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTimelineStep(
    String label,
    bool isCompleted,
    bool isActive,
    bool isLast,
    bool isDark,
  ) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted || isActive
                      ? AppColors.green
                      : (isDark ? Colors.white12 : Colors.black12),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.green
                      : (isActive
                          ? AppColors.inkDark
                          : (isDark ? AppColors.cardDark : Colors.white)),
                  border: Border.all(
                    color: isCompleted || isActive
                        ? AppColors.green
                        : (isDark ? Colors.white24 : Colors.black26),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          const BoxShadow(
                            color: AppColors.greenGlow,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                    : null,
              ),
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted && !isLast
                      ? AppColors.green
                      : (isDark ? Colors.white12 : Colors.black12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCompleted || isActive
                    ? (isDark ? AppColors.textPrimary : Colors.black87)
                    : (isDark ? AppColors.textSecondary : Colors.black45),
                fontSize: 11,
                fontWeight: isCompleted || isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool isDark,
    required int delay,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor:
              isDark ? AppColors.cardDark.withValues(alpha: 0.3) : Colors.white,
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return 'Required field';
          }
          return null;
        },
      ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildUploadCard(String title, bool isDark) {
    final isUploaded = _uploadedDocs[title] ?? false;
    final isUploading = _uploadingDocs[title] ?? false;

    return GestureDetector(
      onTap: () {
        if (!isUploaded && !isUploading) _simulateUpload(title);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppColors.green.withValues(alpha: 0.1)
                  : (isDark ? AppColors.cardDark : Colors.white).withValues(
                      alpha: 0.6,
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUploaded
                    ? AppColors.green
                    : (isDark ? Colors.white24 : Colors.black12),
                width: isUploaded ? 2 : 1,
                style: isUploaded
                    ? BorderStyle.solid
                    : BorderStyle
                        .solid, // Could use dash package here for dashed border
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isUploading)
                  const SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      color: AppColors.green,
                      strokeWidth: 3,
                    ),
                  )
                else if (isUploaded)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 36,
                  ).animate().scale(curve: Curves.elasticOut)
                else
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: isDark ? AppColors.textSecondary : Colors.black54,
                    size: 32,
                  ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUploaded
                        ? AppColors.green
                        : (isDark ? AppColors.textPrimary : Colors.black87),
                    fontSize: 12,
                    fontWeight: isUploaded ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                if (!isUploaded && !isUploading) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tap to upload',
                    style: TextStyle(
                      color: isDark ? AppColors.textTertiary : Colors.black45,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiVerificationCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.blue),
              const SizedBox(width: 8),
              const Text(
                'AI Document Analysis',
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAiRow(
            'Document Validation Status',
            'Pending Uploads',
            Icons.document_scanner,
            AppColors.amber,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildAiRow(
            'Fake Certificate Detection',
            'Scanning...',
            Icons.policy,
            AppColors.textTertiary,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildAiRow(
            'Predicted Verification Score',
            '-- / 100',
            Icons.speed,
            AppColors.textTertiary,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildAiRow(
    String title,
    String status,
    IconData icon,
    Color statusColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? AppColors.textSecondary : Colors.black54,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustSection(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTrustBadge(
            'Child Safety\nVerified',
            Icons.child_care,
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTrustBadge('Background\nScreened', Icons.search, isDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTrustBadge(
            'OS Trust\nSeal',
            Icons.workspace_premium,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(String text, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.green, size: 28),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : Colors.black54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
