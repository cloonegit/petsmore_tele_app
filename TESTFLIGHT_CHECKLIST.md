# iOS TestFlight Preparation Checklist

## ✅ Completed Changes (2026-01-30)

### 1. **Package Name Updated**
- Changed from `petsmore_tele_app` to `petsmore_tele_app` in `pubspec.yaml`
- Updated description to "Petsmore Telemarketing App"

### 2. **Version Numbers Synchronized**
- **Version**: 1.0.0
- **Build Number**: 1
- Synced across:
  - ✅ `pubspec.yaml`
  - ✅ Xcode project (`MARKETING_VERSION` and `CURRENT_PROJECT_VERSION`)

### 3. **Info.plist Fixed**
**Added:**
- ✅ `NSLocationWhenInUseUsageDescription` - Required for location features
- ✅ `ITSAppUsesNonExemptEncryption` - Export compliance declaration

**Improved Privacy Descriptions:**
- ✅ Camera usage description (more detailed)
- ✅ Photo library usage descriptions (more specific)
- ✅ File provider usage description (clearer purpose)

**Removed/Fixed:**
- ✅ Removed empty `LSApplicationCategoryType`
- ✅ Removed empty string from `LSApplicationQueriesSchemes` array
- ✅ **Re-added** `UILaunchStoryboardName` set to `LaunchScreen` - **CRITICAL FIX for full screen display**
- ✅ **Added** `https` to `LSApplicationQueriesSchemes` - **REQUIRED for WhatsApp sharing on iOS**

> **Note:** UILaunchStoryboardName was initially removed because it had an empty value, but this caused the app to display in 4:3 aspect ratio (letterboxed) on TestFlight. iOS requires this key to recognize modern screen sizes.

> **WhatsApp Fix:** iOS requires the `https` URL scheme to be declared for the `share_whatsapp` package to properly detect and open WhatsApp. Without it, WhatsApp sharing fails silently on iOS while working fine on Android.

### 4. **Privacy Manifest Created**
- ✅ Created `ios/Runner/PrivacyInfo.xcprivacy`
- Declares:
  - Location data collection (for app functionality)
  - Photos/videos access (for app functionality)
  - File timestamp API usage
  - UserDefaults API usage
  - No tracking enabled

### 5. **Project Cleaned**
- ✅ Ran `flutter clean`
- ✅ Ran `flutter pub get`

---

## 📋 Pre-TestFlight Submission Checklist

### Before Building for TestFlight:

#### 1. **Xcode Configuration**
- [ ] Open project in Xcode: `open ios/Runner.xcworkspace`
- [ ] Verify signing & capabilities:
  - [ ] Team selected
  - [ ] Bundle Identifier: `com.petsmore.telemarketing`
  - [ ] Provisioning profile configured
  - [ ] All capabilities enabled (if needed)

#### 2. **App Icon & Assets**
- [ ] Verify app icon is present in `ios/Runner/Assets.xcassets/AppIcon.appiconset`
- [ ] Ensure all required icon sizes are included (1024x1024 for App Store)
- [ ] Check launch screen/splash screen

#### 3. **Build Configuration**
- [ ] Set build configuration to **Release**
- [ ] Archive the app (Product → Archive in Xcode)
- [ ] Validate the archive before uploading

#### 4. **App Store Connect**
- [ ] App created in App Store Connect
- [ ] Bundle ID matches: `com.petsmore.telemarketing`
- [ ] App name: "Petsmore Telemarketing"
- [ ] Privacy policy URL added (if required)
- [ ] Support URL added
- [ ] Marketing URL (optional)

#### 5. **TestFlight Information**
- [ ] What to Test notes prepared
- [ ] Beta App Description written
- [ ] Test Information filled out
- [ ] Beta App Review Information completed

#### 6. **Compliance**
- [ ] Export compliance reviewed (encryption usage)
- [ ] Privacy nutrition labels prepared
- [ ] Age rating determined

---

## 🚀 Build Commands

### Option 1: Build via Flutter CLI
```bash
# Build iOS release
flutter build ios --release

# Then open Xcode to archive
open ios/Runner.xcworkspace
```

### Option 2: Build via Xcode
1. Open workspace: `open ios/Runner.xcworkspace`
2. Select "Any iOS Device (arm64)" as destination
3. Product → Archive
4. Wait for archive to complete
5. Click "Distribute App"
6. Select "App Store Connect"
7. Follow the wizard

---

## 🔍 Common Issues & Solutions

### Issue: "Missing Compliance"
**Solution:** Already added `ITSAppUsesNonExemptEncryption` set to `false` in Info.plist

### Issue: "Missing Privacy Descriptions"
**Solution:** All required privacy descriptions are now in Info.plist with detailed explanations

### Issue: "Version Mismatch"
**Solution:** Versions are now synced (1.0.0 build 1)

### Issue: "Provisioning Profile Errors"
**Solution:** 
1. Open Xcode
2. Go to Signing & Capabilities
3. Enable "Automatically manage signing"
4. Select your team

### Issue: "Archive Not Showing in Organizer"
**Solution:** Ensure you selected "Any iOS Device" (not a simulator) before archiving

### Issue: "App Displays in 4:3 Aspect Ratio (Letterboxed)"
**Problem:** App appears small with black bars on modern iPhones, not using full screen.  
**Solution:** ✅ **FIXED** - Added `UILaunchStoryboardName` key to Info.plist. iOS requires this to recognize the app supports modern screen sizes. Without it, iOS assumes the app is for older devices and letterboxes it.

**Verification:** After this fix, the app will use the full screen on all modern iPhones (including those with notches/dynamic island).

---

## 📱 Testing Before Submission

### Local Testing:
```bash
# Run on physical device
flutter run --release -d <device-id>

# List devices
flutter devices
```

### What to Test:
- [ ] **App uses full screen** (no black bars/letterboxing)
- [ ] Location features work correctly
- [ ] Camera/photo library access works
- [ ] **WhatsApp integration works** (share images to customer contacts)
- [ ] File downloads work
- [ ] All forms submit correctly
- [ ] App doesn't crash on launch
- [ ] All permissions are requested with proper descriptions

**WhatsApp Testing Steps:**
1. Navigate to a call summary with customer images
2. Tap "Share to Customer" button
3. Verify WhatsApp opens with the image attached
4. Verify customer phone number is pre-filled
5. Test on iOS device with WhatsApp installed

---

## 📝 Next Steps

1. **Build the app:**
   ```bash
   flutter build ios --release
   open ios/Runner.xcworkspace
   ```

2. **Archive in Xcode:**
   - Product → Archive
   - Wait for completion

3. **Upload to TestFlight:**
   - Window → Organizer
   - Select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Upload

4. **Configure TestFlight:**
   - Go to App Store Connect
   - Select your app
   - Go to TestFlight tab
   - Add build to test group
   - Add internal/external testers

5. **Submit for Beta Review** (for external testing)

---

## 📞 Support

**Bundle ID:** `com.petsmore.telemarketing`  
**App Name:** Petsmore Telemarketing  
**Version:** 1.0.0 (Build 1)  

**Key Files Modified:**
- `pubspec.yaml` - Package name and description
- `ios/Runner/Info.plist` - Privacy descriptions and compliance
- `ios/Runner.xcodeproj/project.pbxproj` - Version numbers
- `ios/Runner/PrivacyInfo.xcprivacy` - Privacy manifest (NEW)

---

**Last Updated:** 2026-01-30  
**Status:** ✅ Ready for TestFlight build
