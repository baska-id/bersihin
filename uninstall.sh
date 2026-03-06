#!/data/data/com.termux/files/usr/bin/bash

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

INSTALL_DIR="$HOME/.bersihin"
BIN_FILE="$PREFIX/bin/bersihin"

echo -e "\n${C_CYN}Sedang membersihkan sistem...${C_RES}"

# Proses penghapusan dengan validasi
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${C_GRN}[+]${C_RES} Folder internal dihapus."
fi

if [ -L "$BIN_FILE" ] || [ -f "$BIN_FILE" ]; then
    rm -f "$BIN_FILE"
    echo -e "${C_GRN}[+]${C_RES} Shortcut perintah dihapus."
fi

# Deep Clean: Hapus file log/cache yang mungkin dibuat oleh script
rm -f "$HOME/.bersihin_history" 2>/dev/null

echo -e "\n${C_GRN}✅ 'bersihin' telah dihapus sepenuhnya dari Termux.${C_RES}"
