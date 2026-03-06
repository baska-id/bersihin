Bersihin 🧼

Simple Termux cleanup tool to remove cache, temporary files, and unnecessary data.
Designed to keep your Termux environment lightweight and tidy.

---

✨ Features

- Clean pip cache
- Remove unused APT packages
- Clean APT cache
- Remove temporary files
- Delete Python "__pycache__" folders
- Fast and lightweight
- Works directly from Termux CLI

---

📦 Installation

Method 1 — Quick Install (Recommended)

curl -sL https://raw.githubusercontent.com/baska-id/bersihin/main/install.sh | bash

---

Method 2 — Manual Install

git clone https://github.com/baska-id/bersihin
cd bersihin
bash install.sh

---

🚀 Usage

Run the cleaner:

bersihin

Example output:

🧼 Mulai bersih-bersih Termux...
Cleaning pip cache...
Cleaning apt cache...
Removing temporary files...
✅ Selesai auto-cleanup

---

🗑 Uninstall

Remove the tool from your system:

bersihin --uninstall

---

📁 What Gets Cleaned

The tool removes cache and temporary files from:

- "pip cache"
- "apt cache"
- "~/.cache"
- "/data/data/com.termux/cache"
- "/data/data/com.termux/files/usr/tmp"
- "/data/data/com.termux/files/tmp"
- Python "__pycache__" folders

---

⚠️ Notes

- This tool is designed specifically for Termux environments.
- Safe cleanup operations only remove temporary or cache files.
- Always ensure no important process is running before cleaning.

---

🧑‍💻 Author

Baska ID

GitHub
https://github.com/baska-id

---

📄 License

MIT License
