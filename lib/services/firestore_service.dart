import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Users collection reference
  static CollectionReference get usersCollection => _firestore.collection('users');

  /// Save user profile to Firestore
  static Future<void> saveUserProfile({
    required String name,
    required String phone,
    required String avatar,
    String? userId, // Optional: If not provided, uses current user
  }) async {
    print('🔵 ========================================');
    print('🔵 FIRESTORE SERVICE: saveUserProfile()');
    print('🔵 ========================================');
    print('📦 Input parameters:');
    print('   - name: "$name"');
    print('   - phone: "$phone"');
    print('   - avatar: "$avatar"');
    print('   - userId: ${userId ?? "null (will use auth user)"}');
    
    try {
      print('🔄 Getting user ID...');
      final uid = userId ?? _auth.currentUser?.uid;
      print('🆔 User ID determined: $uid');
      
      if (uid == null) {
        print('❌ ERROR: No user ID available');
        print('❌ Auth current user: ${_auth.currentUser}');
        throw Exception('No user ID available. User might not be authenticated.');
      }
      
      print('✅ User ID is valid: $uid');
      print('🔄 Preparing user data object...');

      final userData = {
        'name': name,
        'phone': phone,
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'friends': [], // Empty friends list
        'friendRequests': [], // Empty friend requests
        'status': 'active',
      };

      print('📄 User data prepared:');
      print('   ${userData.toString()}');
      print('🔄 Collection path: users/$uid');
      print('⏳ Calling Firestore set() method...');
      print('⏰ Start time: ${DateTime.now()}');
      
      final startTime = DateTime.now().millisecondsSinceEpoch;
      
      await usersCollection.doc(uid).set(userData, SetOptions(merge: true));
      
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final duration = endTime - startTime;
      
      print('✅ ========================================');
      print('✅ FIRESTORE WRITE SUCCESSFUL');
      print('✅ ========================================');
      print('✅ Document ID: $uid');
      print('✅ Time taken: ${duration}ms');
      print('✅ User profile saved for: $name ($phone)');
      print('⏰ End time: ${DateTime.now()}');
      
    } catch (e, stackTrace) {
      print('❌ ========================================');
      print('❌ FIRESTORE ERROR');
      print('❌ ========================================');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error message: $e');
      print('❌ Error details:');
      
      if (e is FirebaseException) {
        print('   - Firebase error code: ${e.code}');
        print('   - Firebase error message: ${e.message}');
        print('   - Firebase plugin: ${e.plugin}');
      }
      
      print('❌ Stack trace:');
      print(stackTrace);
      print('❌ ========================================');
      
      rethrow;
    }
    
    print('🔵 ========================================');
    print('🔵 FIRESTORE SERVICE COMPLETED');
    print('🔵 ========================================');
  }

  /// Get user profile from Firestore
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      print('🔍 Getting user profile for: $userId');
      final doc = await usersCollection.doc(userId).get();
      
      if (doc.exists) {
        print('✅ User profile found');
        return doc.data() as Map<String, dynamic>?;
      }
      print('⚠️ User profile not found');
      return null;
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  /// Get current user's profile
  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    print('🔍 Getting current user profile...');
    final currentUser = _auth.currentUser;
    
    if (currentUser == null) {
      print('⚠️ No current user authenticated');
      return null;
    }
    
    print('✅ Current user ID: ${currentUser.uid}');
    return await getUserProfile(currentUser.uid);
  }

  /// Update user profile
  static Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? avatar,
  }) async {
    try {
      print('🔄 Updating user profile for: $userId');
      
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updates['name'] = name;
        print('   - Updating name: $name');
      }
      if (avatar != null) {
        updates['avatar'] = avatar;
        print('   - Updating avatar: $avatar');
      }

      await usersCollection.doc(userId).update(updates);
      
      print('✅ User profile updated for: $userId');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Search users by phone number
  static Future<List<Map<String, dynamic>>> searchUsersByPhone(String phone) async {
    try {
      print('🔍 Searching users by phone: $phone');
      
      // Remove any non-digit characters
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      print('🔍 Cleaned phone: $cleanPhone');
      
      final query = await usersCollection
          .where('phone', isGreaterThanOrEqualTo: cleanPhone)
          .where('phone', isLessThanOrEqualTo: '$cleanPhone\uf8ff')
          .limit(10)
          .get();

      print('✅ Found ${query.docs.length} users');
      
      return query.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              ...data,
            };
          })
          .toList();
    } catch (e) {
      print('❌ Error searching users: $e');
      return [];
    }
  }

  /// Get multiple users by their IDs
  static Future<List<Map<String, dynamic>>> getUsersByIds(List<String> userIds) async {
    try {
      print('🔍 Getting users by IDs: ${userIds.length} users');
      
      if (userIds.isEmpty) {
        print('⚠️ Empty user IDs list');
        return [];
      }

      final futures = userIds.map((id) => usersCollection.doc(id).get());
      final results = await Future.wait(futures);

      final users = results
          .where((doc) => doc.exists)
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              ...data,
            };
          })
          .toList();
      
      print('✅ Retrieved ${users.length} users');
      return users;
    } catch (e) {
      print('❌ Error getting users by IDs: $e');
      return [];
    }
  }

  /// Check if user exists by phone
  static Future<bool> userExists(String phone) async {
    try {
      print('🔍 Checking if user exists with phone: $phone');
      
      final query = await usersCollection
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      final exists = query.docs.isNotEmpty;
      print(exists ? '✅ User exists' : '⚠️ User does not exist');
      
      return exists;
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }
}