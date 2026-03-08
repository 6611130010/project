# VocabVault: Smart Flashcard & Translator

แอปพลิเคชัน Flutter สำหรับการเรียนรู้คำศัพท์ผ่านการแปลภาษาที่ขับเคลื่อนด้วย AI และระบบการทบทวนแบบ Flashcard แอปนี้ใช้ Google ML Kit สำหรับการจดจำข้อความ OCR และ Google Gemini AI สำหรับการวิเคราะห์คำและการแปลตามบริบท

## ✨ คุณสมบัติหลัก

### ฟังก์ชันการทำงานหลัก
- **การจดจำข้อความ OCR**: ถ่ายภาพข้อความจากกล้องหรือแกลเลอรี่ของอุปกรณ์
- **การวิเคราะห์ด้วย AI**: ใช้ Gemini AI ในการวิเคราะห์คำและให้ความหมายตามบริบท
- **ระบบ Flashcard**: การ์ดแบบโต้ตอบพร้อมอนิเมชันพลิกสำหรับการทบทวนคำศัพท์
- **Offline-First**: ฐานข้อมูลในเครื่องด้วย SQLite สำหรับการเข้าถึงแบบออฟไลน์
- **การจัดหมวดหมู่อัจฉริยะ**: การจำแนกประเภทคำอัตโนมัติ (noun, verb, adjective, etc.)

### การใช้งานทางเทคนิค
- **Clean Architecture**: โครงสร้างโค้ดที่เป็นระเบียบพร้อมการแบ่งแยกความรับผิดชอบที่ชัดเจน
- **State Management**: รูปแบบ BLoC สำหรับการจัดการสถานะที่คาดการณ์ได้
- **Dependency Injection**: GetIt สำหรับการจัดการ dependency ที่สะอาด
- **Local Storage**: ฐานข้อมูล SQLite พร้อม sqflite สำหรับการจัดเก็บข้อมูลอย่างถาวร
- **ML Integration**: Google ML Kit สำหรับการจดจำข้อความบนอุปกรณ์
- **AI Integration**: Google Generative AI (Gemini) สำหรับการวิเคราะห์ข้อความอัจฉริยะ
- **Routing**: Auto Route สำหรับการนำทางแบบ type-safe
- **Testing**: Unit tests และ widget tests สำหรับความน่าเชื่อถือของโค้ด

## 🏗️ Architecture ที่ใช้

แอปพลิเคชันนี้ใช้หลักการ **Clean Architecture** ที่ช่วยให้โค้ดสามารถบำรุงรักษาได้ง่ายและทดสอบได้:

### โครงสร้างโฟลเดอร์

```
lib/
├── config/                    # การกำหนดค่าและการตั้งค่า
│   ├── injection/            # Dependency Injection (GetIt)
│   └── router/               # การกำหนดเส้นทาง (Auto Route)
├── core/                     # Core utilities และ business logic
│   ├── constants/            # ค่าคงที่ของแอป
│   ├── error/                # การจัดการข้อผิดพลาด (Failures)
│   └── utils/                # เครื่องมือช่วยเหลือ (Database Helper)
├── data/                     # Data Layer - จัดการข้อมูล
│   ├── datasources/          # Data Sources (Local/Remote)
│   ├── models/               # Data Models (JSON serialization)
│   └── repositories/         # Repository Implementations
├── domain/                   # Domain Layer - Business Logic
│   ├── entities/             # Business Entities
│   ├── repositories/         # Abstract Repositories
│   └── usecases/             # Use Cases (Business Logic)
├── presentation/             # Presentation Layer - UI
│   ├── bloc/                 # BLoC State Management
│   ├── screens/              # UI Screens
│   └── widgets/              # Reusable Widgets
└── main.dart                 # จุดเริ่มต้นของแอป
```

### หลักการ Clean Architecture

1. **Dependency Rule**: Dependencies จะชี้เข้าด้านในเท่านั้น
   - Presentation → Domain → Data
   - ไม่มี dependency ที่ชี้กลับ

2. **Layers**:
   - **Presentation Layer**: จัดการ UI และ user interactions
   - **Domain Layer**: ประกอบด้วย business logic ที่เป็น pure Dart
   - **Data Layer**: จัดการ data sources และ repositories

3. **State Management**: ใช้ BLoC pattern
   - Events → BLoC → States
   - Separation of UI logic from business logic

