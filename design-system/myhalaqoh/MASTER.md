# MyHalaqoh — Design System (MASTER)

> **LOGIC:** When building a specific page, first check `design-system/myhalaqoh/pages/[page-name].md`.
> If that file exists, its rules **override** this Master file.
> If not, strictly follow the rules below.

---

**Project:** MyHalaqoh
**Generated:** 2026-08-15
**Platform:** Flutter (Android) — Design size `360 × 690` via `flutter_screenutil`
**Category:** Islamic Education / Pesantren Institution — Attendance & Quran Monitoring
**Visual Tone:** Tenang, terpercaya, institusional. Bersih tanpa steril. Hangat tanpa playful.

---

## 0. Warna & Font (Sudah Didefinisikan — JANGAN UBAH)

Referensi warna: [`colors.xml`](file:///e:/PERKULIAHAN/SEMESTER%207/SKRIPSI%20APPLICATION/My_Halaqoh/my_halaqoh/assets/color/colors.xml), [`app_colors.dart`](file:///e:/PERKULIAHAN/SEMESTER%207/SKRIPSI%20APPLICATION/My_Halaqoh/my_halaqoh/lib/src/core/theme/app_colors.dart), [`app_theme.dart`](file:///e:/PERKULIAHAN/SEMESTER%207/SKRIPSI%20APPLICATION/My_Halaqoh/my_halaqoh/lib/src/core/theme/app_theme.dart).

| Peran | Light | Dark |
|-------|-------|------|
| Primary | `#115D69` | `#115D69` |
| Secondary / Scaffold BG | `#F5F5F5` | `#1F2937` |
| Text Primary | `#111827` | `#F9FAFB` |
| Text Secondary | `#6B7280` | `#9CA3AF` |
| Text on Button | `#FFFFFF` | `#FFFFFF` |
| Surface (Card) | `#FFFFFF` | `#111827` |
| Background | `#FAFAFA` | `#0F172A` |
| Border | `#E5E7EB` | `#374151` |
| Border Light | `#F3F4F6` | `#1F2937` |
| Semantic: Success | `#10B981` | `#10B981` |
| Semantic: Warning | `#FBBF24` | `#FBBF24` |
| Semantic: Error | `#F43F5E` | `#F43F5E` |
| Semantic: Info | `#3B82F6` | `#3B82F6` |

**Font:** Poppins (bundled, weight 100–900). **JANGAN** usulkan font pairing baru.
Akses: `AppColors.of(context)` untuk warna, `Theme.of(context).textTheme` untuk tipografi.

---

## 1. Skala Spacing

Berbasis kelipatan 4dp agar seragam dengan `flutter_screenutil` pada design size 360×690.
Gunakan ekstensi `.w`, `.h`, `.r` sesuai konteks.

| Token | Nilai | Penggunaan |
|-------|-------|------------|
| `xs` | `4.w` | Gap antar ikon inline, padding internal badge/chip |
| `sm` | `8.w` | Gap ikon–teks, padding horizontal chip, spacing antar elemen dalam row |
| `md` | `12.w` | Padding vertikal form field, gap antar item dalam grup kecil |
| `lg` | `16.w` | Padding horizontal kartu, margin antar komponen sejenis, padding content area |
| `xl` | `20.w` | Margin horizontal layar (screen gutter), padding vertikal section |
| `2xl` | `24.w` | Jarak antar section/grup yang berbeda konteks |
| `3xl` | `32.w` | Jarak vertikal besar (hero section ke konten, top screen padding di bawah AppBar) |

### Aturan Penggunaan

```
Screen horizontal padding  →  xl (20.w)
Card internal padding       →  lg (16.w)
Gap antar item list          →  md (12.h)
Gap antar field dalam form  →  lg (16.h)
Section divider spacing     →  2xl (24.h) atas & bawah
Icon-to-text gap            →  sm (8.w)
Badge/chip internal padding →  xs (4.w) vertikal, sm (8.w) horizontal
```

> [!TIP]
> Untuk spacing vertikal antar section besar (misalnya dashboard cards ke halaqoh list), gunakan `2xl` (24.h).
> Hindari `3xl` kecuali untuk padding atas layar pertama setelah AppBar.

---

## 2. Sistem Shadow / Elevasi

Evaluasi resep existing `Colors.black.withValues(alpha: 0.04), blurRadius: 10`:
- ✅ Cocok untuk kartu data list (santri, guru, halaqoh) — lembut, tidak agresif.
- ❌ Tidak cukup untuk membedakan elevasi komponen yang tumpang tindih (dialog, bottom sheet, dropdown).

### Skala Shadow — Tiga Tingkat

| Token | Definisi Flutter | Penggunaan |
|-------|-----------------|------------|
| `shadow.sm` | `BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: Offset(0, 2))` | Card list item, container data biasa, tab selector |
| `shadow.md` | `BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: Offset(0, 4))` | Card yang di-tap/hover, FAB, kalender picker, dropdown overlay |
| `shadow.lg` | `BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 20, offset: Offset(0, 8))` | Dialog, bottom sheet, modal overlay |

### Aturan Dark Mode

Di dark mode, shadow hampir tidak terlihat. Gunakan **border** sebagai pengganti pembeda elevasi:

```dart
// Light mode: shadow
boxShadow: [shadow.sm]

// Dark mode: border replacement
border: Border.all(color: colors.border, width: 0.5)
```

> [!IMPORTANT]
> Jangan gunakan `elevation` dari Material Card — selalu gunakan `BoxDecoration` dengan shadow di atas
> agar konsisten antar light/dark mode. Set `CardTheme.elevation: 0` di `app_theme.dart`.

### Refactoring yang Disarankan

Resep existing `Colors.black.withValues(alpha: 0.04), blurRadius: 10` sudah dekat dengan `shadow.sm`.
Lakukan migrasi bertahap:
1. Ganti `blurRadius: 10` → `blurRadius: 8, offset: Offset(0, 2)` di semua card list item.
2. Dialog/bottom sheet yang sekarang pakai shadow yang sama → naikkan ke `shadow.lg`.
3. Tidak perlu membuat class terpisah — cukup definisikan sebagai `static const` di helper.

---

## 3. Hierarki Tipografi

### Evaluasi Status Quo

Hierarki existing:

| textTheme | Size | Weight | Gap Analysis |
|-----------|------|--------|--------------|
| `displayLarge` | 32 | w700 | ✅ Judul utama dashboard |
| `displayMedium` | 28 | w700 | ✅ Judul section besar |
| `displaySmall` | 24 | w600 | ✅ Judul halaman/modal |
| `headlineMedium` | 20 | w600 | ✅ Sub-header section |
| `headlineSmall` | 18 | w600 | ✅ Judul card/grup |
| `titleLarge` | 16 | w600 | ✅ Label bold / nama santri-guru |
| — | — | — | ⚠️ **GAP:** `titleMedium` (14/w600) belum ada |
| — | — | — | ⚠️ **GAP:** `titleSmall` (12/w600) belum ada |
| `bodyLarge` | 16 | w400 | ✅ Body text utama |
| `bodyMedium` | 14 | w400 | ✅ Body text standar |
| `bodySmall` | 12 | w400 | ✅ Caption / hint |
| — | — | — | ⚠️ **GAP:** `labelLarge` (14/w500) belum ada |
| — | — | — | ⚠️ **GAP:** `labelMedium` (12/w500) belum ada |
| — | — | — | ⚠️ **GAP:** `labelSmall` (10/w500) belum ada |
| — | — | — | ⚠️ **GAP:** `headlineLarge` (24/w700) belum ada |

### Tambahan yang Direkomendasikan

```dart
// Tambahkan ke textTheme di app_theme.dart (light & dark):

headlineLarge: TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: colors.textPrimary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: judul halaman yang perlu lebih tebal dari displaySmall

titleMedium: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: colors.textPrimary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: label bold sekunder, nama field dalam form, header kolom tabel

titleSmall: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: colors.textPrimary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: chip label, badge text, tag status

labelLarge: TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: colors.textPrimary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: label tombol, nav item, tab text

labelMedium: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: colors.textSecondary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: keterangan kecil, timestamp, sub-label

labelSmall: TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: colors.textSecondary,
  fontFamily: 'Poppins',
),
// Gunakan untuk: counter badge, overline text, hint sangat kecil
```

### Tabel Referensi Cepat — Kapan Pakai Apa

| Konteks UI | textTheme yang Tepat |
|------------|---------------------|
| Angka besar di dashboard (total santri) | `displayLarge` (32/w700) |
| Judul section "Halaqoh Saya" | `displaySmall` (24/w600) |
| Judul card / nama halaqoh | `headlineSmall` (18/w600) |
| Nama santri / guru dalam list | `titleLarge` (16/w600) |
| Label field dalam form | `titleMedium` (14/w600) ← **baru** |
| Badge "Hadir" / "Izin" | `titleSmall` (12/w600) ← **baru** |
| Teks tombol "Simpan" | `labelLarge` (14/w500) ← **baru** |
| Teks tab "Absensi" / "Hafalan" | `labelLarge` (14/w500) ← **baru** |
| Timestamp "2 jam lalu" | `labelMedium` (12/w500) ← **baru** |
| Counter dalam badge notif | `labelSmall` (10/w500) ← **baru** |
| Body text paragraf | `bodyMedium` (14/w400) |
| Hint / placeholder input | `bodySmall` (12/w400) |

> [!NOTE]
> Semua ukuran di atas adalah **nilai desain** (tanpa `.sp`). Pada implementasi Flutter,
> gunakan `fontSize.sp` agar responsif via ScreenUtil. Namun `textTheme` sudah di-set di
> `AppTheme` tanpa `.sp` karena ScreenUtil menghandle secara global.

---

## 4. Sistem Radius Komponen

### Evaluasi Penggunaan Saat Ini

Dari audit codebase, ditemukan radius: 4, 8, 10, 12, 14, 16, 20, 24, 25. Terlalu banyak variasi.

### Skala Radius yang Distandarkan

| Token | Nilai | Komponen |
|-------|-------|----------|
| `radius.xs` | `4.r` | Divider rounded end, inline code block, tiny badge |
| `radius.sm` | `8.r` | Button (elevated, outlined, text), chip/tag, input field, snackbar |
| `radius.md` | `12.r` | Card list item (santri, guru, halaqoh), month selector, about card |
| `radius.lg` | `16.r` | Card section (container besar, absensi detail), bottom sheet content |
| `radius.xl` | `20.r` | Header card gradient, login form container, hero info card |
| `radius.full` | `24.r` | Dialog, modal, pill shape (full rounded) |

### Mapping Komponen → Radius

```
ElevatedButton / OutlinedButton  →  radius.sm   (8.r)  — saat ini 8/14, STANDARKAN ke 8
Card item (list santri/guru)     →  radius.md   (12.r) — sudah sesuai ✅
Card section besar               →  radius.lg   (16.r) — sudah sesuai ✅
Bottom sheet                     →  radius.xl   (20.r) — via topLeft/topRight
Dialog                           →  radius.full (24.r) — sudah sesuai ✅
Login container                  →  radius.xl   (20.r) — sudah sesuai ✅
Tab selector container           →  radius.sm   (8.r)  — sebelumnya 10, STANDARKAN
Tab selector indicator           →  radius.sm   (8.r)  — sebelumnya 8 ✅
Input field (jika outlined)      →  radius.sm   (8.r)
Avatar / profile picture         →  `radius circular` (50%)
```

### Refactoring yang Diperlukan

```diff
// primary_button.dart:
- borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
+ borderRadius: BorderRadius.circular(borderRadius ?? 8.r),

// outlined_button.dart:
- borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
+ borderRadius: BorderRadius.circular(borderRadius ?? 8.r),

// app_tab_selector.dart container:
- borderRadius: BorderRadius.circular(10.r),
+ borderRadius: BorderRadius.circular(8.r),

// app_theme.dart ElevatedButton (light & dark):
  borderRadius: BorderRadius.circular(8),  // ← sudah benar ✅
```

> [!WARNING]
> Button dan tab selector memiliki radius yang lebih kecil daripada card.
> Ini **intentional** — elemen interaktif kecil terasa lebih tegas dengan radius rendah.
> Jangan naikkan radius button ke 12 atau 14 demi "konsistensi".

---

## 5. Definisi State Komponen

### 5A. Button States (PrimaryButton / OutlinedButton)

| State | Visual | Behavior |
|-------|--------|----------|
| **Default** | BG: `primary`, FG: `textOnButton`, shadow: none, opacity: 1.0 | Tappable |
| **Pressed** | BG: `primary` dengan overlay `Colors.black.withValues(alpha: 0.1)`, scale: `0.98` via `AnimatedScale` (100ms) | Tap feedback |
| **Disabled** | BG: `primary.withValues(alpha: 0.5)`, FG: `textOnButton.withValues(alpha: 0.8)` | Non-tappable, `AbsorbPointer` |
| **Loading** | BG: `primary.withValues(alpha: 0.7)`, konten diganti `SizedBox(16×16) + CircularProgressIndicator(strokeWidth: 2, color: textOnButton)` | Non-tappable, `AbsorbPointer` |

```dart
// Implementasi loading state pada PrimaryButton:
child: isLoading
    ? SizedBox(
        width: 16.w, height: 16.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.textOnButton,
        ),
      )
    : Text(label),
```

### 5B. Card List States (Santri / Guru / Halaqoh)

| State | Visual | Behavior |
|-------|--------|----------|
| **Default** | BG: `surface`, shadow: `shadow.sm`, border: none (light) / `0.5px border` (dark) | Tappable → navigate |
| **Pressed** | BG: `surface` + `primary.withValues(alpha: 0.04)` overlay, shadow: `shadow.md` (200ms) | Ink splash / highlight |
| **Loading (Shimmer)** | Shimmer placeholder sesuai layout final — sudah ada (`shimmer_santri_list_item.dart`, dll) | Non-interactive |
| **Empty** | Ilustrasi SVG/icon + teks deskriptif + CTA button (jika applicable). BG: transparan. | Hanya muncul di parent list |
| **Error** | Icon `error_outline` (merah) + pesan error + tombol "Coba Lagi" | Retry action |

#### Empty State — Template

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.people_outline, size: 48.sp, color: colors.textSecondary),
    SizedBox(height: 16.h),
    Text(
      t.modul.belumAdaData,  // "Belum ada data santri"
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary,
      ),
    ),
    SizedBox(height: 8.h),
    Text(
      t.modul.tambahDenganTombol,  // "Tambahkan dengan tombol + di atas"
      style: Theme.of(context).textTheme.bodySmall,
    ),
  ],
)
```

#### Error State — Template

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.error_outline, size: 40.sp, color: colors.error),
    SizedBox(height: 12.h),
    Text(
      errorMessage,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary,
      ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 16.h),
    OutlinedButton.icon(
      onPressed: onRetry,
      icon: Icon(Icons.refresh, size: 18.sp),
      label: Text(t.umum.cobaLagi),
    ),
  ],
)
```

