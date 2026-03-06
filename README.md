Bersihin 🧼

"License" (https://img.shields.io/badge/license-MIT-green)
"Platform" (https://img.shields.io/badge/platform-Termux-black)
"Shell" (https://img.shields.io/badge/language-Bash-blue)

Bersihin adalah tool CLI sederhana untuk membersihkan cache dan file sementara di Termux, sehingga storage tetap ringan dan lingkungan development tetap rapi.

---

✨ Features

- Clean pip cache
- Remove unused APT packages
- Clean APT cache
- Remove temporary files
- Delete Python "__pycache__" folders
- Fast and lightweight
- Designed specifically for Termux

---

📦 Installation

Quick Install (Recommended)

curl -sL https://raw.githubusercontent.com/baska-id/bersihin/main/install.sh | bash

---

Manual Install

git clone https://github.com/baska-id/bersihin
cd bersihin
bash install.sh

---

🚀 Usage

Menjalankan pembersihan:

bersihin

Contoh output:

🧼 Mulai bersih-bersih Termux...
Cleaning pip cache...
Cleaning apt cache...
Removing temporary files...
✅ Selesai auto-cleanup

---

🗑 Uninstall

Untuk menghapus tool dari sistem:

bersihin --uninstall

---

📁 Clean Targets

Tool ini membersihkan:

- "pip cache"
- "apt cache"
- "~/.cache"
- "/data/data/com.termux/cache"
- "/data/data/com.termux/files/usr/tmp"
- "/data/data/com.termux/files/tmp"
- Python "__pycache__" directories

---

📂 Project Structure

bersihin
├── bersihin.sh
├── install.sh
├── uninstall.sh
├── README.md
└── LICENSE

---

🧑‍💻 Author

Baska ID

GitHub
https://github.com/baska-id

---

📄 License

MIT License