# Flutter Setup Guide for StudyPad Mobile

This guide will help you install Flutter and set up your development environment for StudyPad Mobile.

## Installation Steps

### 1. Install Flutter on macOS

```bash
# Navigate to your development directory
cd ~/development

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to your PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# Reload your shell configuration
source ~/.zshrc

# Verify installation
flutter --version
```

### 2. Run Flutter Doctor

This command checks your environment and displays a report:

```bash
flutter doctor
```

You'll see a checklist of items to fix. Common items:

- **Android toolchain**: Need to install Android Studio
- **Xcode**: Need to install Xcode (for iOS development)
- **CocoaPods**: Need to install CocoaPods (for iOS dependencies)

### 3. Install Android Studio (Required for Android Development)

1. **Download Android Studio**: [https://developer.android.com/studio](https://developer.android.com/studio)

2. **Install Android Studio**:
   - Open the downloaded DMG file
   - Drag Android Studio to Applications
   - Launch Android Studio
   - Follow the setup wizard

3. **Install Flutter and Dart plugins**:
   - Open Android Studio
   - Go to: Preferences > Plugins
   - Search for "Flutter" and install
   - Search for "Dart" and install (usually installed with Flutter)
   - Restart Android Studio

4. **Configure Android SDK**:
   ```bash
   flutter doctor --android-licenses
   # Accept all licenses by typing 'y'
   ```

### 4. Install Xcode (Required for iOS Development - Mac Only)

1. **Install Xcode**:
   ```bash
   # Install from App Store
   # Or use command line:
   xcode-select --install
   ```

2. **Configure Xcode**:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **Accept Xcode license**:
   ```bash
   sudo xcodebuild -license accept
   ```

4. **Install CocoaPods** (iOS dependency manager):
   ```bash
   sudo gem install cocoapods
   pod setup
   ```

### 5. Verify Installation

Run Flutter doctor again to ensure everything is set up:

```bash
flutter doctor -v
```

You should see checkmarks (✓) for:
- Flutter SDK
- Android toolchain
- Xcode (for iOS)
- Android Studio
- VS Code or IntelliJ (optional)

## Initialize the StudyPad Mobile Project

Once Flutter is installed, initialize the project:

```bash
# Navigate to project directory
cd ~/projects/studypad-mobile

# Create Flutter project structure (in existing directory)
flutter create .

# Get dependencies
flutter pub get
```

## Set Up Emulators/Simulators

### Android Emulator

1. Open Android Studio
2. Go to: Tools > Device Manager
3. Click "Create Device"
4. Choose a device (e.g., Pixel 6)
5. Download a system image (e.g., API 33)
6. Finish setup

**Start emulator:**
```bash
# List available emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch <emulator_id>
```

### iOS Simulator

```bash
# List available simulators
xcrun simctl list devices

# Open default simulator
open -a Simulator
```

## Test Your Setup

```bash
# Check available devices
flutter devices

# Create a test app
cd ~/development
flutter create test_app
cd test_app

# Run the app
flutter run
```

## Common Issues and Solutions

### Issue: "cmdline-tools component is missing"

```bash
# Open Android Studio
# Go to: Preferences > Appearance & Behavior > System Settings > Android SDK
# Select "SDK Tools" tab
# Check "Android SDK Command-line Tools"
# Click Apply
```

### Issue: "Unable to find bundled Java version"

```bash
# Set JAVA_HOME
echo 'export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jbr/Contents/Home' >> ~/.zshrc
source ~/.zshrc
```

### Issue: CocoaPods not working

```bash
# Reinstall CocoaPods
sudo gem uninstall cocoapods
sudo gem install cocoapods
pod setup
```

### Issue: Xcode build fails

```bash
# Clean and rebuild
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

## Editor Setup (Optional but Recommended)

### VS Code

1. Install VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Install Flutter extension:
   - Open VS Code
   - Go to Extensions (⌘+Shift+X)
   - Search "Flutter" and install
   - Search "Dart" and install

### IntelliJ IDEA / Android Studio

Already set up if you followed the Android Studio steps above.

## Next Steps

After installation:

1. **Read the README**: See `README.md` for project structure and usage
2. **Configure API**: Edit `lib/config/api_config.dart` with your backend URL
3. **Run the app**: `flutter run`
4. **Start developing**: Begin with the screens in `lib/screens/`

## Resources

- [Flutter Installation Guide](https://flutter.dev/docs/get-started/install/macos)
- [Flutter Doctor](https://flutter.dev/docs/get-started/install/macos#run-flutter-doctor)
- [Android Studio Setup](https://developer.android.com/studio/install)
- [Xcode Setup](https://developer.apple.com/xcode/)

## Get Help

If you encounter issues:
1. Run `flutter doctor -v` for detailed diagnostics
2. Check [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
3. Visit [Flutter Community](https://flutter.dev/community)

---

**After completing this setup, return to the main README.md for project-specific instructions.**