### 5C. Form Input States (`AppTextField`)

Standar input form di seluruh aplikasi menggunakan komponen reusable `AppTextField` (`lib/src/core/widget/input/app_text_field.dart`) dengan bentuk **OutlineInputBorder** (radius `8.r` / `radius.sm`).

| State | Visual | Deskripsi |
|-------|--------|-----------|
| **Default** | Border: `colors.border` (1px), BG: `colors.surface` | State normal siap diisi |
| **Focused** | Border: `colors.primary` (1.5px), BG: `colors.surface` | Field sedang aktif |
| **Filled (valid)** | Border: `colors.border` (1px), Text: `colors.textPrimary` | Data terisi tanpa error |
| **Error** | Border: `colors.error` (1px / 1.5px focused) + teks error inline di bawah field (merah, `bodySmall` 11–12sp) | Validasi gagal |
| **Disabled** | Border: `colors.border.withValues(alpha: 0.5)`, opacity rendah | Non-editable |

#### Spesifikasi Reusable `AppTextField`
- **Border Radius:** `8.r` (`radius.sm`)
- **Padding:** `horizontal: 14.w`, `vertical: 14.h`
- **Fitur Bawaan:**
  - Prefix icon (misal: `Icons.person_outline`, `Icons.lock_outline`)
  - Password visibility toggle otomatis jika `isPassword: true`
  - Inline error rendering via `errorText` (menghindari penggunaan toast/snackbar untuk kesalahan form)
  - Label terintegrasi di atas field menggunakan `Theme.of(context).textTheme.titleSmall`

