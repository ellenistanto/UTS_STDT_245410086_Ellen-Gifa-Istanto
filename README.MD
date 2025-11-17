# UTS Sistem Terdistribusi Dan Terdesentralisasi
**Nama Repo:** bebas  
**NIM:** 245410086
**Nama:** Ellen Gifa Istanto 
**Kelas:**IF 2
---

## 1. Teorema CAP dan BASE

### ### Teorema CAP
Teorema **CAP (Consistency, Availability, Partition Tolerance)** menyatakan bahwa pada sistem terdistribusi, kita hanya bisa memilih **dua dari tiga** hal berikut secara bersamaan:

| Komponen | Penjelasan |
|---------|------------|
| **Consistency (C)** | Semua node punya data yang sama pada waktu yang sama. |
| **Availability (A)** | Semua request mendapat response, meskipun data belum konsisten. |
| **Partition Tolerance (P)** | Sistem tetap jalan walaupun terjadi pemisahan jaringan antar node. |

**Contoh:**  
Saat saya membuat backend sederhana menggunakan MongoDB (NoSQL) untuk aplikasi upload video, saya memilih **AP**: data tetap available meskipun beberapa node belum sinkron.

---

### ### BASE
BASE adalah pendekatan desain NoSQL yang menjadi “kebalikan” pendekatan strict ACID pada SQL.

| Konsep | Penjelasan |
|--------|------------|
| **Basically Available (BA)** | Sistem tetap merespons meski datanya belum konsisten. |
| **Soft-state (S)** | State dapat berubah meski tanpa input eksplisit dari user. |
| **Eventually Consistent (E)** | Data akhirnya akan konsisten, meskipun tidak langsung. |

**Contoh:**  
Pada sistem cache Redis yang pernah saya gunakan untuk mempercepat request ML API, datanya **eventually consistent**—tidak langsung sama dengan database utama.

---

### ### Hubungan CAP dan BASE  
BASE pada dasarnya adalah implementasi praktis dari sistem **AP** pada teorema CAP:

- **CAP AP → BASE**  
- Mengedepankan availability dan partition tolerance  
- Mengorbankan consistency ketat (diganti eventual consistency)

---

## 2. GraphQL & Komunikasi Antar Proses dalam Sistem Terdistribusi

### ### Hubungan GraphQL dengan Inter-process Communication (IPC)
GraphQL bekerja sebagai **query interface** yang menghubungkan klien ke berbagai service. Dalam sistem terdistribusi (microservices), GraphQL berfungsi sebagai **gateway** yang:

- Mengambil data dari banyak service (REST, gRPC, DB, Pub/Sub)
- Menggabungkan data menjadi satu response
- Mengurangi over-fetching & under-fetching
- Berperan sebagai protokol komunikasi antar proses secara **indirect**

**Contoh pribadi:**  
Saat membuat project microservice sederhana (Auth Service + Video Service), saya gunakan GraphQL sebagai "penyatu" data dari dua service berbeda.

---

### ### Diagram GraphQL sebagai IPC Layer

                +-----------------------+
                |        Client         |
                +-----------+-----------+
                            |
                            v
                 +------------------------+
                 |     GraphQL Gateway    |
                 +--+---------+---------+-+
                    |         |         |
                    v         v         v
        +-----------+--+  +---+-----------+  +----------------+
        | Auth Service |  | Video Service |  |   User DB     |
        +--------------+  +---------------+  +----------------+

## 3.PostgreSQL Streaming Replication with Docker Compose

Dokumentasi ini menjelaskan langkah-langkah membuat **streaming replication** PostgreSQL menggunakan Docker dan Docker Compose. Replikasi ini memungkinkan satu server bertindak sebagai **Primary** dan server lain sebagai **Replica**, di mana Replica selalu mengikuti perubahan data dari Primary secara real-time.

---

## Tujuan
- Membangun cluster PostgreSQL dengan Primary dan Replica.
- Memahami alur sinkronisasi dengan mekanisme WAL (Write-Ahead Logging).
- Menguji proses replikasi secara sederhana.

---

## Langkah-Langkah Pembuatan

### 1. Siapkan struktur direktori
Buat folder project yang berisi folder untuk konfigurasi Primary, konfigurasi Replica, dan file Docker Compose.

### 2. Konfigurasi Primary Database
Atur primary agar mendukung streaming replication dengan mengaktifkan pengaturan replikasi dan WAL. Ini memungkinkan primary mengirim data perubahan ke replica.

### 3. Konfigurasi Replica Database
Aktifkan mode *hot standby* agar replica dapat mengikuti primary serta menerima query *read-only*.

### 4. Membuat dan Menjalankan Docker Compose
Siapkan file Docker Compose yang mendefinisikan dua service:
- **Primary**: sebagai sumber data.
- **Replica**: mengambil data awal dari primary dan mengikuti perubahan secara terus-menerus.

Kemudian jalankan seluruh service menggunakan Docker Compose.

### 5. Mengecek Status Replikasi
Periksa primary apakah replica berhasil terhubung dan berada dalam status *streaming*.  
Periksa juga replica apakah berjalan dalam mode recovery (standby).

### 6. Menguji Replikasi
Masukkan data baru ke primary, lalu cek di replica. Jika data muncul dengan otomatis, replikasi berhasil.

---

## Penjelasan Singkat Streaming Replication

Streaming replication bekerja dengan cara primary mengirimkan **WAL (Write-Ahead Log)** kepada replica.  
Setiap perubahan data yang dibuat di primary dicatat ke WAL, lalu dikirim ke replica untuk diterapkan ulang sehingga datanya tetap sinkron.

Keuntungan streaming replication:
- Data mirror real-time.
- Mendukung beban baca di replica.
- Menjadi dasar untuk sistem high availability dan failover.

---

## Catatan Tambahan
- Konfigurasi ini menggunakan **asynchronous replication**, sehingga replica dapat sedikit tertinggal dibanding primary.
- Bisa ditambahkan banyak replica dalam satu cluster.
- Mendukung pengembangan ke **synchronous replication** jika konsistensi absolut diperlukan.

---

## Lisensi
Dokumentasi ini bebas digunakan dan dimodifikasi.




