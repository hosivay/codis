# Codis (کدیس)

**Secure text encryption and decryption** — An open-source, cross-platform app to lock and unlock text with a secret key, with full support for Persian (Farsi).

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Open%20Source-blue)](https://github.com/hosivay/codis)

---

## Introduction

Codis is an **open-source** project that lets you encrypt sensitive text (notes, passwords, links, etc.) with a **secret key** and decrypt it only with the same key. Cipher output is shown as **Persian characters** so you can copy and share it anywhere (chat, email, notes) without relying on a third-party service; everything runs on your device.

The app runs on **Web, Android, iOS, Windows, and macOS**, and is suitable for personal use, teams, or developers who want to inspect or extend the encryption logic.

---

## Features

- **Encrypt and decrypt text** with a secret key (password)
- **Full Persian support**: input and cipher output use 64 Persian characters (Persian Base64–style encoding)
- **Markdown in results**: headings, lists, links, etc. are rendered; links are clickable
- **Long text**: encrypt and decrypt long content without practical limits
- **Copy, share, and full-screen view** for results
- **Light / dark theme** and **responsive** layout for mobile and desktop
- **App version** at the bottom and **GitHub** link in the header

---

## Technical Details (Security & Cryptography)

Codis uses standard, secure algorithms:

| Component | Description |
|-----------|-------------|
| **Cipher** | **AES-256-CBC** (128-bit block, 256-bit key) |
| **Key derivation** | **PBKDF2** with **HMAC-SHA256**, 16-byte random salt, 6,000 iterations; 64-byte output (32 for AES, 32 for HMAC) |
| **Authentication** | **Encrypt-then-MAC**: after encryption, a 32-byte tag is computed with **HMAC-SHA256** over salt + IV + ciphertext and verified on decrypt (constant-time comparison to mitigate side-channel attacks) |
| **Raw output format** | `salt (16) \|\| iv (16) \|\| ciphertext \|\| tag (32)`; this byte sequence is then encoded with **64 Persian characters** into a string |
| **Output encoding** | 64 unique Persian digits and letters (similar to Base64 but with a Persian alphabet); decrypt input is normalized (whitespace trimmed, Arabic–Persian Unicode mapping) |

Encryption and decryption run in an **isolate** (background) so the UI stays responsive; on web, where true isolates are not available, PBKDF2 iteration count is tuned for short run time and smooth UX.

---

## Platforms

| Platform | Status |
|----------|--------|
| Web (Chrome, Firefox, Safari, Edge) | ✅ |
| Android | ✅ |
| iOS | ✅ |
| Windows | ✅ |
| macOS | ✅ |

---

## Prerequisites

- [Flutter](https://flutter.dev) (SDK ^3.8.1)
- [Dart](https://dart.dev) ^3.8.1

---

## Install & Run

### 1. Clone the repo

```bash
git clone https://github.com/hosivay/codis.git
cd codis
```

### 2. Dependencies

```bash
flutter pub get
```

### 3. Run

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows

# macOS
flutter run -d macos
```

### 4. Build

```bash
# Web
flutter build web

# Android (APK)
flutter build apk

# Android (App Bundle for store)
flutter build appbundle

# iOS
flutter build ios

# Windows
flutter build windows

# macOS
flutter build macos
```

Outputs go to Flutter’s standard paths (e.g. `build/web`, `build/app/outputs/`, etc.).

---

## Project Structure (Overview)

```
lib/
├── core/                 # Constants, theme, palette, Persian encoding
├── features/
│   └── cipher/           # Encryption / decryption feature
│       ├── data/         # Repository and isolate
│       ├── domain/       # CipherService and crypto logic
│       └── presentation/ # Pages, ViewModel, widgets
├── app.dart
└── main.dart
```

Layers follow an **MVVM**, modular structure; the domain layer has no Flutter dependency.

---

## Contributing (Open Source)

Codis is **open source**. To contribute:

1. Fork the repo.
2. Create a branch for your changes (`git checkout -b feature/...`).
3. Commit and push.
4. Open a **Pull Request** against the main repo.

You can also help by reporting bugs, suggesting features, or improving documentation.

---

## License

This project is released under an open-source license. See the license file in the repo for details.

---

## Links

- **GitHub**: [github.com/hosivay/codis](https://github.com/hosivay/codis)
- **Persian README**: [README-FA.md](README-FA.md)