#### Aturan Validasi Form
1. **Validasi on-blur / on-submit** dengan inline error (`errorText`) di bawah field terkait.
2. **Bersihkan error segera** saat user mulai mengetik karakter baru (`onChanged`).
3. **Pesan error spesifik:** "NIP/NIS minimal 3 karakter", bukan pesan umum seperti "Form salah".
4. **SnackBar hanya untuk server error:** SnackBar mengambang hanya digunakan untuk kegagalan respon backend (misal: kredensial salah atau koneksi putus), bukan untuk format field kosong/salah.

---

## 6. Micro-Interaction & Animasi

### 6A. Prinsip Umum

- Gunakan **implicit animation** (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`) untuk transisi sederhana.
- `AnimationController` hanya untuk sequence kompleks (barcode scan feedback).
- Semua durasi dalam `const Duration` — jangan hardcode angka di tiap widget.

### 6B. Durasi Standar

| Token | Durasi | Penggunaan |
|-------|--------|------------|
| `instant` | `100ms` | Tap feedback (scale/opacity), toggle switch |
| `fast` | `200ms` | Tab switch indicator, chip selection, card press overlay |
| `normal` | `300ms` | Page transition (auto_route default), bottom sheet appear |
| `slow` | `400ms` | Expand/collapse section, accordion, AnimatedList insert |
| `emphasis` | `500ms` | Barcode scan success celebration, first-time onboarding reveal |

### 6C. Easing

```dart
// Default easing untuk semua transisi
const Curve defaultEasing = Curves.easeInOutCubic;

// Untuk elemen yang masuk (appear/expand)
const Curve enterEasing = Curves.easeOutCubic;

// Untuk elemen yang keluar (dismiss/collapse)
const Curve exitEasing = Curves.easeInCubic;

// Untuk bounce ringan (scan success, checkmark appear)
const Curve bounceEasing = Curves.elasticOut;
```

### 6D. Transisi Tab

```dart
// Tab switch di dashboard (guru/wali santri)
// Menggunakan AnimatedSwitcher untuk konten tab

AnimatedSwitcher(
  duration: const Duration(milliseconds: 200), // fast
  switchInCurve: Curves.easeOutCubic,
  switchOutCurve: Curves.easeInCubic,
  child: currentTabContent,
)

// Tab indicator slide (AppTabSelector)
// Menggunakan AnimatedPositioned atau AnimatedAlign
// Duration: 200ms (fast)
```

### 6E. Feedback Scan Barcode

#### Scan Berhasil ✅

```
Timeline (total ~700ms):
  0ms     → Overlay hijau transparan (green.withValues(alpha: 0.15)) fade in (100ms)
  100ms   → Ikon checkmark putih dalam lingkaran hijau, scale 0→1 (200ms, bounceEasing)
  300ms   → Teks "Hadir — [Nama Santri]" fade in dari bawah (200ms)
  500ms   → Hold
  700ms   → Seluruh overlay fade out (200ms)
  900ms   → Kembali ke scanner / tampilkan list updated
```

```dart
// Implementasi minimal:
// 1. OverlayEntry dengan AnimatedOpacity untuk container
// 2. AnimatedScale untuk ikon checkmark
// 3. SlideTransition + FadeTransition untuk teks nama
// 4. HapticFeedback.mediumImpact() saat scan berhasil
```

#### Scan Gagal / Tidak Dikenali ❌

```
Timeline (total ~500ms):
  0ms     → Overlay merah transparan (red.withValues(alpha: 0.10)) fade in (100ms)
  100ms   → Ikon close/error merah, scale 0→1 (150ms)
  250ms   → Teks error spesifik fade in (150ms):
            - "QR Code tidak valid" — format salah
            - "Santri tidak ditemukan" — ID tidak ada di halaqoh
            - "Sudah diabsen" — duplikasi
  400ms   → Hold
  1500ms  → Auto dismiss (fade out 200ms)
```

```dart
// Tambahan:
// HapticFeedback.heavyImpact() saat gagal (lebih berat dari sukses)
// Jangan matikan scanner — biarkan guru langsung scan ulang
```

### 6F. List Item Animation

```dart
// Saat item baru masuk ke list (misalnya santri baru di-absen):
AnimatedList + SlideTransition(
  position: Tween(begin: Offset(0, 0.3), end: Offset.zero),
  // Duration: slow (400ms)
  // Curve: enterEasing
)

// Saat item dihapus:
// Duration: 200ms (fast) — exit lebih cepat dari enter
// Curve: exitEasing
```

### 6G. Shimmer → Content Transition

```dart
// Saat data selesai loading, transisi dari shimmer ke konten nyata:
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300), // normal
  child: isLoading ? ShimmerWidget() : ActualContent(),
)
// Gunakan key yang berbeda (ValueKey) agar AnimatedSwitcher detect perubahan
```

---

## 7. Anti-Pattern — Hal yang DILARANG

### 7A. Anti-Pattern Visual

| ❌ Dilarang | ✅ Harus | Alasan |
|------------|---------|--------|
| Dark mode sebagai default | Light mode sebagai default, dark mode opsional | Aplikasi institusi pendidikan dipakai di siang hari dalam ruangan terang |
| Warna neon/fluorescent untuk CTA | Gunakan `primary` (#115D69) untuk CTA utama | Neon terasa fintech/consumer, bukan institusional |
| Gradient warna-warni pada header | Gradient subtle: `primary` → `primary.withValues(alpha: 0.82)` | Sudah dipakai di shimmer header — pertahankan |
| Card shadow terlalu gelap (alpha > 0.15) | Maksimal `shadow.lg` (alpha 0.10) | Shadow agresif terasa corporate SaaS, bukan pesantren |
| Rounded corner terlalu besar (>24.r) pada card | Maksimal `radius.full` (24.r) untuk dialog saja | Terlalu bulat terasa playful/consumer |
| Animasi bounce berlebihan | Bounce hanya untuk feedback sukses scan | Bounce berlebihan terasa game/entertainment |
| Emoji sebagai ikon sistem | Material Icons atau ikon SVG konsisten | Emoji tidak konsisten lintas device dan terasa unprofessional |
| Ikon filled dan outline dicampur dalam satu level | Pilih satu style per hierarchy level | Mixing style menurunkan perceived quality |

### 7B. Anti-Pattern Interaksi

| ❌ Dilarang | ✅ Harus | Alasan |
|------------|---------|--------|
| Animasi panjang (>500ms) untuk aksi rutin | Max 300ms untuk navigasi biasa | Guru absen 30+ santri — delay bikin frustrasi |
| Loading tanpa feedback (blank screen) | Shimmer placeholder atau spinner | Guru butuh confidence bahwa app bekerja |
| Error hanya visual (border merah saja) | Error text spesifik + semantic error label | Aksesibilitas dan kejelasan |
| Hapus data tanpa konfirmasi | `ConfirmDeleteDialog` untuk semua penghapusan | Data institusional tidak boleh hilang accidentally |
| Auto-dismiss snackbar terlalu cepat (<2 detik) | Minimal 3 detik, atau dengan action "Undo" | Guru mungkin tidak sempat baca |
| Infinite scroll tanpa indikator | Tampilkan "Memuat lebih banyak..." di footer | Kejelasan status |

### 7C. Anti-Pattern Nada & Konten

| ❌ Dilarang | ✅ Harus | Alasan |
|------------|---------|--------|
| Bahasa kasual: "Yuk scan!", "Mantap! 🎉" | Bahasa formal sopan: "Silakan scan barcode", "Data berhasil disimpan" | Konteks pesantren — guru sebagai pengguna utama |
| Gamifikasi (streak, badge, leaderboard) | Tampilkan progress informatif tanpa kompetisi | Hafalan Quran bukan kompetisi — ini ibadah |
| Dark pattern (confirm-shaming, forced action) | CTA jelas, opsi batal selalu tersedia | Kepercayaan institusional |
| Warna berbeda untuk setiap role dashboard | Warna `primary` konsisten lintas role, bedakan via layout & konten | Satu identitas brand, bukan multi-brand |
| Micro-copy bernada tech startup | Micro-copy bernada tenang dan informatif | "Tidak ada data" bukan "Kosong nih, yuk isi!" |
| Dekorasi berlebihan (pattern, ornamen) | Bersih dan fungsional, whitespace sebagai "ornamen" | Fokus pada fungsi: absensi cepat, monitoring akurat |

### 7D. Anti-Pattern Teknis Flutter

| ❌ Dilarang | ✅ Harus | Alasan |
|------------|---------|--------|
| `AnimationController` untuk transisi sederhana | `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher` | Lebih sedikit code, auto-dispose |
| `setState` untuk animasi di `StatelessWidget` | Gunakan implicit animation atau Cubit state | Clean architecture |
| Hardcode warna hex di widget | `AppColors.of(context).xxx` | Tema konsisten |
| Hardcode font size di widget | `Theme.of(context).textTheme.xxx` | Tipografi konsisten |
| Hardcode spacing angka acak | Gunakan skala spacing (xs/sm/md/lg/xl) | Spacing konsisten |
| `BorderRadius.circular(14.r)` pada button | Standarkan ke skala radius (sm=8, md=12, lg=16, xl=20, full=24) | Radius konsisten |

---

## Pre-Delivery Checklist (Flutter / Mobile)

Sebelum commit UI code, verifikasi:

### Visual
- [ ] Semua warna via `AppColors.of(context)` — tidak ada hex hardcode
- [ ] Semua teks via `textTheme` — tidak ada `TextStyle` ad-hoc dengan font size hardcode
- [ ] Spacing mengikuti skala (xs/sm/md/lg/xl/2xl/3xl)
- [ ] Radius mengikuti skala (xs/sm/md/lg/xl/full)
- [ ] Shadow mengikuti 3 level (sm/md/lg)
- [ ] Dark mode: border menggantikan shadow

### State
- [ ] Empty state memiliki ikon + teks deskriptif (+ CTA jika relevan)
- [ ] Error state memiliki pesan spesifik + tombol retry
- [ ] Loading state menggunakan shimmer (bukan spinner) untuk list/card
- [ ] Loading state menggunakan spinner (bukan shimmer) untuk button/aksi tunggal
- [ ] Disabled state jelas: opacity rendah + non-interactive

### Interaksi
- [ ] Tap feedback ada di semua elemen tappable (InkWell/Material splash)
- [ ] Animasi menggunakan durasi dari skala (instant/fast/normal/slow/emphasis)
- [ ] Tab switch smooth dengan `AnimatedSwitcher` (200ms)
- [ ] Barcode scan berhasil: visual + haptic feedback
- [ ] Barcode scan gagal: error spesifik + tetap di scanner

### Aksesibilitas
- [ ] Touch target ≥48dp (Android standard)
- [ ] Semantics label pada ikon fungsional
- [ ] Form field memiliki label + hint + error text yang jelas
- [ ] Warna bukan satu-satunya indikator (status hadir/izin/alpa juga pakai ikon/teks)

### Nada
- [ ] Bahasa Indonesia formal sopan — bukan kasual
- [ ] Tidak ada gamifikasi (streak, badge, leaderboard)
- [ ] Micro-copy informatif — bukan persuasif
