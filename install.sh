#!/usr/bin/env bash

# --- Konfigurasi Warna ---
C_RES="\e[0m"; C_GRN="\e[1;32m"; C_BLU="\e[1;34m"; C_RED="\e[1;31m"; C_CYN="\e[1;36m"; C_YEL="\e[1;33m"

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

# --- Deteksi lingkungan ---
IS_TERMUX=false
if [[ -d "/data/data/com.termux" ]] || [[ -n "$PREFIX" ]]; then
    IS_TERMUX=true
fi

# --- Tentukan direktori instalasi ---
INSTALL_DIR="$HOME/.bersihin"
mkdir -p "$INSTALL_DIR"

# --- Tentukan direktori bin ---
if $IS_TERMUX; then
    BIN_DIR="$PREFIX/bin"
else
    # Coba beberapa lokasi umum
    if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
        BIN_DIR="$HOME/.local/bin"
    elif [[ -d "/usr/local/bin" ]] && [[ -w "/usr/local/bin" ]]; then
        BIN_DIR="/usr/local/bin"
    else
        # Fallback ke ~/.local/bin dan tambahkan ke PATH nanti
        BIN_DIR="$HOME/.local/bin"
        mkdir -p "$BIN_DIR"
        if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
            echo -e "${C_YEL}[!] Direktori $BIN_DIR belum ada di PATH.${C_RES}"
            echo -e "    Tambahkan baris berikut ke ~/.bashrc atau ~/.zshrc:"
            echo -e "    ${C_CYN}export PATH=\"\$PATH:$BIN_DIR\"${C_RES}"
            echo ""
        fi
    fi
fi

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

echo -e "${C_BLU}[3/4]${C_RES} Membuat shortcut global di $BIN_DIR/bersihin..."
# Gunakan -sf agar jika sudah ada, akan ditimpa tanpa error
ln -sf "$INSTALL_DIR/bersihin.sh" "$BIN_DIR/bersihin"

echo -e "${C_BLU}[4/4]${C_RES} Mengatur environment..."
sleep 1

echo -e "\n${C_GRN}✅ Instalasi Berhasil!${C_RES}"
echo -e "Ketik ${C_CYN}bersihin${C_RES} untuk memulai."

# Fitur Tambahan: Tawarkan untuk menghapus folder git clone agar tetap rapi
echo ""
read -p "Hapus folder instalasi/git clone ini sekarang? (y/n): " clean_now
if [[ "$clean_now" == "y" || "$clean_now" == "Y" ]]; then
    cd ..
    rm -rf "$(basename "$PWD")" 2>/dev/null
    echo -e "${C_GRN}[+] Folder sementara dihapus. Sistem kamu tetap rapi!${C_RES}"
fi