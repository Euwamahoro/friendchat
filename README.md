# FriendChat ���️

A private messaging app for close friends with auto-delete functionality.

## ��� Current Status: Phase 1D - Authentication COMPLETE

### ✅ What's Working:
- **Splash Screen** - Branding & initialization
- **Login Screen** - Entry point with phone authentication
- **Phone Auth Screen** - Country picker with 15+ countries
- **OTP Screen** - 6-digit verification with timer
- **Main Screen** - Basic chat interface layout
- **Full Navigation Flow** - Complete authentication → main app
- **Firebase Setup** - Ready for real authentication

### ��� Features:
- Country selection with flag emojis
- Phone validation (minimum 7 digits)
- OTP auto-focus between input fields
- Resend code timer (60 seconds)
- Loading states & error handling
- Responsive UI for web/mobile
- Simulation mode for development

### ��� Screens Implemented:
1. `splash_screen.dart` - Launch screen
2. `login_screen.dart` - Authentication entry
3. `phone_auth_screen.dart` - Phone input with country picker
4. `otp_screen.dart` - Verification code input
5. `main_screen.dart` - Main chat interface
6. `countries.dart` - Custom country data

### ���️ Tech Stack:
- **Flutter 3.38.5** - Cross-platform framework
- **Firebase** - Authentication & database (simulation mode)
- **Dart 3.10.4** - Programming language
- **VS Code** - Development environment

## ��� Project Structure
friendchat/
├── lib/
│ ├── main.dart # App entry point
│ ├── firebase_options.dart # Firebase config
│ ├── features/
│ │ ├── auth/ # Authentication screens
│ │ │ ├── login_screen.dart
│ │ │ ├── phone_auth_screen.dart
│ │ │ └── otp_screen.dart
│ │ └── home/
│ │ └── main_screen.dart # Main chat interface
│ ├── core/
│ │ └── data/
│ │ └── countries.dart # Country data
│ └── services/ # (Future: Auth service)
├── pubspec.yaml # Dependencies
└── README.md # This file

## ��� Next Phase: Core Messaging
1. **Profile Setup Screen** - User name & photo
2. **Chat List Screen** - Conversations list
3. **Individual Chat Screen** - Message interface
4. **Firestore Integration** - Real-time messaging
5. **Media Sharing** - Images, voice notes, videos

## ��� Development Setup
```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/friendchat.git
cd friendchat

# Install dependencies
flutter pub get

# Run on Chrome (for development)
flutter run -d chrome

# Run on Android
flutter run -d android

# Build for production
flutter build apk
��� License
Private project - For personal use with friends

���‍��� Author
Built with ❤️ using Flutter & Firebase
