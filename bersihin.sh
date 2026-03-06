#!/usr/bin/env bash

# ==========================================
# BERSIHIN - Termux & Linux Ultimate Cleaner
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

# --- DETEKSI LINGKUNGAN ---
IS_TERMUX=false
if [[ -d "/data/data/com.termux" ]] || [[ -n "$PREFIX" ]]; then
    IS_TERMUX=true
fi

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
    echo -e "      ✨ Ultimate Cleaner ✨${C_RES}\n"
}

# --- HITUNG RUANG (lebih akurat dengan du) ---
# Variabel global untuk menyimpan total byte yang dihapus (hanya untuk --dry-run)
TOTAL_CLEANED=0

# Fungsi untuk menghitung ukuran direktori/file (dalam byte)
get_size() {
    du -sb "$1" 2>/dev/null | cut -f1
}

# Fungsi untuk menghapus dengan aman dan mencatat ukuran
safe_rm() {
    local target="$1"
    if [[ -e "$target" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            local size=$(get_size "$target")
            TOTAL_CLEANED=$((TOTAL_CLEANED + size))
            info "[DRY RUN] Akan menghapus: $target ($(numfmt --to=iec $size))"
        else
            rm -rf "$target"
        fi
    fi
}

# Fungsi untuk mengosongkan isi direktori (tanpa menghapus direktori itu sendiri)
safe_rm_contents() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            local size=$(get_size "$dir")
            TOTAL_CLEANED=$((TOTAL_CLEANED + size))
            info "[DRY RUN] Akan mengosongkan: $dir ($(numfmt --to=iec $size))"
        else
            rm -rf "${dir:?}"/*
        fi
    fi
}

# --- MODULES ---
update_script() {
    info "Mengunduh pembaruan dari server..."
    mkdir -p "$INSTALL_DIR"
    
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

uninstall_script() {
    banner
    echo -e "${C_RED}⚠️  PERINGATAN: Kamu akan menghapus Bersihin dari sistem.${C_RES}"
    read -p "Apakah kamu yakin? (y/n): " konfirmasi
    if [[ "$konfirmasi" == "y" || "$konfirmasi" == "Y" ]]; then
        info "Menghapus file dan shortcut..."
        rm -rf "$INSTALL_DIR"
        # Cari lokasi bin
        if [[ -L "$PREFIX/bin/bersihin" ]]; then
            rm -f "$PREFIX/bin/bersihin"
        elif [[ -L "/usr/local/bin/bersihin" ]]; then
            sudo rm -f "/usr/local/bin/bersihin"
        elif [[ -L "$HOME/.local/bin/bersihin" ]]; then
            rm -f "$HOME/.local/bin/bersihin"
        fi
        sukses "Bersihin telah berhasil dihapus."
        exit 0
    else
        info "Penghapusan dibatalkan."
        exit 0
    fi
}

clean_apt() {
    info "Membersihkan cache APT (Packages)..."
    if $IS_TERMUX; then
        apt-get autoremove -y > /dev/null 2>&1
        apt-get clean > /dev/null 2>&1
        sukses "APT Cache bersih."
    else
        if command -v apt-get &>/dev/null; then
            # Coba tanpa sudo dulu
            if apt-get clean 2>/dev/null; then
                apt-get autoremove -y > /dev/null 2>&1
                sukses "APT Cache bersih."
            else
                peringatan "Membutuhkan akses root untuk membersihkan APT cache. Jalankan dengan sudo jika perlu."
            fi
        else
            info "APT tidak ditemukan, lewati."
        fi
    fi
}

clean_langs() {
    info "Membersihkan cache bahasa pemrograman..."
    
    # Python
    if command -v pip &>/dev/null; then
        pip cache purge > /dev/null 2>&1
        find "$HOME" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
        sukses "Python (pip & pycache) bersih."
    fi

    # Node.js (npm)
    if command -v npm &>/dev/null; then
        npm cache clean --force > /dev/null 2>&1
        sukses "NodeJS (npm cache) bersih."
    fi
    # Yarn
    if command -v yarn &>/dev/null; then
        yarn cache clean > /dev/null 2>&1
        sukses "Yarn cache bersih."
    fi

    # Go
    if command -v go &>/dev/null; then
        go clean -cache > /dev/null 2>&1
        sukses "Go cache bersih."
    fi

    # Rust (cargo)
    if command -v cargo &>/dev/null; then
        cargo cache clean > /dev/null 2>&1 || cargo sweep -r > /dev/null 2>&1 || true
        sukses "Cargo cache bersih."
    fi

    # Ruby (gem)
    if command -v gem &>/dev/null; then
        gem cleanup > /dev/null 2>&1
        sukses "Gem cache bersih."
    fi

    # PHP (composer)
    if command -v composer &>/dev/null; then
        composer clear-cache > /dev/null 2>&1
        sukses "Composer cache bersih."
    fi
}

clean_system() {
    info "Membersihkan temporary files & system cache..."
    
    if $IS_TERMUX; then
        TMP_DIRS=(
            "$HOME/.cache"
            "/data/data/com.termux/cache"
            "/data/data/com.termux/files/usr/tmp"
            "/data/data/com.termux/files/tmp"
        )
        LOG_DIR="/data/data/com.termux/files/usr/var/log"
    else
        TMP_DIRS=(
            "$HOME/.cache"
            "/tmp"
            "/var/tmp"
        )
        LOG_DIR="/var/log"
        # Tambahan untuk Linux: trash
        if [[ -d "$HOME/.local/share/Trash" ]]; then
            safe_rm_contents "$HOME/.local/share/Trash/files"
            safe_rm_contents "$HOME/.local/share/Trash/expunged"
        fi
    fi

    for dir in "${TMP_DIRS[@]}"; do
        safe_rm_contents "$dir"
    done

    # Bersihkan file log dengan mengosongkannya (truncate)
    if [[ -d "$LOG_DIR" ]]; then
        find "$LOG_DIR" -type f -name "*.log" -exec truncate -s 0 {} + 2>/dev/null
    fi
    
    sukses "System Temp & Log bersih."
}

show_help() {
    banner
    echo -e "Penggunaan: ${C_YEL}bersihin [OPSI]${C_RES}"
    echo -e "Tanpa opsi, script akan menjalankan pembersihan menyeluruh."
    echo -e ""
    echo -e "Opsi yang tersedia:"
    echo -e "  ${C_GRN}--apt${C_RES}         Membersihkan cache paket (APT)"
    echo -e "  ${C_GRN}--lang${C_RES}        Membersihkan cache (Python, Node, Go, Rust, Ruby, PHP)"
    echo -e "  ${C_GRN}--sys${C_RES}         Membersihkan file temporary & log"
    echo -e "  ${C_GRN}--dry-run${C_RES}     Simulasi (tampilkan yang akan dihapus tanpa menghapus)"
    echo -e "  ${C_GRN}--update${C_RES}      Memperbarui script dari GitHub"
    echo -e "  ${C_GRN}--uninstall${C_RES}   Menghapus script dari sistem"
    echo -e "  ${C_GRN}--help${C_RES}        Menampilkan halaman bantuan"
    echo -e ""
    exit 0
}

# --- MAIN LOGIC ---
DRY_RUN=false
# Parse argumen
ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done
set -- "${ARGS[@]}"

case "$1" in
    --update)
        banner
        update_script
        ;;
    --uninstall)
        uninstall_script
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
        if $DRY_RUN; then
            info "Menjalankan mode simulasi (dry-run)..."
        fi
        SPACE_BEFORE=$(df -k . | tail -1 | awk '{print $4}')
        
        clean_apt
        clean_langs
        clean_system

        if $DRY_RUN; then
            echo ""
            sukses "Simulasi selesai. Total ruang yang akan dibersihkan: $(numfmt --to=iec $TOTAL_CLEANED)"
        else
            SPACE_AFTER=$(df -k . | tail -1 | awk '{print $4}')
            SAVED_KB=$((SPACE_AFTER - SPACE_BEFORE))
            echo ""
            if [ "$SAVED_KB" -gt 0 ]; then
                SAVED_MB=$(awk "BEGIN {printf \"%.2f\", $SAVED_KB/1024}")
                sukses "Selesai! Berhasil menghemat memori sebesar ${C_YEL}${SAVED_MB} MB${C_RES}."
            else
                sukses "Selesai! Sistem Termux kamu sudah bersih."
            fi
        fi
        echo -e "📅 Waktu: $(date)"
        ;;
    *)
        gagal "Opsi '$1' tidak dikenali."
        echo "Ketik 'bersihin --help' untuk melihat panduan."
        exit 1
        ;;
esac