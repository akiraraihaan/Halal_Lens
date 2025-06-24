# HalalLens 📱

A mobile app that helps Muslims verify the halal status of food products using barcode scanning and OCR, with accessibility features for travelers, seniors, and the color-blind.

---

## 🧠 Features

- **Barcode scanning** to instantly retrieve product details.
- **OCR-based text recognition** to scan ingredient lists from packaging.
- **Accessibility-first design**, specially tailored for:
  - Seniors (larger fonts/UI elements)
  - Users with color vision deficiencies (high-contrast themes, color-blind modes)
- **Multilingual support** to assist travelers facing unfamiliar ingredient terms.

---

## 👥 Target Users & Challenges

HalalLens is designed to support:

1. **Frequent travelers** — by translating ingredients and recognizing foreign food labels.
2. **Seniors** — through simplified UI, larger touch targets, and clear visuals.
3. **Color-blind users** — via customizable high-contrast themes and color-tested UI elements.

---

## 📱 Tech Stack

- **Flutter** – single codebase for Android and iOS.
- **Barcode Scanner** – mobile camera integration for real-time scanning.
- **Tesseract OCR** – embedded library for text recognition.
- **State Management** – [e.g., `Provider` / `Bloc` / `Riverpod`].
- **Localization/i18n** – support for multiple languages (e.g., English, Bahasa Indonesia).

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0)
- Android Studio / Xcode
- Physical device or emulator (with camera support)

### Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/alghifrz/HalalLens.git
   cd HalalLens
    ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## 📁 Project Structure
    ```
    HalalLens/
├─ android/ iOS platform code  
├─ assets/images/ app icons & UI assets  
├─ lib/
│   ├─ main.dart         # Entry point
│   ├─ screens/          # UI pages (Scanner, Results, Settings)
│   ├─ widgets/          # Reusable components (Buttons, Cards)
│   ├─ models/           # Data models (Product, Ingredient)
│   ├─ services/         # Scanner, OCR, API integration
│   ├─ providers/        # State management logic
├─ test/                 # Unit & widget tests
├─ pubspec.yaml          # Project metadata & dependencies
└─ README.md             # This document
    ```

---

## 🧪 Usage

1. Open the app and grant camera permission.

2. Choose between:

- Scan barcode manually.

- Use OCR to capture ingredient text.

3. View the result:

- ✔️ Halal / ❌ Not Halal / ⚠️ Requires review

- Detailed ingredient breakdown

- Option to translate ingredient terms (and save favorites)

---

## 📈 Roadmap & Enhancements

- Add more languages and specific region-based ingredients.

- Integrate database of halal certifications and expiry date detection.

- Offline scanning with local storage and background OCR processing.

- Dark mode and enhanced accessibility controls.

---

## 📚 References & Resources

- Tesseract OCR – open-source OCR engine

- Flutter – official documentation for mobile UI

- MIT License – see [LICENSE] file
