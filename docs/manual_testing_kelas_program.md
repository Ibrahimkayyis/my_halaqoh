# Panduan Testing Manual — Fitur Pengelolaan Kelas & Program

Dokumen ini berisi panduan skenario testing manual secara lengkap untuk memverifikasi fitur pengelolaan Kelas dan Program dinamis pada aplikasi My Halaqoh. Fitur ini dirancang khusus untuk peran **Admin**.

---

## 1. Prasyarat Pengujian (Pre-requisites)

Sebelum memulai pengujian, pastikan Anda memenuhi kriteria berikut:
1. **Peran Akun**: Login menggunakan akun dengan role **Admin**.
2. **Koneksi Internet**: Aplikasi harus terhubung ke internet karena data disinkronkan langsung dengan Cloud Firestore (tanpa cache offline di Hive).
3. **Database Firestore**: Pastikan koleksi `/kelas` dan `/program` di Firebase Console dapat diakses untuk memverifikasi kecocokan data real-time.

---

## 2. Skenario Pengujian

### Skenario 1: Inisialisasi Data & Auto-Seeding (Data Awal)
* **Tujuan**: Memverifikasi bahwa data kelas dan program default otomatis dibuat di Firestore jika koleksi kosong.
* **Langkah-langkah**:
  1. Hapus seluruh dokumen pada koleksi `/kelas` dan `/program` di Firebase Console (jika sudah ada sebelumnya).
  2. Buka aplikasi dan masuk sebagai Admin.
  3. Buka halaman utama Admin Dashboard, klik menu card **"Kelola Kelas & Program"**.
  4. Amati tampilan pada tab **Kelas** dan tab **Program**.
* **Hasil yang Diharapkan**:
  - Firestore otomatis terisi dengan data default.
  - Koleksi `/kelas` berisi kelas **7, 8, 9, 10, 11, 12** secara berurutan.
  - Koleksi `/program` berisi program **Reguler (R)** dan **Takhassus (T)**.
  - Aplikasi menampilkan daftar data default tersebut tanpa loading yang lama/berulang.

---

### Skenario 2: Pengelolaan Kelas (Tab Kelas)

#### 2.1 Menampilkan Daftar Kelas
* **Langkah-langkah**:
  1. Masuk ke halaman **"Kelola Kelas & Program"**.
  2. Pilih tab **Kelas** di bagian atas (menggunakan widget `AppTabSelector`).
* **Hasil yang Diharapkan**:
  - Daftar kelas terurut secara menaik berdasarkan nilai `urutan` (7, 8, 9, dst.).
  - Setiap baris kelas menampilkan informasi:
    - Judul: `Kelas <nama_kelas>` (e.g. `Kelas 7`).
    - Subtitle: `Urutan: <nilai_urutan> | Promosi ke: <kelas_selanjutnya>` (e.g. `Urutan: 1 | Promosi ke: Kelas 8`).
    - Jika kelas berikutnya diset null, subtitle menampilkan `Promosi ke: Lulus (Alumni)`.

#### 2.2 Menambah Kelas Baru
* **Langkah-langkah**:
  1. Pada tab **Kelas**, tekan tombol Floating Action Button (`+`) di pojok kanan bawah.
  2. Pastikan Dialog **"Tambah Kelas"** muncul.
  3. *Uji Validasi*: Kosongkan seluruh input, lalu tekan tombol **"Simpan"**.
     - **Ekspektasi**: Tampil pesan error `"Nama kelas harus diisi"` dan `"Urutan harus diisi"`.
  4. *Uji Validasi Urutan*: Masukkan huruf pada field **"Urutan Kelas"**.
     - **Ekspektasi**: Keyboard bertipe angka terbuka dan validator mencegah input non-angka dengan pesan `"Urutan harus berupa angka"`.
  5. *Uji Input Sukses*: 
     - Masukkan "13" pada **Nama Kelas**.
     - Masukkan "7" pada **Urutan Kelas**.
     - Pada dropdown **"Kelas Selanjutnya"** (menggunakan `animated_custom_dropdown`), pilih **"Lulus (Alumni)"**.
     - Tekan **"Simpan"**.
* **Hasil yang Diharapkan**:
  - Dialog tertutup otomatis.
  - Data "Kelas 13" muncul di urutan paling bawah dalam list kelas.
  - Dokumen baru berhasil ditambahkan pada Firestore `/kelas`.

#### 2.3 Mengedit Kelas
* **Langkah-langkah**:
  1. Tekan tombol edit (ikon pensil warna hijau/biru) pada salah satu kelas, misalnya **"Kelas 12"**.
  2. Dialog **"Edit Kelas"** terbuka dengan data yang sudah terisi.
  3. Ubah dropdown **"Kelas Selanjutnya"** dari semula `"Lulus (Alumni)"` menjadi kelas lain (misalnya `"Kelas 13"`).
  4. Tekan **"Simpan"**.
* **Hasil yang Diharapkan**:
  - Dialog tertutup secara instan.
  - Subtitle dari "Kelas 12" berubah menjadi `Urutan: 6 | Promosi ke: Kelas 13`.
  - Di Firestore `/kelas`, field `nextKelasId` untuk Kelas 12 terupdate dengan ID Kelas 13.

