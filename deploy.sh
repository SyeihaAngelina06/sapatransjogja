#!/bin/bash
set -e

echo "=================================================="
echo "  SAPA Trans Jogja - VPS Deployment Script"
echo "=================================================="

# 1. Cek Docker & Docker Compose
if ! command -v docker &> /dev/null; then
    echo "[ERROR] Docker belum terinstall! Silakan install Docker terlebih dahulu."
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "[ERROR] Docker Compose belum terinstall!"
    exit 1
fi

# 2. Siapkan file environment
if [ ! -f .env ]; then
    echo "[INFO] Menyiapkan .env dari .env.example..."
    cp .env.example .env
fi

if [ ! -f sapa-laravel/.env ]; then
    echo "[INFO] Menyiapkan sapa-laravel/.env..."
    cp sapa-laravel/.env.example sapa-laravel/.env
fi

# 3. Build dan jalankan container
echo "[INFO] Melakukan build Docker image..."
docker compose build

echo "[INFO] Menjalankan service dengan Docker Compose..."
docker compose up -d

echo "[INFO] Menunggu backend inisialisasi..."
sleep 5

# 4. Status container
docker compose ps

echo ""
echo "=================================================="
echo "  DEPLOYMENT SELESAI!"
echo "=================================================="
echo "Frontend Web   : http://<IP_VPS_ANDA>:10"
echo "Laravel Backend: http://<IP_VPS_ANDA>:8010"
echo ""
echo "Cek logs dengan : docker compose logs -f"
echo "Restart service : docker compose restart"
echo "Stop service    : docker compose down"
echo "=================================================="
