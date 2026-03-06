Bersihin 🧼


![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Termux-black)
![Shell](https://img.shields.io/badge/language-Bash-blue)

Bersihin adalah alat pembersih CLI untuk Termux dan Linux. Ia membersihkan cache, file sementara, dan direktori sampah dari berbagai bahasa pemrograman dan package manager, sehingga penyimpanan tetap ringan dan lingkungan development rapi.

---

✨ Fitur

- Membersihkan cache APT (pkg)
- Membersihkan cache Python ("pip", "__pycache__")
- Membersihkan cache Node.js ("npm", "yarn")
- Membersihkan cache Go, Rust ("cargo"), Ruby ("gem"), PHP ("composer")
- Menghapus file temporary ("/tmp", "~/.cache", dll.)
- Dukungan penuh untuk Termux dan Linux (Debian/Ubuntu, dll.)
- Mode dry-run untuk melihat apa yang akan dihapus
- Update otomatis dari GitHub
- Uninstall terintegrasi

---

📦 Instalasi

Cara Cepat (via curl)

curl -sL https://raw.githubusercontent.com/baska-id/bersihin/main/install.sh | bash

Manual (via git clone)

git clone https://github.com/baska-id/bersihin
cd bersihin
bash install.sh

Setelah instalasi, jalankan dengan perintah "bersihin".

Catatan untuk Linux: Jika direktori instalasi ("~/.local/bin" atau "/usr/local/bin") belum ada di "PATH", ikuti petunjuk yang muncul untuk menambahkannya.

---

🚀 Penggunaan

bersihin            # Pembersihan menyeluruh
bersihin --apt      # Hanya bersihkan APT
bersihin --lang     # Hanya bersihkan cache bahasa
bersihin --sys      # Hanya bersihkan temporary & log
bersihin --dry-run  # Lihat apa yang akan dihapus (tanpa hapus)
bersihin --update   # Perbarui script ke versi terbaru
bersihin --uninstall # Hapus Bersihin dari sistem
bersihin --help     # Tampilkan bantuan

Contoh output

🧼 Mulai bersih-bersih...
[*] Membersihkan cache APT...
[+] APT Cache bersih.
[*] Membersihkan cache bahasa...
[+] Python (pip & pycache) bersih.
[+] NodeJS (npm cache) bersih.
...
✅ Selesai! Berhasil menghemat memori sebesar 125.67 MB.
📅 Waktu: Sen 3 Mar 2025 14:30:45 WIB

---

🔄 Update

Untuk memperbarui ke versi terbaru:

bersihin --update

---

🗑 Uninstall

bersihin --uninstall

Atau jalankan "uninstall.sh" dari direktori sumber.

---

📁 Target Pembersihan

- APT: cache paket, paket tidak terpakai
- Python: pip cache, direktori "__pycache__"
- Node.js: npm cache, yarn cache
- Go: "go clean -cache"
- Rust: cargo cache (jika ada)
- Ruby: gem cleanup
- PHP: composer clear-cache
- Sistem: "~/.cache", "/tmp", "/var/tmp", log files, trash

---

📂 Struktur Proyek

bersihin/
├── bersihin.sh      # Skrip utama
├── install.sh       # Pemasang
├── uninstall.sh     # Penghapus
├── README.md        # Dokumentasi
└── LICENSE          # MIT License

---

🧑‍💻 Author

Baska ID
GitHub: @baska-id

---

📄 Lisensi

MIT License

---

Ringkasan Perubahan

- Portabilitas: Skrip kini dapat berjalan di Termux dan Linux umum.
- Keamanan: Penggunaan "${var:?}" dan "safe_rm" untuk mencegah penghapusan tidak sengaja.
- Fitur baru: "--dry-run", pembersihan untuk Rust, Ruby, PHP.
- Instalasi cerdas: Memilih direktori bin yang sesuai dan memberi petunjuk PATH.
- Dokumentasi: Diperbarui dengan fitur dan petunjuk yang lebih jelas.