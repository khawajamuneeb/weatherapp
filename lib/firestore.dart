import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user preferences
  Future<void> saveUserPreference(String userId, String favoriteCity) async {
    await _firestore.collection('users').doc(userId).set({'favoriteCity': favoriteCity});
  }

  // Get user preferences
  Future<String?> getUserPreference(String userId) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists ? (doc.data() as Map<String, dynamic>)['favoriteCity']:null;
    }
}