## 🚀 วิธีการรันโปรเจกต์

### ข้อกำหนดเบื้องต้น (Prerequisites)

ก่อนที่จะเริ่ม คุณต้องมีสิ่งต่อไปนี้:

- **Flutter SDK**: version ^3.10.0 หรือสูงกว่า
  ```bash
  flutter --version
  ```

- **Dart SDK**: รวมอยู่ใน Flutter SDK

- **IDE**: Android Studio หรือ Visual Studio Code พร้อม Flutter extensions

- **อุปกรณ์**: Android/iOS device หรือ emulator/simulator

### ขั้นตอนการติดตั้งและรัน

#### 1. Clone โปรเจกต์

```bash
# Clone repository
git clone <repository-url>
cd vocabvault
```

#### 2. ตรวจสอบ Flutter Environment

```bash
# ตรวจสอบ Flutter installation
flutter doctor

# ตรวจสอบอุปกรณ์ที่เชื่อมต่อ
flutter devices
```

#### 3. ติดตั้ง Dependencies

```bash
# ติดตั้ง packages ทั้งหมด
flutter pub get
```

#### 4. สร้าง Code Generation

โปรเจกต์นี้ใช้ code generation สำหรับ:
- JSON serialization (json_serializable)
- Freezed classes
- Auto Route navigation

```bash
# สร้างไฟล์ที่ generate อัตโนมัติ
flutter pub run build_runner build
```

หากมีปัญหา สามารถใช้ watch mode:

```bash
# ใช้ watch mode สำหรับการ generate แบบ real-time
flutter pub run build_runner watch
```

#### 5. รันแอปพลิเคชัน

**สำหรับ Android:**
```bash
# รันบน Android device/emulator
flutter run
```

**สำหรับ iOS (เฉพาะ macOS):**
```bash
# รันบน iOS simulator/device
flutter run --platform ios
```

**สำหรับ Web:**
```bash
# รันบน browser
flutter run --platform web
```

#### 6. Build สำหรับ Production

**Android APK:**
```bash
# สร้าง APK
flutter build apk --release
```

**iOS (เฉพาะ macOS):**
```bash
# สร้าง iOS app
flutter build ios --release
```

### การทดสอบ (Testing)

#### รัน Unit Tests และ Widget Tests

```bash
# รัน tests ทั้งหมด
flutter test

# รัน test เฉพาะไฟล์
flutter test test/vocabulary_card_model_test.dart
flutter test test/home_screen_test.dart
```

#### รัน Integration Tests

```bash
# รัน integration tests
flutter test integration_test/
```

### การแก้ไขปัญหา (Troubleshooting)

#### ปัญหาที่พบบ่อย:

1. **Build Runner ไม่ทำงาน**
   ```bash
   # ล้าง cache และลองใหม่
   flutter pub run build_runner clean
   flutter pub run build_runner build
   ```

2. **Dependencies ไม่ติดตั้ง**
   ```bash
   # ล้าง pub cache
   flutter pub cache clean
   flutter pub get
   ```

3. **Android build ล้มเหลว**
   ```bash
   # ล้าง build cache
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter pub get
   flutter run
   ```

4. **iOS build ล้มเหลว**
   ```bash
   # สำหรับ macOS
   cd ios && pod install && cd ..
   flutter clean
   flutter pub get
   flutter run
   ```

## 📦 Dependencies หลัก

### State Management & Architecture
- **flutter_bloc**: ^8.1.5 - BLoC pattern implementation
- **bloc**: ^8.1.4 - Core BLoC library
- **get_it**: ^7.6.4 - Dependency injection

### Database & Storage
- **sqflite**: ^2.3.3 - SQLite database
- **path**: ^1.8.3 - Path manipulation
- **shared_preferences**: ^2.2.2 - Simple key-value storage

### AI & ML
- **google_mlkit_text_recognition**: ^0.11.0 - OCR text recognition
- **google_generative_ai**: ^0.4.0 - Gemini AI integration

### Networking & API
- **dio**: ^5.3.1 - HTTP client
- **json_annotation**: ^4.8.1 - JSON serialization

### UI & Navigation
- **auto_route**: ^8.0.0 - Type-safe routing
- **image_picker**: ^1.0.4 - Image selection
- **camera**: ^0.10.5+5 - Camera access

