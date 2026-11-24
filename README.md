# 🏷 Backup Tool

A command-line utility written in Bash that creates compressed, timestamped `.tar.gz` backups of a folder and automatically rotates old archives.

## 📌 Problem Statement

A laptop gets stolen in a taxi, or a hard drive fails the night before a presentation. `backup.sh` protects important project directories by automating compressed, timestamped backups and cleaning up older archives based on a retention limit.

## 🎯 Project Goals

- Accept a target source directory and validate that it exists
- Create the destination backup folder automatically if it does not exist
- Generate clean, timestamped `.tar.gz` archives (`<folder>-YYYYMMDD-HHMMSS.tar.gz`)
- Rotate old backups to keep only the newest `KEEP` archives per folder

## 🛠 Tech Stack

- Bash (Shell Scripting)
- Git
- GitHub

## 📷 Screenshots

![backup tool](<assets/images/Screenshot From 2026-10-29 15-40-58.png>)

## ⚙ Installation & Setup

Clone the repository and make `backup.sh` executable:

```bash
git clone https://github.com/NyapB/bash_07_backup_tool.git
cd bash_07_backup_tool
chmod +x backup.sh
```

## 💻 Usage & Examples

```bash
./backup.sh [-d DEST] [-k KEEP] SOURCE
```

- Show help instructions (`-h`):

```bash
./backup.sh -h
```

- Back up a folder to the default location (`~/backups`) keeping the 5 newest backups:

```bash
./backup.sh ./my_project
```

- Back up to a custom destination (`-d`) and keep only the 2 newest archive(`-k`):

```bash
./backup.sh -d /tmp/project_backups -k 2 ./my_project
```

- Back up the current working directory (`.`):

```bash
./backup.sh -d ~/backups -k 3 .
```

## 🧠 Challenges Faced

- Parsing command-line options cleanly with `getopts`
- Structuring the script into modular functions (`usage`, `die`, `create_backup`, `rotate_backups`, and `main`)
- Safely rotating archives by timestamp without deleting backups from similarly named folders

## 📚 What I Learned

- Writing functions with parameters, `local` variables, and proper exit codes (`0`, `1`, `2`)
- Organizing a Bash script into clean, modular functions called from `main`
- Parsing flags (`-d`, `-k`, and `-h`) with `getopts` and `case`
- Working with timestamps (`date`), clean archive paths (`tar -C`), and safe sorting (`LC_ALL=C sort`)

## 👨🏽‍💻 Author

Nyap Becky Beri
Junior Fullstack Developer  
[beribecky8@gmail.com](mailto:beribecky8@gmail.com)  

🌍 Based in Cameroon | Open to remote opportunities
