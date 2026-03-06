#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# BERSIHIN - Termux Ultimate Cleaner
# ==========================================

INSTALL_DIR="$HOME/.bersihin"
SCRIPT_PATH="$INSTALL_DIR/bersihin.sh"
REPO_URL="https://raw.githubusercontent.com/baska-id/bersihin/main/bersihin.sh"

# --- KOSMETIK: Konfigurasi Warna ---
C_RES="\e[0m"
C_RED="\e[1;31m"
C_GRN="\e[1;32m"
C_YEL="\e[1;33m"
C_BLU="\e[1;34m"
C_CYN="\e[1;36m"

# --- FUNGSI HELPER ---
info() { echo -e "${C_BLU}[*]${C_RES} $1"; }
sukses() { echo -e "${C_GRN}[+]${C_RES} $1"; }
peringatan() { echo -e "${C_YEL}[!]${C_RES} $1"; }
gagal() { echo -e "${C_RED}[-]${C_RES} $1"; }

banner() {
    clear
    echo -e "${C_CYN}"
    echo "  ____               _ _     _       "
    echo " |  _ \             (_) |   (_)      "
    echo " | |_) | ___ _ __ ___ _| |__  _ _ __  "
    echo " |  _ < / _ \ '__/ __| | '_ \| | '_ \ "
    echo " | |_) |  __/ |  \__ \ | | | | | | | |"
    echo " |____/ \___|_|  |___/_|_| |_|_|_| |_|"
    echo "                                     "
    echo -e "      ✨ Termux Ultimate Cleaner ✨${C_RES}\n"
}

# --- HITUNG SPACE ---
get_free_space() {
    df -k /data | tail -1 | awk '{print $4}'
}

# --- MODULES ---
update_script() {
    info "Mengunduh pembaruan dari server..."
    mkdir -p "$INSTALL_DIR"
    
    # Download ke file temporary dulu agar aman jika internet putus di tengah jalan
    if curl -fsSL "$REPO_URL" -o "$SCRIPT_PATH.tmp"; then
        mv "$SCRIPT_PATH.tmp" "$SCRIPT_PATH"
        chmod +x "$SCRIPT_PATH"
        sukses "Update berhasil! Jalankan ulang script."
    else
        gagal "Update gagal. Periksa koneksi internet kamu."
        rm -f "$SCRIPT_PATH.tmp"
    fi
    exit 0
}

clean_apt() {
    info "Membersihkan cache APT (Packages)..."
    apt-get autoremove -y > /dev/null 2>&1
    apt-get clean > /dev/null 2>&1
    sukses "APT Cache bersih."
}

clean_langs() {
    info "Membersihkan cache bahasa pemrograman..."
    
    # Python
    if command -v pip > /dev/null 2>&1; then
        pip cache purge > /dev/null 2>&1
        find ~ -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
        sukses "Python (pip & pycache) bersih."
    fi

    # NodeJS
    if command -v npm > /dev/null 2>&1; then
        npm cache clean --force > /dev/null 2>&1
        sukses "NodeJS (npm cache) bersih."
    fi
    if command -v yarn > /dev/null 2>&1; then
        yarn cache clean > /dev/null 2>&1
        sukses "Yarn cache bersih."
    fi

    # Go
    if command -v go > /dev/null 2>&1; then
        go clean -cache > /dev/null 2>&1
        sukses "Go cache bersih."
    fi
}

clean_system() {
    info "Membersihkan temporary files & system cache..."
    
    # Daftar folder aman untuk dibersihkan
    TMP_DIRS=(
        "$HOME/.cache"
        "/data/data/com.termux/cache"
        "/data/data/com.termux/files/usr/tmp"
        "/data/data/com.termux/files/tmp"
    )

    for dir in "${TMP_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            # Parameter ${dir:?} mencegah bencana (mencegah command menjadi rm -rf /*)
            rm -rf "${dir:?}"/* 2>/dev/null
        fi
    done

    # Bersihkan isi log yang menumpuk tanpa menghapus file utamanya
    find /data/data/com.termux/files/usr/var/log -type f -name "*.log" -exec truncate -s 0 {} + 2>/dev/null
    
    sukses "System Temp & Log bersih."
}

show_help() {
    banner
    echo -e "Penggunaan: ${C_YEL}bersihin.sh [OPSI]${C_RES}"
    echo -e "Tanpa opsi, script akan menjalankan pembersihan menyeluruh secara otomatis."
    echo -e ""
    echo -e "Opsi yang tersedia:"
    echo -e "  ${C_GRN}--apt${C_RES}       Membersihkan cache paket instalasi (APT) saja"
    echo -e "  ${C_GRN}--lang${C_RES}      Membersihkan cache bahasa pemrograman (Python, Node, Go)"
    echo -e "  ${C_GRN}--sys${C_RES}       Membersihkan file temporary dan file log"
    echo -e "  ${C_GRN}--update${C_RES}    Memperbarui script ini dari GitHub"
    echo -e "  ${C_GRN}--help${C_RES}      Menampilkan halaman bantuan ini"
    echo -e ""
    exit 0
}

# --- MAIN LOGIC ---
case "$1" in
    --update)
        banner
        update_script
        ;;
    --apt)
        banner
        clean_apt
        ;;
    --lang)
        banner
        clean_langs
        ;;
    --sys)
        banner
        clean_system
        ;;
    --help|-h)
        show_help
        ;;
    "")
        banner
        # Cek sisa storage sebelum pembersihan
        SPACE_BEFORE=$(get_free_space)
        
        clean_apt
        clean_langs
        clean_system

        # Cek sisa storage setelah pembersihan
        SPACE_AFTER=$(get_free_space)
        SAVED_KB=$((SPACE_AFTER - SPACE_BEFORE))
        
        echo ""
        if [ "$SAVED_KB" -gt 0 ]; then
            SAVED_MB=$(awk "BEGIN {printf \"%.2f\", $SAVED_KB/1024}")
            sukses "Selesai! Berhasil menghemat memori sebesar ${C_YEL}${SAVED_MB} MB${C_RES}."
        else
            sukses "Selesai! Sistem Termux kamu sebelumnya memang sudah sangat bersih."
        fi
        echo -e "📅 Waktu: $(date)"
        ;;
    *)
        gagal "Opsi '$1' tidak dikenali."
        echo "Ketik 'bersihin.sh --help' untuk melihat panduan."
        exit 1
        ;;
esac