### Utilities
- **equatable**: ^2.0.5 - Value equality
- **dartz**: ^0.10.1 - Functional programming
- **uuid**: ^4.0.0 - UUID generation
- **intl**: ^0.19.0 - Internationalization

## 🔑 API Keys ที่จำเป็น

เพื่อใช้งานฟีเจอร์ AI คุณต้องกำหนด API keys:

### 1. Google AI (Gemini)
ใช้ไฟล์ `.env` เพื่อเก็บคีย์อย่างปลอดภัย (npm-style environment file) โดยเพิ่มบรรทัดต่อไปนี้:
```env
GEMINI_API_KEY=your_real_api_key_here
```
ไฟล์ `.env` ควรอยู่ที่ root ของโปรเจกต์และถูกระบุใน `pubspec.yaml` ภายใต้ `flutter.assets`.
โค้ดจะโหลดคีย์โดยอัตโนมัติเมื่อเริ่มแอป (`main.dart` เรียก `dotenv.load`).

(หากต้องการตั้งค่าสำหรับการทดลอง คุณยังสามารถแก้ไขคีย์ตรงๆ ใน
`lib/data/datasources/vocabulary_remote_data_source.dart` แต่
อย่าคอมมิตคีย์ลงในระบบควบคุมเวอร์ชัน)

### 2. Google ML Kit
- ML Kit ทำงานบนอุปกรณ์ ไม่ต้องมี API key เพิ่มเติม
- แต่ต้องกำหนดค่าใน Android/iOS platform code

## ⚡ Gemini API Quota & Models

### การเลือกโมเดลที่เหมาะสม
```env
# โมเดลแนะนำสำหรับการใช้งานทั่วไป (โควต้ามาก)
GEMINI_MODEL_NAME=gemini-1.5-flash

# โมเดลอื่นๆ ที่สามารถเลือกใช้:
# gemini-pro (โควตาปานกลาง)
# gemini-1.5-pro (โควตาน้อยกว่า แต่ฉลาดกว่า)
```

### การจัดการโควต้า
- **Free Tier**: จำกัดจำนวน requests และ tokens ต่อวัน
- **หากใช้เกินโควต้า**: แอปจะแสดงข้อความแจ้งเตือนพร้อมวิธีแก้ไข
- **วิธีแก้ไข**:
  1. รอให้โควต้ารีเซ็ต (ประมาณ 24 ชั่วโมง)
  2. อัปเกรดเป็น Google AI Studio Pro
  3. เปลี่ยนเป็นโมเดลที่มีโควต้ามากขึ้น

🔗 ดูรายละเอียดโควต้า: https://ai.google.dev/gemini-api/docs/rate-limits

## 🤝 การมีส่วนร่วม (Contributing)

1. **ทำตามหลัก Clean Architecture**
2. **เขียน tests สำหรับฟีเจอร์ใหม่**
3. **ใช้ commit messages ที่มีความหมาย**
4. **ตรวจสอบ code formatting**
   ```bash
   flutter format .
   ```

## � Troubleshooting

### Database Issues
หากพบ error เกี่ยวกับ SQLite column (เช่น `no column named exampleSentences`):

1. **ใช้ฟีเจอร์ Reset Database ในแอป**:
   - เปิดแอป VocabVault
   - แตะ ⋮ ที่มุมขวาบน → Reset Database
   - ยืนยันการลบข้อมูล

2. **หรือ reset แบบ manual** (สำหรับ development):
   ```dart
   // ใน main.dart ชั่วคราว
   await DatabaseHelper.instance.resetDatabase();
   ```

3. **Migration จะทำงานอัตโนมัติ** เมื่ออัปเดตแอปเป็น version ใหม่

### Gemini API Issues
- **Quota exceeded**: รอให้โควต้ารีเซ็ต หรือเปลี่ยนโมเดลที่มีโควต้ามากขึ้น
- **Model not found**: ตรวจสอบ `GEMINI_MODEL_NAME` ใน `.env`
- **Invalid API key**: ตรวจสอบ key จาก https://aistudio.google.com/

### Build Issues
```bash
# ล้าง cache และ rebuild
flutter clean
flutter pub get
flutter run
```

## �📄 License

โปรเจกต์นี้อยู่ภายใต้ MIT License - อ่านรายละเอียดได้ที่ไฟล์ LICENSE

This project is licensed under the MIT License - see the LICENSE file for details.