#### 2.4 Menghapus Kelas
* **Langkah-langkah**:
  1. Tekan tombol hapus (ikon tempat sampah warna merah) pada **"Kelas 13"**.
  2. Pastikan Dialog Konfirmasi muncul: *"Apakah Anda yakin ingin menghapus Kelas 13? Tindakan ini tidak dapat dibatalkan."*
  3. Tekan **"Batal"**.
     - **Ekspektasi**: Dialog tertutup dan Kelas 13 tetap ada di list.
  4. Tekan tombol hapus lagi, lalu tekan **"Hapus"**.
* **Hasil yang Diharapkan**:
  - Dialog tertutup.
  - Kelas 13 hilang dari daftar tampilan list.
  - Dokumen dengan ID Kelas 13 terhapus secara permanen dari Firestore `/kelas`.

---

### Skenario 3: Pengelolaan Program (Tab Program)

#### 3.1 Menampilkan Daftar Program
* **Langkah-langkah**:
  1. Buka halaman **"Kelola Kelas & Program"**.
  2. Pilih tab **Program** di bagian atas (menggunakan widget `AppTabSelector`).
* **Hasil yang Diharapkan**:
  - Tampil daftar program yang terdaftar (e.g. Reguler, Takhassus).
  - Setiap item menampilkan Nama Program (judul) dan Kode Program / ID (subtitle, e.g. `ID: R`).

#### 3.2 Menambah Program Baru
* **Langkah-langkah**:
  1. Pada tab **Program**, tekan tombol Floating Action Button (`+`) di pojok kanan bawah.
  2. Pastikan Dialog **"Tambah Program"** muncul.
  3. *Uji Validasi*: Kosongkan input "Kode Program" dan "Nama Program", tekan **"Simpan"**.
     - **Ekspektasi**: Tampil validator error `"Kode program harus diisi"` dan `"Nama program harus diisi"`.
  4. *Uji Input Sukses*:
     - Masukkan `"TH"` pada **Kode Program**.
     - Masukkan `"Tahfidz"` pada **Nama Program**.
     - Tekan **"Simpan"**.
* **Hasil yang Diharapkan**:
  - Dialog tertutup.
  - Program "Tahfidz" (ID: TH) tampil di list program.
  - Dokumen baru berhasil ditambahkan pada Firestore `/program` dengan ID dokumen `"TH"`.

#### 3.3 Mengedit Program
* **Langkah-langkah**:
  1. Tekan tombol edit pada program **"Tahfidz"**.
  2. Dialog **"Edit Program"** muncul.
  3. Perhatikan field **"Kode Program"** (seharusnya dinonaktifkan/disabled karena ID bersifat immutable).
  4. Ubah **"Nama Program"** menjadi `"Tahfidz Intensif"`.
  5. Tekan **"Simpan"**.
* **Hasil yang Diharapkan**:
  - Dialog tertutup.
  - Nama program pada daftar berubah menjadi "Tahfidz Intensif".
  - Di Firestore `/program/TH`, field `nama` berubah menjadi `"Tahfidz Intensif"`.

#### 3.4 Menghapus Program
* **Langkah-langkah**:
  1. Tekan tombol hapus pada program **"Tahfidz Intensif"**.
  2. Tampil dialog konfirmasi hapus.
  3. Tekan **"Hapus"**.
* **Hasil yang Diharapkan**:
  - Program terhapus dari daftar list di aplikasi.
  - Dokumen `"TH"` terhapus secara permanen dari Firestore `/program`.

---

## 4. Skenario Integrasi Downstream (Dampak Perubahan Data)

Setelah melakukan manipulasi data di atas, pastikan efek dinamisnya berjalan pada modul lain di bawah ini:

### 4.1 Dialog Tambah Santri Manual
* **Langkah-langkah**:
  1. Navigasi ke menu utama Admin Dashboard -> **"Kelola Santri"**.
  2. Tekan tombol **"Tambah Santri"** -> Pilih **"Input Manual"**.
  3. Periksa dropdown **Kelas** dan **Program**.
* **Hasil yang Diharapkan**:
  - Pilihan Kelas dan Program yang tersedia di dropdown mengambil data dinamis terbaru dari Firestore.
  - Jika sebelumnya Anda menambahkan program baru (e.g. "Tahfidz"), program tersebut wajib muncul di dropdown.

### 4.2 Filter pada Daftar Santri & Halaqoh
* **Langkah-langkah**:
  1. Di halaman **"Kelola Santri"** atau **"Kelola Halaqoh"**, buka opsi Filter (menggunakan `CustomDropdown`).
  2. Periksa pilihan filter Kelas dan Program.
* **Hasil yang Diharapkan**:
  - Item filter terupdate secara dinamis sesuai isi koleksi `/kelas` dan `/program` terbaru di Firestore.

### 4.3 Kenaikan Kelas (Promosi) Dinamis
* **Langkah-langkah**:
  1. Pastikan Anda memiliki santri di "Kelas 8".
  2. Di database Firestore, set Kelas 8 agar `nextKelasId` menunjuk ke Kelas 9.
  3. Jalankan aksi **Kenaikan Kelas** massal dari menu pengaturan kelola santri.
* **Hasil yang Diharapkan**:
  - Santri di Kelas 8 otomatis dipromosikan ke Kelas 9.
  - Santri di Kelas terakhir (yang memiliki `nextKelasId == null`) otomatis berubah statusnya menjadi Alumni (`isAlumni = true`).
