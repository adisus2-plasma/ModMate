# ModMate

## 📝 ข้อมูลโครงการวิจัย (Research Project Information)

| หัวข้อ | รายละเอียด |
| :--- | :--- |
| **หัวข้อโครงการวิจัย** | การพัฒนาแอปพลิเคชันให้ความรู้เกี่ยวกับการออกกำลังกายในรูปแบบเวทเทรนนิ่งด้วยตนเองโดยใช้ร่วมกับเทคโนโลยีความเป็นจริงเสริม (AR) |
| **ผู้เขียน** | นางสาวธมิดา พาหูถิตย์ |
| **อาจารย์ที่ปรึกษา** | ผศ.ดร. ชุดาณัฏฐ์ สุดคงทอง |
| **หลักสูตร** | ปริญญาเทคโนโลยีบัณฑิต โครงการร่วมบริหารหลักสูตรมีเดียอาตส์และเทคโนโลยีมีเดีย |
| **สาขาวิชา** | มีเดียทางการแพทย์และวิทยาศาสตร์ |
| **คณะ** | สถาปัตยกรรมศาสตร์และการออกแบบ |
| **มหาวิทยาลัย** | มหาวิทยาลัยเทคโนโลยีพระจอมเกล้าธนบุรี |
| **ปีการศึกษา** | 2568 |
> ซอร์สโค้ดของแอปอยู่ในโฟลเดอร์ [modmate_project/](modmate_project/) (Flutter project)

---

