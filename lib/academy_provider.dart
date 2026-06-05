import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

/// A provider that fetches an academy's phone number from Firebase
/// using the academy's name (or ID).
final academyPhoneProvider =
    FutureProvider.family<String?, String>((ref, academyName) async {
  // ===========================================================================
  // 1. REAL FIREBASE IMPLEMENTATION (Uncomment when Firebase is set up)
  // ===========================================================================
  /*
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('academies')
        .where('name', isEqualTo: academyName)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['phoneNumber'] as String?;
    }
  } catch (e) {
    print("Error fetching phone number: $e");
  }
  return null;
  */

  // ===========================================================================
  // 2. MOCK IMPLEMENTATION (Remove this when using Firebase above)
  // ===========================================================================
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  return "1234567890"; // Mock fallback number
});
