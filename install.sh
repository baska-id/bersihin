#!/data/data/com.termux/files/usr/bin/bash

# --- Konfigurasi Warna ---
C_RES="\e[0m"; C_GRN="\e[1;32m"; C_BLU="\e[1;34m"; C_RED="\e[1;31m"; C_CYN="\e[1;36m"; C_YEL="\e[1;33m"

# Banner agar seragam
banner() {
    clear
    echo -e "${C_CYN}"
    echo "  ___           _        _ _ "
    echo " |_ _|_ __  ___| |_ __ _| | |"
    echo "  | || '_ \/ __| __/ _\` | | |"
    echo "  | || | | \__ \ || (_| | | |"
    echo " |___|_| |_|___/\__\__,_|_|_|"
    echo -e "    🚀 Bersihin Installer${C_RES}\n"
}

banner

INSTALL_DIR="$HOME/.bersihin"
BIN_DIR="$PREFIX/bin"

# Pengecekan keberadaan file utama
if [ ! -f "bersihin.sh" ]; then
    echo -e "${C_RED}[-] ERROR: File bersihin.sh tidak ditemukan!${C_RES}"
    echo -e "${C_BLU}[*] Pastikan kamu berada di folder hasil git clone.${C_RES}"
    exit 1
fi

echo -e "${C_BLU}[1/4]${C_RES} Menyiapkan direktori..."
mkdir -p "$INSTALL_DIR"

echo -e "${C_BLU}[2/4]${C_RES} Menyalin script ke $INSTALL_DIR..."
cp bersihin.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/bersihin.sh"

echo -e "${C_BLU}[3/4]${C_RES} Membuat shortcut global..."
# Gunakan -sf agar jika sudah ada, akan ditimpa tanpa error
ln -sf "$INSTALL_DIR/bersihin.sh" "$BIN_DIR/bersihin"

echo -e "${C_BLU}[4/4]${C_RES} Mengatur environment..."
sleep 1

echo -e "\n${C_GRN}✅ Instalasi Berhasil!${C_RES}"
echo -e "Ketik ${C_CYN}bersihin${C_RES} untuk memulai."

# Fitur Tambahan: Tawarkan untuk menghapus folder git clone agar Termux bersih
echo ""
read -p "Hapus folder instalasi/git clone ini sekarang? (y/n): " clean_now
if [[ "$clean_now" == "y" || "$clean_now" == "Y" ]]; then
    cd ..
    rm -rf bersihin 2>/dev/null
    echo -e "${C_GRN}[+] Folder sementara dihapus. Sistem kamu tetap rapi!${C_RES}"
fi
