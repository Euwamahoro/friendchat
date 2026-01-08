import 'package:flutter/material.dart';
import 'package:friendchat/core/data/countries.dart';
import 'package:friendchat/features/auth/otp_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  Country _selectedCountry = countries[0]; // Default: US
  bool _isLoading = false;
  bool _showCountryPicker = false;

  void _sendVerificationCode() {
    if (!mounted) return;
    
    final phoneNumber = '${_selectedCountry.dialCode}${_phoneController.text.trim()}';
    
    if (_phoneController.text.trim().length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
     Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OtpScreen(
      phoneNumber: phoneNumber,
      verificationId: 'simulated_verification_id_12345',
    ),
  ),
);
      
      print('Phone number to verify: $phoneNumber');
    });
  }

  void _showCountrySelection() {
    setState(() {
      _showCountryPicker = !_showCountryPicker;
    });
  }

  void _selectCountry(Country country) {
    setState(() {
      _selectedCountry = country;
      _showCountryPicker = false;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Enter Phone Number'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: SingleChildScrollView(  // ADD THIS
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter your phone number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We\'ll send a verification code to this number',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            
            // Phone input with custom country picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country selector button
                GestureDetector(
                  onTap: _showCountrySelection,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _selectedCountry.flag,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedCountry.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _selectedCountry.dialCode,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          _showCountryPicker
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Country list (when expanded)
                if (_showCountryPicker) ...[
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        return ListTile(
                          leading: Text(
                            country.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                          title: Text(country.name),
                          trailing: Text(
                            country.dialCode,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () => _selectCountry(country),
                        );
                      },
                    ),
                  ),
                ],
                
                const SizedBox(height: 15),
                
                // Phone number input
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixText: _selectedCountry.dialCode,
                    prefixStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            
            // Preview
            if (_phoneController.text.isNotEmpty) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Full number: ${_selectedCountry.dialCode}${_phoneController.text}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendVerificationCode,
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
                        'Send Verification Code',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Footer
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    'For testing, use any 7+ digit number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Example: 6505551234',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}