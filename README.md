# Parsec Easy Setup

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**An unofficial Windows helper script.**

This application was created to solve common problems with Parsec, such as controller not working, the app failing to launch, running incorrectly, or drivers being installed incorrectly. It helps to completely remove and then perform a clean reinstall of Parsec using the official installer.

---

## ⚠️ Important Disclaimer

**Parsec** is a registered trademark and proprietary software owned by **Unity Technologies** and/or **Parsec Cloud Inc.**
This project (`Parsec Easy Setup`) is **unofficial**, created by the community for the community. The author of this script is not affiliated with the company that develops Parsec.

These scripts only automate the **downloading of the official installer** and managing its installation. All rights to the Parsec client itself, its functionality, and logos belong to their rightful owners.

Before using, please review the official Parsec terms of use: [Parsec Additional Terms](https://unity.com/legal/parsec-additional-terms).

> **Legal Note:** Please be advised that this is a community project. I have not found any information on the official Parsec or Unity websites that explicitly prohibits the creation and distribution of such auxiliary automation utilities. However, I am not a lawyer. This project is provided "as is" without any warranty. If you are a rights holder and believe this project infringes on your rights, please contact me to resolve the issue amicably.

---

## 📦 Features

*   **Semi-automatic Installation**: Checks dependencies and downloads the Parsec installer.
*   **Easy Launch**: Launches the installer from cache or the already installed application.
*   **Complete Removal**: Finds and removes Parsec, including the virtual display driver and USB driver (optional).
*   **Logging**: All key actions are recorded in log files.

---

## 🚀 Quick Start

1.  **Download** or clone this repository.
2.  **Run** the main script `main_menu.bat`.
3.  Follow the instructions in the menu.

**Basic Usage Scenario:**
*   Select item **"1. Install Scoop and git"** (if not installed).
*   Then select item **"2. Download Parsec installer"**.
*   After downloading, you can run the installer via item **"6. Run Parsec installer (from cache)"**.

---

## 📖 Detailed Guide

### Project Structure
```
Parsec-Easy-Setup/
├── lang/ # Localization files
├── logs/ # Logs folder (created automatically)
├── scripts/ # Main scripts
│ ├── download_parsec.bat
│ ├── install_scoop_user.bat
│ ├── uninstall_parsec.bat
│ ├── clean_cache.bat
│ ├── run_installer.bat
│ ├── run_parsec_app.bat
│ ├── open_cache.bat
│ ├── about_author.bat
│ └── instructions.bat
├── config/ # Configuration
├── LICENSE # MIT License file
├── main_menu.bat # MAIN LAUNCH FILE
└── README.md # This file
```

### Step-by-Step Instructions
1.  **Installing Dependencies (Scoop)**
    *   Run `main_menu.bat`.
    *   Select item **1**, then **1** (without administrator rights, recommended).
    *   The script will install Scoop and Git.

2.  **Downloading Parsec**
    *   In the main menu, select item **2**.
    *   The script will check permissions, clear old cache, and start the download.

3.  **Running the Installer**
    *   After a successful download, you can run the installer immediately.
    *   Or later by selecting item **6** in the main menu.
    *   **It is recommended to run the installer as an administrator** for correct driver installation.

4.  **Launching Parsec**
    *   After installation, launch Parsec via item **7** of the main menu or via the desktop shortcut.

5.  **Complete Removal (if needed)**
    *   Use item **3** in the main menu.
    *   Read the warnings carefully. You can remove the main application, as well as the virtual drivers separately or together.

---

## ❓ Frequently Asked Questions

**Q: Is this script safe?**
**A:** Yes. The script does not contain malicious code and works only with official sources. The source code is open for review.

**Q: Are administrator rights required?**
**A:** Not for installing dependencies. For running the Parsec installer and installing drivers — **yes, they are mandatory**.

**Q: The script does not download Parsec, what should I do?**
**A:**
1.  Make sure Scoop is installed (item 1 in the menu).
2.  Try running the script as an administrator.
3.  Check your internet connection.
4.  Review the logs in the `logs/` folder.

**Q: I removed Parsec, but the drivers remained.**
**A:** Use item **"3. Uninstall Parsec"** -> then select option **"3. Remove only Parsec Virtual USB Adapter Driver"**.

---

## 🤝 Contributing

If you find a bug or want to suggest an improvement:
1.  Create an Issue in the repository.
2.  Or Fork the project, make your changes, and open a Pull Request.

---

## 📄 License

The source code of the **Parsec Easy Setup** scripts is distributed under the **MIT** license.
This means you are free to use, modify, and distribute the code provided you retain the original copyright notice and the license text.

The full license text is in the [LICENSE](LICENSE) file.

---

## 👤 Author

*   **FLYaFLYer**
*   Email: lukinyxnikita2@gmail.com
*   Telegram: [@FLYaFLYer](https://t.me/FLYaFLYer)
*   GitHub: [@FLYaFLYer](https://github.com/FLYaFLYer)

*The project was created to help the community. If you found it useful, I'd appreciate a star on GitHub!*