## สารบัญ
- [ภาพรวมแอป](#ภาพรวมแอป)
- [Tech Stack](#tech-stack)
- [ข้อกำหนดของเครื่อง (Prerequisites)](#ข้อกำหนดของเครื่อง-prerequisites)
- [การติดตั้ง (Setup)](#การติดตั้ง-setup)
- [การรันแอป](#การรันแอป)
- [การ Build เพื่อ Release](#การ-build-เพื่อ-release)
- [โครงสร้างโปรเจกต์](#โครงสร้างโปรเจกต์)
- [Dependencies หลัก](#dependencies-หลัก)
- [Troubleshooting](#troubleshooting)

---

## ภาพรวมแอป
- ระบบสมาชิก (Register / Login / Forgot Password) ผ่าน Firebase
- คำนวณ BMI, BMR, TDEE และแปลงหน่วย lbs/kg
- คลังท่าออกกำลังกายแยกตามกลุ่มกล้ามเนื้อ (อก, หลัง, ขา, แขน, ไหล่, แกนกลาง)
- วิดีโอประกอบท่าออกกำลังกาย
- โหมด AR แสดงโมเดล 3 มิติของท่าออกกำลังกาย (รองรับเฉพาะ **iOS** ที่มี ARKit)
- หน้า Tips สำหรับให้คำแนะนำเรื่องการออกกำลังกาย

---

## Tech Stack
| ส่วน | เทคโนโลยี |
|------|-----------|
| Framework | Flutter (Dart SDK `^3.10.8`) |
| Backend / Auth / DB | Firebase (Cloud Firestore) |
| AR | ARKit (`arkit_plugin`) + GLTFSceneKit |
| Local Storage | `flutter_secure_storage`, `shared_preferences` |
| Media | `video_player` |

---

## ข้อกำหนดของเครื่อง (Prerequisites)

### สำหรับทุก Platform
- **Flutter SDK** เวอร์ชันที่รองรับ Dart `^3.10.8` (แนะนำ Flutter `>=3.24.x`)
  ดาวน์โหลด: https://docs.flutter.dev/get-started/install
- **Git**
- **FlutterFire CLI** (ใช้กรณีต้องสร้าง `firebase_options.dart` ใหม่)
  ```bash
  dart pub global activate flutterfire_cli
  ```

### สำหรับ iOS (รวมถึงโหมด AR)
- **macOS** เท่านั้น
- **Xcode** เวอร์ชันล่าสุด (รองรับ iOS 13.0 ขึ้นไป)
- **CocoaPods**
  ```bash
  sudo gem install cocoapods
  ```
- **อุปกรณ์จริง iPhone/iPad** ที่รองรับ ARKit (A9 chip ขึ้นไป) — Simulator ใช้โหมด AR ไม่ได้
- **Apple Developer Account** สำหรับ Sign & Run บนเครื่องจริง

### สำหรับ Android
- **Android Studio** (เพื่อใช้ Android SDK, Platform Tools และ Emulator)
- **JDK 17** ขึ้นไป
- **Android SDK** API 21 (Lollipop) ขึ้นไป
- หมายเหตุ: ฟีเจอร์ AR ในโปรเจกต์นี้ใช้ `arkit_plugin` ซึ่ง**รองรับเฉพาะ iOS** ฟีเจอร์อื่น ๆ ใช้งานบน Android ได้ปกติ

---

## การติดตั้ง (Setup)

### 1. Clone โปรเจกต์
```bash
git clone <repo-url>
cd ModMate/modmate_project
```

### 2. ตรวจสอบ Environment
```bash
flutter doctor
```
แก้ปัญหาที่ `flutter doctor` แจ้งให้ครบก่อนรันต่อ

### 3. ติดตั้ง Dependencies ของ Flutter
```bash
flutter pub get
```

### 4. ตั้งค่า Firebase
โปรเจกต์เชื่อมต่อกับ Firebase project `modmate-database` อยู่แล้ว โดยมีไฟล์ต่อไปนี้ใน repo:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

**หากต้องการเชื่อมต่อกับ Firebase project อื่น** ให้รัน:
```bash
flutterfire configure
```

### 5. ติดตั้ง iOS Pods (เฉพาะ macOS)
```bash
cd ios
pod install
cd ..
```
> ถ้าเจอปัญหา dependency conflict ให้ลอง `pod repo update` ก่อนแล้วรัน `pod install` ใหม่

### 6. ตั้งค่า App Icon (ถ้าจำเป็น)
```bash
flutter pub run flutter_launcher_icons
```

---

## การรันแอป

### Run บน iOS Simulator / iPhone (แนะนำสำหรับทดสอบ AR)
```bash
flutter run
```
เลือก device ที่ต้องการ หรือระบุด้วย `flutter run -d <device-id>`
(ดูรายการ device ด้วย `flutter devices`)

### Run บน Android Emulator / Device
```bash
flutter run -d <android-device-id>
```

> **หมายเหตุสำหรับโหมด AR:** ต้องรันบน **iPhone/iPad ตัวจริง** เท่านั้น Simulator ไม่รองรับกล้องและ ARKit

---

## การ Build เพื่อ Release

### iOS
```bash
flutter build ios --release
```
จากนั้นเปิด `ios/Runner.xcworkspace` ด้วย Xcode เพื่อ Archive และ Upload

### Android (APK / App Bundle)
```bash
flutter build apk --release
flutter build appbundle --release
```

---

## โครงสร้างโปรเจกต์
```
ModMate/
├── modmate_project/         # Flutter source code
│   ├── lib/
│   │   ├── main.dart
│   │   ├── splash_page.dart
│   │   ├── firebase_options.dart
│   │   ├── onboarding/      # หน้า Onboarding
│   │   ├── pages/           # หน้าหลักทั้งหมด
│   │   │   ├── ar/          # โหมด AR
│   │   │   ├── workoutPages/
│   │   │   ├── assessment/
│   │   │   ├── tips/
│   │   │   └── privacy/
│   │   └── services/        # Firebase auth service
│   ├── assets/
│   │   ├── workout_vdo/     # วิดีโอท่าออกกำลังกาย
│   │   ├── workout_ar_model/# โมเดล .usdz สำหรับ AR
│   │   ├── workout_img/     # ภาพประกอบ
│   │   └── body/            # ภาพกลุ่มกล้ามเนื้อ
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── modmate_manual.pdf       # คู่มือการใช้งานแอป
└── modmate_manual.html
```

---

## Dependencies หลัก
ดูเวอร์ชันเต็มที่ [modmate_project/pubspec.yaml](modmate_project/pubspec.yaml)

| Package | หน้าที่ |
|---------|---------|
| `firebase_core` `2.15.0` | เริ่มต้นใช้งาน Firebase (Pin version เพื่อเลี่ยง conflict กับ ARCore) |
| `cloud_firestore` `4.8.0` | NoSQL Database |
| `arkit_plugin` `^1.3.0` | โหมด AR บน iOS |
| `vector_math` `^2.1.4` | คำนวณตำแหน่ง/หมุนวัตถุใน AR |
| `video_player` `^2.8.1` | เล่นวิดีโอท่าออกกำลังกาย |
| `flutter_secure_storage` `^10.0.0` | เก็บข้อมูลผู้ใช้แบบเข้ารหัส |
| `shared_preferences` `^2.2.3` | เก็บ Preferences ของผู้ใช้ |
| `crypto` `^3.0.7` | Hash password / utilities |
| `path_provider` `^2.1.5` | เข้าถึง file system path |
| `cupertino_icons` `^1.0.8` | Icon style iOS |
| `flutter_launcher_icons` `^0.14.1` (dev) | Generate App Icon |
| `flutter_lints` `^6.0.0` (dev) | Lint rules |

### iOS-specific Pods
- `GLTFSceneKit` — โหลดโมเดล 3D (`.usdz`/`.gltf`) เข้า SceneKit
- `abseil` (modular_headers) — แก้ปัญหา Firebase/gRPC link conflict

---

## Troubleshooting

### iOS build error: `-G` flag / gRPC compile fail
Podfile มี `post_install` และ `post_integrate` ที่จัดการเรื่องนี้แล้ว ถ้าเจอปัญหาให้รัน:
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### Firebase initialization error
ตรวจสอบว่ามีไฟล์ครบทั้ง 3:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

ถ้าหายให้รัน `flutterfire configure` ใหม่

### AR ไม่ทำงาน / ไม่เห็นโมเดล
- ต้องรันบนเครื่อง iPhone/iPad **ตัวจริง**เท่านั้น
- ตรวจสอบ `Info.plist` มี key `NSCameraUsageDescription`
- iOS version >= 13.0

### `flutter pub get` ค้างหรือเกิด conflict
```bash
flutter clean
rm pubspec.lock
flutter pub get
```

---

## เอกสารเพิ่มเติม
- คู่มือผู้ใช้แอป: [modmate_manual.pdf](modmate_manual.pdf)

## License
Thesis project — Internal use only
