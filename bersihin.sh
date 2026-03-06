#!/data/data/com.termux/files/usr/bin/bash

INSTALL_DIR="$HOME/.bersihin"
SCRIPT_PATH="$INSTALL_DIR/bersihin.sh"

if [[ "$1" == "--update" ]]; then
echo "🔄 Updating bersihin..."

mkdir -p "$INSTALL_DIR"

if curl -fsSL https://raw.githubusercontent.com/baska-id/bersihin/main/bersihin.sh -o "$SCRIPT_PATH"; then
chmod +x "$SCRIPT_PATH"
echo "✅ Update selesai"
else
echo "❌ Update gagal"
fi

exit
fi


echo "🧼 Mulai bersih-bersih Termux..."

pip cache purge
apt autoremove -y
apt clean

rm -rf ~/.cache/*
rm -rf /data/data/com.termux/cache/*
rm -rf /data/data/com.termux/files/usr/tmp/*
rm -rf /data/data/com.termux/files/tmp/*

find ~ -type d -name "__pycache__" -exec rm -r {} +

echo "✅ Selesai auto-cleanup di $(date)"