Bersihin 🧼

"License" (https://img.shields.io/github/license/baska-id/bersihin)
"Last Commit" (https://img.shields.io/github/last-commit/baska-id/bersihin)
"Platform" (https://img.shields.io/badge/platform-Termux-black)
"Shell" (https://img.shields.io/badge/language-Bash-blue)

Bersihin adalah tool CLI sederhana untuk membersihkan cache dan file sementara di Termux agar storage tetap ringan dan lingkungan development tetap rapi.

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

⚡ Quick Install

Install langsung dengan satu command:

curl -sL https://raw.githubusercontent.com/baska-id/bersihin/main/install.sh | bash

---

📦 Manual Install

git clone https://github.com/baska-id/bersihin
cd bersihin
bash install.sh

---

🚀 Usage

Jalankan tool:

bersihin

Contoh output:

🧼 Mulai bersih-bersih Termux...
Cleaning pip cache...
Cleaning apt cache...
Removing temporary files...
Removing Python cache...
✅ Selesai auto-cleanup

---

🗑 Uninstall

Untuk menghapus tool dari sistem:

bersihin --uninstall

---

📁 Clean Targets

Tool ini membersihkan:

- pip cache
- apt cache
- ~/.cache
- Termux temporary files
- Python "__pycache__"

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