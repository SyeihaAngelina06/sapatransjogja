# Panduan Deploy SAPA Trans Jogja ke VPS Menggunakan Docker

Dokumen ini berisi langkah-langkah lengkap untuk men-deploy aplikasi **SAPA Trans Jogja** ke server VPS (Virtual Private Server) berbasis Linux (Ubuntu / Debian / CentOS / AlmaLinux).

---

## 1. Persiapan Server VPS

### A. Update Sistem & Install Git & Curl
Jalankan perintah berikut di terminal VPS:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl ufw
```

### B. Install Docker & Docker Compose
Jika di VPS belum terinstall Docker, jalankan script instalasi resmi Docker:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```
*Logout dan login kembali ke VPS agar izin group `docker` aktif, atau gunakan `newgrp docker`.*

Verifikasi instalasi:
```bash
docker --version
docker compose version
```

### C. Buka Port Firewall (UFW)
Buka port 10 (Frontend) dan port 8010 (Backend API):
```bash
sudo ufw allow 22/tcp
sudo ufw allow 10/tcp
sudo ufw allow 8010/tcp
sudo ufw enable
```

---

## 2. Clone Repository ke VPS

```bash
cd ~
git clone <URL_REPOSITORY_ANDA> sapatransjogja
cd sapatransjogja
```

---

## 3. Konfigurasi Environment (`.env`)

Salin template environment:
```bash
cp .env.example .env
cp sapa-laravel/.env.example sapa-laravel/.env
```

Buka file `.env` jika ingin mengubah konfigurasi:
```bash
nano .env
```
Pastikan pengaturan berikut sudah sesuai:
- `MAPID_API_KEY`: API Key MAPID
- `DB_HOST`, `DB_USERNAME`, `DB_PASSWORD`: Koneksi Supabase Postgres
- `GEMINI_API_KEY`: API Key Google Gemini (untuk AI Chatbot)

---

## 4. Jalankan Deployment

Cukup jalankan script deployment otomatis yang telah disediakan:
```bash
chmod +x deploy.sh
./deploy.sh
```

Atau jalankan secara manual menggunakan Docker Compose:
```bash
docker compose up -d --build
```

---

## 5. Mengakses Aplikasi

Setelah container berjalan:
- **Frontend Web (React SPA)**:
  `http://<IP_VPS_ANDA>:10`
- **Backend API & Peta Blade (Laravel)**:
  `http://<IP_VPS_ANDA>:8010`
  - Contoh test API: `http://<IP_VPS_ANDA>:8010/api/activities`
  - Contoh test Peta: `http://<IP_VPS_ANDA>:8010/map`

---

## 6. Perintah Operasional Harian

- **Melihat status kontainer:**
  ```bash
  docker compose ps
  ```

- **Melihat log backend / frontend secara realtime:**
  ```bash
  docker compose logs -f
  # Atau spesifik backend saja:
  docker compose logs -f backend
  ```

- **Merestart aplikasi:**
  ```bash
  docker compose restart
  ```

- **Menghentikan aplikasi:**
  ```bash
  docker compose down
  ```

- **Update code terbaru dari Git:**
  ```bash
  git pull
  docker compose up -d --build
  ```

- **Menjalankan Artisan Laravel di dalam container:**
  ```bash
  docker compose exec backend php artisan <perintah>
  # Contoh:
  docker compose exec backend php artisan route:list
  ```

---

## 7. Menggunakan Domain & SSL Gratis (Opsional / Recommended)

Jika Anda memiliki nama domain (misal: `sapa.domain.com`):
1. Arahkan DNS **A Record** dari domain Anda ke IP VPS.
2. Anda dapat menggunakan Cloudflare (aktifkan mode Proxy "Orange Cloud") untuk mendapatkan SSL otomatis (HTTPS).
3. Ubah `APP_URL` di `.env` menjadi `https://sapa.domain.com`.
