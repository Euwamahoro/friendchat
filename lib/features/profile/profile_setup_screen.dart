import 'package:flutter/material.dart';
import 'package:friendchat/features/auth/home/main_screen.dart';
import 'package:friendchat/services/firestore_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String phoneNumber;
  
  const ProfileSetupScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _selectedAvatar = '👤'; // Default avatar emoji

  // Available avatar options
  final List<String> _avatarOptions = ['👤', '😊', '😎', '🤓', '🧑‍💻', '👨‍🎨', '👩‍🚀', '🦸', '🐱', '🐶'];

  Future<void> _saveProfile() async {
    print('🟢 ========================================');
    print('🟢 PROFILE SAVE STARTED');
    print('🟢 ========================================');
    print('📝 Name entered: "${_nameController.text}"');
    print('📝 Name trimmed: "${_nameController.text.trim()}"');
    print('📝 Name length: ${_nameController.text.trim().length}');
    print('📞 Phone number: ${widget.phoneNumber}');
    print('🎭 Selected avatar: $_selectedAvatar');
    print('⏰ Current time: ${DateTime.now()}');
    
    // Validation
    if (_nameController.text.trim().isEmpty) {
      print('❌ VALIDATION FAILED: Name is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.red,
        ),
      );
      print('🔴 Returning early due to validation failure');
      return;
    }
    
    print('✅ Validation passed');
    print('⏳ Setting loading state to TRUE');

    setState(() {
      _isLoading = true;
    });
    
    print('✅ Loading state updated, UI should show spinner now');

    try {
      print('🔄 ----------------------------------------');
      print('🔄 CALLING FIRESTORE SERVICE');
      print('🔄 ----------------------------------------');
      print('🔄 About to call FirestoreService.saveUserProfile()');
      
      final startTime = DateTime.now();
      
      await FirestoreService.saveUserProfile(
        name: _nameController.text.trim(),
        phone: widget.phoneNumber,
        avatar: _selectedAvatar,
        userId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      print('✅ ----------------------------------------');
      print('✅ FIRESTORE SERVICE COMPLETED');
      print('✅ ----------------------------------------');
      print('✅ Time taken: ${duration.inMilliseconds}ms');
      print('✅ Profile saved to Firestore successfully');
      
      print('🚀 ----------------------------------------');
      print('🚀 NAVIGATION STARTING');
      print('🚀 ----------------------------------------');
      print('🚀 Checking if widget is still mounted...');
      print('🚀 Widget mounted: $mounted');
      
      if (!mounted) {
        print('⚠️ WARNING: Widget not mounted, cannot navigate');
        return;
      }
      
      print('🚀 Widget is mounted, proceeding with navigation');
      print('🚀 Calling Navigator.pushReplacement...');
      print('🚀 Target: MainScreen');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('🏗️ Building MainScreen...');
            return const MainScreen();
          },
        ),
      );
      
      print('✅ Navigator.pushReplacement() call completed');
      print('✅ Navigation should be in progress now');
      
    } catch (e, stackTrace) {
      print('❌ ========================================');
      print('❌ ERROR OCCURRED IN _saveProfile()');
      print('❌ ========================================');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error message: $e');
      print('❌ Stack trace:');
      print(stackTrace);
      print('❌ ========================================');
      
      if (mounted) {
        print('⚠️ Showing error snackbar to user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        print('⚠️ Cannot show snackbar - widget not mounted');
      }
    } finally {
      print('🔄 ----------------------------------------');
      print('🔄 FINALLY BLOCK EXECUTING');
      print('🔄 ----------------------------------------');
      print('🔄 Checking if widget is mounted: $mounted');
      
      if (mounted) {
        print('🔄 Setting loading state to FALSE');
        setState(() {
          _isLoading = false;
        });
        print('✅ Loading state updated, spinner should disappear');
      } else {
        print('⚠️ Widget not mounted, cannot update loading state');
      }
    }
    
    print('🏁 ========================================');
    print('🏁 PROFILE SAVE METHOD COMPLETED');
    print('🏁 ========================================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Profile'),
        leading: Container(), // Remove back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // Avatar Selection
              Column(
                children: [
                  // Current Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: const Color(0xFF007AFF),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _selectedAvatar,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Choose your avatar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Avatar Grid
                  SizedBox(
                    height: 100,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _avatarOptions.length,
                      itemBuilder: (context, index) {
                        final avatar = _avatarOptions[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAvatar = avatar;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedAvatar == avatar
                                  ? const Color(0xFF007AFF).withOpacity(0.2)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedAvatar == avatar
                                    ? const Color(0xFF007AFF)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                avatar,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Name Input
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'This is how friends will see you',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // Phone Display (read-only)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Complete Setup',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Skip for now option
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        print('⏭️ User clicked "Skip for now"');
                        print('⏭️ Navigating to MainScreen without saving profile');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                child: const Text(
                  'Skip for now',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('🗑️ ProfileSetupScreen disposing');
    _nameController.dispose();
    super.dispose();
  }
}