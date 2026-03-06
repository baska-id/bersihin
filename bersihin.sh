#!/data/data/com.termux/files/usr/bin/bash
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
