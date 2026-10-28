# Panduan Lengkap Upload Aplikasi MyHalaqoh ke Apple App Store

Dokumen ini adalah panduan langkah demi langkah (*step-by-step*) untuk mengunggah dan mempublikasikan aplikasi **MyHalaqoh** ke **Apple App Store (iOS)** melalui **App Store Connect**.

Semua aset gambar, teks metadata, dokumen legal, dan catatan review telah disiapkan secara terstruktur di dalam folder `app_store_assets/`. Antum dapat langsung meng-upload folder ini ke Google Drive atau menggunakannya langsung saat mengisi formulir di App Store Connect.

---

## DAFTAR ISI
1. [Ringkasan Aset yang Telah Disiapkan](#1-ringkasan-aset-yang-telah-disiapkan)
2. [Hal-Hal yang Harus Disiapkan Sendiri](#2-hal-hal-yang-harus-disiapkan-sendiri)
3. [Langkah 0: Deploy Dokumen Legal ke Firebase Hosting](#3-langkah-0-deploy-dokumen-legal-ke-firebase-hosting)
4. [Langkah 1: Setup di Apple Developer Portal](#4-langkah-1-setup-di-apple-developer-portal)
5. [Langkah 2: Membuat Aplikasi Baru di App Store Connect](#5-langkah-2-membuat-aplikasi-baru-di-app-store-connect)
6. [Langkah 3: Mengisi Metadata & Informasi Aplikasi](#6-langkah-3-mengisi-metadata--informasi-aplikasi)
7. [Langkah 4: Upload Screenshots & App Icon](#7-langkah-4-upload-screenshots--app-icon)
8. [Langkah 5: Mengisi Kuesioner Privasi (App Privacy)](#8-langkah-5-mengisi-kuesioner-privasi-app-privacy)
9. [Langkah 6: Memasukkan Informasi untuk Tim Review Apple](#9-langkah-6-memasukkan-informasi-untuk-tim-review-apple)
10. [Langkah 7: Build & Upload Binary IPA (via Mac / Xcode)](#10-langkah-7-build--upload-binary-ipa-via-mac--xcode)
11. [Langkah 8: Submit for Review & Tips Anti-Rejection](#11-langkah-8-submit-for-review--tips-anti-rejection)

---

## 1. RINGKASAN ASET YANG TELAH DISIAPKAN

Semua berkas tersimpan rapi pada direktori `app_store_assets/`:

```text
app_store_assets/
├── 1_app_icon/
│   └── app_icon_1024x1024.png          # Icon 1024x1024 px, 24-bit RGB (No Alpha/Transparansi)
├── 2_screenshots/
│   └── iphone_6.7_inch/                # 7 Screenshot resolusi 1290x2796 px (Apple iPhone 6.7")
│       ├── 01_welcome_login.png        # Welcome & Identitas Platform
│       ├── 02_dashboard_guru.png       # Dashboard Guru & Sesi Sholat
│       ├── 03_absensi_scanner.png      # Scanner Barcode Presensi Cepat
│       ├── 04_mutabaah_hafalan.png     # Input Ziyadah & Muraja'ah
│       ├── 05_progress_juz.png         # Tracking Capaian Target 30 Juz
│       ├── 06_dashboard_wali.png       # Portal Transparansi Wali Santri
│       └── 07_sertifikasi_tahfidz.png  # Ujian Kelulusan 1 Juz & Rapor
├── 3_app_information/
│   ├── metadata_app_store_id.txt       # Teks lengkap Bahasa Indonesia (App Name, Subtitle, Description, Keywords)
│   ├── metadata_app_store_id.json      # Versi JSON Bahasa Indonesia
│   ├── metadata_app_store_en.txt       # Teks lengkap Bahasa Inggris (App Store English US Ready)
│   └── metadata_app_store_en.json      # Versi JSON Bahasa Inggris
├── 4_links_and_documents/
│   ├── urls_legal_id.txt               # Panduan URL Bahasa Indonesia (Privacy, Terms, Support, Delete Account)
│   └── urls_legal_en.txt               # Panduan URL Bahasa Inggris lengkap dengan standar guideline Apple
├── 5_app_review_notes/
│   ├── app_review_notes_en.txt         # Catatan review Bahasa Inggris (Siap copy-paste ke App Store Connect)
│   ├── app_review_notes_id.txt         # Panduan akun demo & catatan review dalam Bahasa Indonesia
│   └── dummy_santri_barcode.png        # Kartu santri barcode uji untuk reviewer Apple
└── PANDUAN_UPLOAD_APP_STORE_CONNECT.md # Panduan ini
```

---

## 2. HAL-HAL YANG HARUS DISIAPKAN SENDIRI

Karena keterbatasan lingkungan lokal (Windows tanpa Mac dan tanpa kredensial rahasia akun Apple Antum), beberapa hal berikut wajib disiapkan secara mandiri:

1. **Akun Apple Developer Program ($99 / tahun)**:
   - Harus terdaftar aktif di [developer.apple.com](https://developer.apple.com).
   - Pastikan status keanggotaan sudah aktif (Individual atau Organization).
2. **Akses Komputer Mac (macOS)**:
   - Diperlukan untuk melakukan proses code signing, membuat file `.ipa`, atau mengunggah melalui Xcode / Transporter app. (Bisa menggunakan Mac fisik, Mac Mini, MacBook, atau cloud macOS seperti GitHub Actions / Codemagic / MacinCloud).
3. **Akun Demo Asli yang Aktif di Database Firebase**:
   - Pastikan akun demo guru (`demoguru@myhalaqoh.sch.id`) dan wali santri (`demowali@myhalaqoh.sch.id`) yang didaftarkan di `app_review_notes.txt` sudah benar-benar dibuat dan bisa login di Firebase Auth & Firestore production pesantren.
4. **Alamat Email & Kontak WhatsApp Pribadi/Pesantren**:
   - Siapkan email dan no HP aktif untuk dimasukkan ke bagian *App Review Contact Information* dan *Support URL*.

---

## 3. LANGKAH 0: DEPLOY DOKUMEN LEGAL KE FIREBASE HOSTING

Dokumen **Terms & Conditions** (`web_legal/terms_conditions.html`) baru saja ditambahkan melengkapi **Privacy Policy** dan **Account Deletion** yang sudah ada sebelumnya.

Jalankan perintah berikut pada terminal proyek ini untuk mempublikasikan halaman tersebut agar bisa diakses oleh Apple dan publik:

```bash
firebase deploy --only hosting
```

Setelah deploy selesai, pastikan URL berikut dapat dibuka di browser:
- Privacy Policy: `https://my-halaqoh.web.app/privacy`
- Terms & Conditions: `https://my-halaqoh.web.app/terms`
- Support: `https://my-halaqoh.web.app/support`
- Account Deletion: `https://my-halaqoh.web.app/delete-account`

---

## 4. LANGKAH 1: SETUP DI APPLE DEVELOPER PORTAL

Buka [developer.apple.com/account](https://developer.apple.com/account):

1. **Buat App ID (Identifiers)**:
   - Buka **Certificates, Identifiers & Profiles** > **Identifiers** > klik tanda **+**.
   - Pilih **App IDs** > **App**.
   - **Description**: `MyHalaqoh App`
   - **Bundle ID**: Pilih `Explicit` dan masukkan:
     ```text
     com.luqmanalhakim.surabaya.myHalaqoh
     ```
   - **Capabilities**: Centang kapabilitas yang digunakan aplikasi:
     - `Push Notifications` (untuk notifikasi mutaba'ah / sertifikasi via FCM)
   - Klik **Continue** lalu **Register**.

2. **Buat Certificate & Profile**:
   - Buat **Apple Distribution Certificate** (jika belum punya).
   - Buat **App Store Provisioning Profile** untuk App ID `com.luqmanalhakim.surabaya.myHalaqoh`.

---

## 5. LANGKAH 2: MEMBUAT APLIKASI BARU DI APP STORE CONNECT

Buka [appstoreconnect.apple.com](https://appstoreconnect.apple.com):

1. Masuk ke menu **My Apps** > klik icon **+** di pojok kiri atas > pilih **New App**.
2. Isi formulir pop-up:
   - **Platforms**: Centang **iOS**.
   - **Name**: `MyHalaqoh`
   - **Primary Language**: `Indonesian` (atau `English (US)` sesuai preferensi antum).
   - **Bundle ID**: Pilih `com.luqmanalhakim.surabaya.myHalaqoh`.
   - **SKU**: Masukkan ID unik internal, misal: `myhalaqoh-ios-app-01`.
   - **User Access**: Pilih `Full Access`.
3. Klik **Create**.

---

## 6. LANGKAH 3: MENGISI METADATA & INFORMASI APLIKASI

Buka tab aplikasi yang baru dibuat, lalu isi informasi berikut. Anda dapat memilih menggunakan **Bahasa Indonesia** (`metadata_app_store_id.txt`) atau **Bahasa Inggris** (`metadata_app_store_en.txt`) sesuai bahasa utama (*Primary Language*) yang Anda tetapkan di App Store Connect:

### A. General > App Information
- **App Name**: `MyHalaqoh` *(9 dari maks 30 karakter)*
- **Subtitle**: `Halaqoh Management System` *(25 dari maks 30 karakter)*
- **Primary Category**: `Education` (Pendidikan)
- **Secondary Category**: `Lifestyle` (Gaya Hidup)
- **Content Rights**: Pilih `No, it does not contain, show, or access third-party content` (atau `Yes` jika memiliki lisensi resmi konten Quran pesantren).
- **Age Rating**: Klik *Set Up Age Rating*, jawab kuesioner (biasanya menghasilkan rating **4+** karena tidak ada konten kekerasan, judi, atau materi dewasa).

### B. Pricing and Availability
- **Price**: Pilih `Free` ($0.00).
- **Availability**: Pilih seluruh negara atau `Indonesia` saja.

### C. Version Information (v1.0.0)

#### Pilihan 1: Jika Menggunakan Bahasa Indonesia (Indonesian)
- **Promotional Text** *(maks. 170 karakter)*:
  ```text
  Aplikasi manajemen halaqoh Al-Qur'an dan mutaba'ah hafalan santri modern. Mendukung absensi barcode, ujian tahfidz 1 juz, dan portal monitoring wali.
  ```
- **Keywords** *(maks. 100 bytes, tanpa spasi setelah koma)*:
  ```text
  tahfidz,halaqoh,quran,santri,hafalan,pesantren,absensi,setoran,juz,mutabaah,luqman al hakim
  ```
- **Description**: *Copy-paste* teks deskripsi lengkap dari file `3_app_information/metadata_app_store_id.txt`.

#### Pilihan 2: Jika Menggunakan Bahasa Inggris (English U.S.)
- **Promotional Text** *(maks. 170 karakter)*:
  ```text
  Official Quran memorization and halaqoh management platform for PPTQ Luqman Al Hakim. Track daily mutaba'ah, student attendance, and Juz targets in real time.
  ```
- **Keywords** *(maks. 100 bytes, tanpa spasi setelah koma)*:
  ```text
  tahfidz,quran,halaqoh,islamic,student,attendance,memorization,pesantren,tracker,juz,surah
  ```
- **Description**: *Copy-paste* teks deskripsi lengkap dari file `3_app_information/metadata_app_store_en.txt`.

#### URL Dukungan & Hak Cipta
- **Support URL**:
  ```text
  https://my-halaqoh.web.app/support
  ```
- **Marketing URL** (opsional):
  ```text
  https://my-halaqoh.web.app
  ```
- **Copyright**:
  ```text
  © 2026 PPTQ Luqman Al Hakim Surabaya
  ```

---

## 7. LANGKAH 4: UPLOAD SCREENSHOTS & APP ICON

### A. Upload Screenshots (iPhone 6.7" Display)
1. Pada menu versi aplikasi (1.0 Prepare for Submission), buka bagian **Screenshots**.
2. Pilih tab **6.7" Display** (iPhone 16 Pro Max / 15 Pro Max / 14 Pro Max).
3. Buka folder `app_store_assets/2_screenshots/iphone_6.7_inch/` di komputer antum.
4. Drag & drop ke-7 file berikut secara berurutan:
   1. `01_welcome_login.png`
   2. `02_dashboard_guru.png`
   3. `03_absensi_scanner.png`
   4. `04_mutabaah_hafalan.png`
   5. `05_progress_juz.png`
   6. `06_dashboard_wali.png`
   7. `07_sertifikasi_tahfidz.png`

> **Catatan Penting Device Family**:
> Kita telah mengonfigurasi `TARGETED_DEVICE_FAMILY = 1` (iPhone Only) pada file `project.pbxproj`. Oleh karena itu, antum **TIDAK PERLU** mengunggah screenshot iPad (12.9" Display). Screenshot 6.7" iPhone ini sudah otomatis mencukupi seluruh lini perangkat iPhone.

### B. App Icon
- Icon resolusi tinggi telah disediakan di `app_store_assets/1_app_icon/app_icon_1024x1024.png`.
- Berkas ini telah diverifikasi: resolusi tepat `1024x1024`, format PNG 24-bit Truecolor RGB murni **tanpa transparansi (alpha channel)**, dan tanpa sudut melengkung (*square*).
- Icon ini akan dikemas otomatis ke dalam bundle IPA oleh Xcode saat build.

---

## 8. LANGKAH 5: MENGISI KUESIONER PRIVASI (APP PRIVACY)

Apple mewajibkan setiap aplikasi mengisi label nutrisi privasi (*App Privacy Details*):

1. Masuk ke menu **App Privacy** di menu sebelah kiri.
2. Klik **Get Started** pada kuesioner data:
   - **Do you or your third-party partners collect data from this app?**: Pilih `Yes`.
3. Tipe data yang dikumpulkan aplikasi MyHalaqoh:
   - **Contact Info** (Email & Nama):
     - Digunakan untuk: `App Functionality`
     - Linked to the user: `Yes`
     - Used for tracking: `No`
   - **User Content** (Catatan hafalan santri, setoran juz/surah, presensi):
     - Digunakan untuk: `App Functionality`
     - Linked to the user: `Yes`
     - Used for tracking: `No`
   - **Identifiers** (User ID, Device/FCM Push Token):
     - Digunakan untuk: `App Functionality`
     - Linked to the user: `Yes`
     - Used for tracking: `No`
   - **Diagnostics** (Crashlytics logs - jika aktif):
     - Digunakan untuk: `Analytics` / `App Functionality`
     - Linked to the user: `No`
     - Used for tracking: `No`
4. Masukkan **Privacy Policy URL**:
   ```text
   https://my-halaqoh.web.app/privacy
   ```
5. Klik **Publish** pada halaman App Privacy.

---

## 9. LANGKAH 6: MEMASUKKAN INFORMASI UNTUK TIM REVIEW APPLE

Bagian ini sangat krusial. Apple akan **langsung menolak (reject)** aplikasi jika reviewer tidak bisa login atau tidak paham cara menguji scanner barcode!

1. Gulir ke bawah ke bagian **App Review Information**.
2. **Sign-In Required**: Centang kotak ini.
3. Masukkan Akun Demo:
   - **User Name**: `demoguru@myhalaqoh.sch.id`
   - **Password**: `DemoGuru2026!`
4. **Contact Information**:
   - Masukkan Nama Depan, Nama Belakang, Nomor Telepon, dan Email Antum yang aktif agar reviewer bisa menghubungi jika ada kendala darurat.
5. **Notes (Catatan untuk Reviewer)**:
   *Copy-paste* teks berikut (juga tersedia di `5_app_review_notes/app_review_notes_en.txt`):

```text
Dear Apple App Review Team,

This app, MyHalaqoh, is an educational Quranic memorization and halaqoh management system designed for students, teachers, and guardians of Pesantren Tahfidz Luqman Al Hakim.

DEMO CREDENTIALS:
- Role: Halaqoh Teacher / Ustadz
  Email: demoguru@myhalaqoh.sch.id
  Password: DemoGuru2026!

- Role: Guardian / Wali Santri (Alternative)
  Email: demowali@myhalaqoh.sch.id
  Password: DemoWali2026!

KEY TESTING GUIDELINES:
1. Camera Permission:
   The camera permission is strictly used by teachers to scan student physical ID cards (barcode) during prayer attendance sessions (e.g. Shubuh, Dhuha, Ashar, Maghrib).
2. Barcode Testing:
   We have attached a sample test student barcode card ("dummy_santri_barcode.png") to this review submission. You may display this barcode on another device screen or print it, navigate to the Attendance / Presensi tab in the app, tap the QR/Barcode Scanner button, and point the camera at this barcode to verify the instant attendance recognition feature.
3. Student Progress & Certification:
   You can explore student progress tracking across the 30 Juz curriculum, setoran ziyadah/muraja'ah records, and 1-Juz certification testing data.

Thank you very much for your time and assistance!
```

6. **Attachment**:
   - Upload file: `app_store_assets/5_app_review_notes/dummy_santri_barcode.png`.
   - Ini memungkinkan tim reviewer Apple langsung menguji fitur kamera barcode scanner tanpa harus berada di pesantren fisik.

---

## 10. LANGKAH 7: BUILD & UPLOAD BINARY IPA (VIA MAC / XCODE)

Setelah semua formulir di App Store Connect siap, unggah file IPA aplikasi:

### Cara 1: Menggunakan Terminal Flutter & Xcode (Rekomendasi)
Di komputer Mac:
1. Buka terminal di folder root project:
   ```bash
   flutter clean
   flutter pub get
   ```
2. Jalankan perintah build IPA:
   ```bash
   flutter build ipa --release
   ```
   *(Perintah ini akan menghasilkan folder `build/ios/archive/Runner.xcarchive` dan file `.ipa`).*
3. Buka folder `build/ios/archive/Runner.xcarchive` menggunakan **Xcode Organizer**:
   - Buka Xcode > menu **Window** > **Organizer**.
   - Pilih archive terbaru > klik **Distribute App**.
   - Pilih metode **Custom** atau **App Store Connect**.
   - Pilih **Upload** > biarkan Xcode mengelola signing secara otomatis (*Automatically manage signing*).
   - Klik **Next** sampai proses upload selesai.

### Cara 2: Menggunakan Transporter App
1. Download aplikasi resmi **Transporter** dari Mac App Store.
2. Login menggunakan Apple ID pengembang Antum.
3. Drag & drop file `.ipa` yang dihasilkan dari `flutter build ipa` ke dalam jendela Transporter.
4. Klik **Deliver** untuk mengunggah binary ke App Store Connect.

---

## 11. LANGKAH 8: SUBMIT FOR REVIEW & TIPS ANTI-REJECTION

1. Setelah upload binary selesai, tunggu sekitar 10–30 menit sampai Apple selesai memproses binary (*Processing Build*).
2. Jika status build sudah selesai diproses:
   - Kembali ke App Store Connect > tab versi `1.0 Prepare for Submission`.
   - Pada bagian **Build**, klik tanda **+** dan pilih build yang baru di-upload.
3. Pada pertanyaan **Export Compliance Information**:
   - Jika ditanya *"Does your app use encryption?"*: Pilih **Yes**.
   - *"Is your app exempt under Category 5 Part 2?"*: Pilih **Yes** (karena aplikasi hanya menggunakan HTTPS/SSL standar Firebase).
4. Klik tombol **Save** di pojok kanan atas.
5. Klik **Add for Review** lalu klik **Submit to App Review**.
6. Status aplikasi akan berubah menjadi **Waiting for Review**. Biasanya proses review memakan waktu 24 hingga 48 jam kerja.

### Tips Menghindari Rejection Apple:
- Pastikan akun demo (`demoguru@myhalaqoh.sch.id`) tidak terhapus atau terkunci di Firebase Auth.
- Pastikan koneksi Firestore production aktif dan tidak mengalami kendala kuota / permission rules saat reviewer login dari luar negeri.
- Jangan mengubah teks tombol di UI menjadi kata "Android" atau merk lain di versi iOS.

Semoga proses publikasi aplikasi **MyHalaqoh** di Apple App Store berjalan lancar dan penuh berkah! 🚀
