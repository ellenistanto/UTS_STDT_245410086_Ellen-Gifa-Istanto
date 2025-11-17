# UTS Sistem Terdistribusi  
**Nama Repo:** bebas  
**Deskripsi:** Jawaban UTS meliputi CAP & BASE, GraphQL & komunikasi antar proses, serta implementasi Streaming Replication PostgreSQL dengan Docker Compose.

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

