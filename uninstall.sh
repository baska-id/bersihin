#!/usr/bin/env bash

# --- Konfigurasi Warna ---
C_RES="\e[0m"; C_RED="\e[1;31m"; C_YEL="\e[1;33m"; C_GRN="\e[1;32m"; C_CYN="\e[1;36m"

banner() {
    clear
    echo -e "${C_RED}"
    echo "  _   _       _           _        _ _ "
    echo " | | | |_ __ (_)_ __  ___| |_ __ _| | |"
    echo " | | | | '_ \| | '_ \/ __| __/ _\` | | |"
    echo " | |_| | | | | | | | \__ \ || (_| | | |"
    echo "  \___/|_| |_|_|_| |_|___/\__\__,_|_|_|"
    echo -e "    🗑️  Bersihin Uninstaller${C_RES}\n"
}

banner

# Konfirmasi keamanan
echo -e "${C_YEL}Tindakan ini akan menghapus perintah 'bersihin' secara permanen.${C_RES}"
read -p "Lanjutkan penghapusan? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "\n${C_GRN}[*] Pembatalan berhasil. Script tetap terpasang.${C_RES}"
    exit 0
fi

# --- Deteksi lingkungan ---
IS_TERMUX=false
if [[ -d "/data/data/com.termux" ]] || [[ -n "$PREFIX" ]]; then
    IS_TERMUX=true
fi

INSTALL_DIR="$HOME/.bersihin"

echo -e "\n${C_CYN}Sedang membersihkan sistem...${C_RES}"

# Proses penghapusan dengan validasi
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${C_GRN}[+]${C_RES} Folder internal dihapus."
fi

# Hapus symlink dari berbagai kemungkinan lokasi
if $IS_TERMUX; then
    if [ -L "$PREFIX/bin/bersihin" ] || [ -f "$PREFIX/bin/bersihin" ]; then
        rm -f "$PREFIX/bin/bersihin"
        echo -e "${C_GRN}[+]${C_RES} Shortcut dihapus dari $PREFIX/bin."
    fi
else
    for loc in "/usr/local/bin/bersihin" "$HOME/.local/bin/bersihin"; do
        if [ -L "$loc" ] || [ -f "$loc" ]; then
            rm -f "$loc"
            echo -e "${C_GRN}[+]${C_RES} Shortcut dihapus dari $loc."
        fi
    done
fi

# Deep Clean: Hapus file log/cache yang mungkin dibuat oleh script
rm -f "$HOME/.bersihin_history" 2>/dev/null

echo -e "\n${C_GRN}✅ 'bersihin' telah dihapus sepenuhnya.${C_RES}"