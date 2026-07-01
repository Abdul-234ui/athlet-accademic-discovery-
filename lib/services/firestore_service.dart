import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_provider.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Profile Methods ---

  Future<void> saveUserProfile(String uid, AppUser user) async {
    await _db.collection('users').doc(uid).set({
      'displayName': user.displayName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
      'role': user.role,
      'extraData': user.extraData,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      return AppUser(
        uid: uid,
        displayName: data['displayName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        photoURL: data['photoURL'],
        role: data['role'],
        extraData: data['extraData'] != null ? Map<String, dynamic>.from(data['extraData']) : null,
      );
    }
    return null;
  }

  // --- Shortlist / Bookmarks Methods ---

  Future<void> saveShortlist(String uid, List<String> academyIds, List<String> coachIds) async {
    await _db.collection('users').doc(uid).collection('data').doc('shortlist').set({
      'academyIds': academyIds,
      'coachIds': coachIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, List<String>>> getShortlist(String uid) async {
    final doc = await _db.collection('users').doc(uid).collection('data').doc('shortlist').get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return {
        'academyIds': data.containsKey('academyIds') ? List<String>.from(data['academyIds']) : [],
        'coachIds': data.containsKey('coachIds') ? List<String>.from(data['coachIds']) : [],
      };
    }
    return {'academyIds': [], 'coachIds': []};
  }

  // --- Academies Methods ---

  Future<void> seedAcademies(List<Map<String, dynamic>> academiesData) async {
    final batch = _db.batch();
    for (var data in academiesData) {
      final docRef = _db.collection('academies').doc(data['id']);
      batch.set(docRef, data);
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getAcademies() async {
    final snapshot = await _db.collection('academies').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
