# StudyPad Mobile

Flutter mobile application for StudyPad - AI-powered learning platform for iOS and Android.

## Overview

StudyPad Mobile brings the power of AI-assisted learning to your mobile device. Upload documents, ask questions, and generate study materials on the go.

## Features (Planned)

- **Document Upload**: Upload PDF documents from your device
- **AI Chat**: Ask questions about your documents using RAG
- **Audio Recording**: Record lectures and generate transcriptions
- **Study Materials**: Generate study guides, summaries, and briefings
- **Offline Support**: Access previously downloaded content offline
- **Cross-Platform**: Native performance on both iOS and Android

## Tech Stack

- **Flutter 3.x**: Cross-platform mobile framework
- **Dart**: Programming language
- **Provider/Riverpod**: State management
- **Dio**: HTTP client for API calls
- **Hive/SQLite**: Local storage
- **Audio Recorder**: For lecture capture

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK 3.x or higher**: [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: (Comes with Flutter)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development - Mac only)
- **Git**

### Platform-Specific Requirements

**For Android:**
- Android Studio
- Android SDK (API 21 or higher)
- Android Emulator or physical device

**For iOS:**
- macOS (required)
- Xcode 14 or higher
- iOS Simulator or physical device
- Apple Developer account (for deployment)

## Getting Started

### 1. Install Flutter

If you haven't installed Flutter yet, follow the official guide:

**macOS:**
```bash
# Download Flutter SDK
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/development/flutter/bin"

# Verify installation
flutter doctor
```

**Fix any issues reported by `flutter doctor` before proceeding.**

### 2. Clone the Repository

```bash
cd ~/projects
git clone https://github.com/qvidal01/studypad-mobile.git
cd studypad-mobile
```

### 3. Initialize Flutter Project

Once Flutter is installed, initialize the project:

```bash
# This will create the Flutter project structure
flutter create .

# Get dependencies
flutter pub get
```

### 4. Configure Backend API

Create a configuration file for the backend API:

**lib/config/api_config.dart:**
```dart
class ApiConfig {
  // Development - your homelab
  static const String devBaseUrl = 'http://192.168.1.x:8000';

  // Production - when deployed
  static const String prodBaseUrl = 'https://api.studypad.yourdomain.com';

  // Current environment
  static const String baseUrl = devBaseUrl;

  // API endpoints
  static const String uploadEndpoint = '/api/v1/upload';
  static const String documentsEndpoint = '/api/v1/documents';
  static const String queryEndpoint = '/api/v1/query';
  static const String studioEndpoint = '/api/v1/studio';
}
```

### 5. Run the App

**Android:**
```bash
# Start Android emulator or connect device
flutter devices

# Run the app
flutter run
```

**iOS:**
```bash
# Open iOS simulator
open -a Simulator

# Run the app
flutter run
```

## Project Structure

```
studypad-mobile/
├── android/                 # Android-specific files
├── ios/                     # iOS-specific files
├── lib/
│   ├── config/             # Configuration files
│   │   └── api_config.dart # API endpoints configuration
│   ├── models/             # Data models
│   │   ├── document.dart
│   │   ├── message.dart
│   │   └── studio_job.dart
│   ├── services/           # API and business logic
│   │   ├── api_service.dart
│   │   ├── audio_service.dart
│   │   └── storage_service.dart
│   ├── providers/          # State management
│   │   ├── document_provider.dart
│   │   └── chat_provider.dart
│   ├── screens/            # UI screens
│   │   ├── home_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── upload_screen.dart
│   │   ├── documents_screen.dart
│   │   └── studio_screen.dart
│   ├── widgets/            # Reusable UI components
│   │   ├── document_card.dart
│   │   ├── message_bubble.dart
│   │   └── upload_button.dart
│   └── main.dart           # App entry point
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Dependencies
└── README.md               # This file
```

## Backend Connection

This mobile app connects to the StudyPad backend API.

- **Backend Repository**: [studypad-backend](https://github.com/qvidal01/studypadlm)
- **Web Frontend**: [studypad-web](https://github.com/qvidal01/studypad-web)
- **API Documentation**: See backend repo's `API_ENDPOINTS.md`

### API Endpoints

The mobile app uses these backend endpoints:

- `POST /api/v1/upload` - Upload document
- `GET /api/v1/documents` - List documents
- `DELETE /api/v1/documents/:id` - Delete document
- `POST /api/v1/query` - Query documents (chat)
- `POST /api/v1/studio` - Generate content (audio, video, study guides)

## Development Workflow

### 1. Hot Reload

Flutter supports hot reload for instant feedback:
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### 2. Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/api_service_test.dart

# Run with coverage
flutter test --coverage
```

### 3. Building for Release

**Android (APK):**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android (App Bundle for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
flutter build ios --release
# Then open in Xcode to archive and submit
```

## Dependencies (To Be Added)

Key Flutter packages that will be used:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.0.0

  # HTTP & API
  dio: ^5.0.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Audio Recording
  record: ^4.4.4
  audioplayers: ^5.0.0

  # File Picking
  file_picker: ^5.3.0

  # UI Components
  flutter_markdown: ^0.6.14

  # Utilities
  intl: ^0.18.0
  path_provider: ^2.0.15
```

## Configuration

### Android Configuration

Edit `android/app/build.gradle`:
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 33 or higher
- Permissions: Internet, storage, microphone

### iOS Configuration

Edit `ios/Runner/Info.plist`:
- Add permissions for camera, microphone, photo library
- Configure App Transport Security for local development

## Troubleshooting

### Flutter Doctor Issues

Run `flutter doctor` and fix any issues:
```bash
flutter doctor -v
```

### Android Emulator Not Starting
```bash
# List available devices
flutter devices

# Create new emulator in Android Studio
# Tools > Device Manager > Create Device
```

### iOS Build Errors
```bash
# Clean and rebuild
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter run
```

### Network Issues (Cannot Connect to Backend)

For Android emulator to connect to localhost:
```dart
// Use 10.0.2.2 instead of localhost or 127.0.0.1
static const String devBaseUrl = 'http://10.0.2.2:8000';
```

For iOS simulator:
```dart
// Use localhost or your Mac's local IP
static const String devBaseUrl = 'http://localhost:8000';
// or
static const String devBaseUrl = 'http://192.168.1.x:8000';
```

## Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests: `flutter test`
5. Commit: `git commit -m "Add amazing feature"`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check for issues
- Format code: `flutter format .`

## Roadmap

### Phase 1: Basic Functionality (Current)
- [ ] Set up Flutter project structure
- [ ] Implement API client
- [ ] Create document upload screen
- [ ] Build chat interface

### Phase 2: Core Features
- [ ] Audio recording and upload
- [ ] Document management
- [ ] Offline document access
- [ ] Push notifications

### Phase 3: Advanced Features
- [ ] Studio features (generate audio, video, study guides)
- [ ] Search within documents
- [ ] Document annotations
- [ ] Dark mode

### Phase 4: Polish & Release
- [ ] Performance optimization
- [ ] App store assets
- [ ] Beta testing
- [ ] Release to App Store and Play Store

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [StudyPad Backend API Docs](https://github.com/qvidal01/studypadlm)

## License

This project is part of StudyPad. See the main repository for license information.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Inspired by NotebookLM
- Part of the StudyPad ecosystem

---

**Made with ❤️ for mobile learning**
