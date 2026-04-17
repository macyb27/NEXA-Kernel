#!/data/data/com.termux/files/usr/bin/bash

set -e

# =========================
# CONFIG (EDIT!)
# =========================
GITHUB_USER="macyb27"
REPO_NAME="nexa-kernel"
PROJECT_PATH="$HOME/kernel_v20"

# =========================
# START
# =========================

echo "[+] GitHub Safe Push v2 starting..."

cd "$PROJECT_PATH" || {
  echo "[✗] Projektpfad nicht gefunden: $PROJECT_PATH"
  exit 1
}

# =========================
# CHECK GIT
# =========================

if ! command -v git &> /dev/null; then
  echo "[✗] git nicht installiert"
  exit 1
fi

# =========================
# INIT REPO IF NEEDED
# =========================

if [ ! -d ".git" ]; then
  echo "[+] Initialisiere Git Repo..."
  git init
fi

# =========================
# SET USER CONFIG (optional)
# =========================

git config user.name "$GITHUB_USER"

# =========================
# CHECK REMOTE
# =========================

REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "[+] Prüfe Repository Existenz..."

if git ls-remote "$REMOTE_URL" &> /dev/null; then
  echo "[✓] Repo existiert"
else
  echo "[✗] Repo existiert NICHT oder kein Zugriff:"
  echo "    $REMOTE_URL"
  echo ""
  echo "👉 FIX:"
  echo "1. Gehe zu https://github.com/new"
  echo "2. Erstelle Repo: $REPO_NAME"
  echo "3. KEIN README hinzufügen"
  exit 1
fi

# =========================
# SET / FIX REMOTE
# =========================

if git remote | grep -q origin; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# =========================
# ADD + COMMIT
# =========================

git add .

if git diff --cached --quiet; then
  echo "[!] Keine Änderungen zum Commit"
else
  git commit -m "v21.0 kernel stable push"
fi

# =========================
# BRANCH FIX
# =========================

git branch -M main

# =========================
# TAG SAFE
# =========================

if git tag | grep -q "v21.0"; then
  git tag -f v21.0
else
  git tag v21.0
fi

# =========================
# PUSH
# =========================

echo "[+] Push startet..."
echo "👉 Username: $GITHUB_USER"
echo "👉 Passwort: GitHub TOKEN (kein normales Passwort!)"

git push -u origin main
git push origin v21.0

# =========================
# DONE
# =========================

echo ""
echo "[✓] SUCCESS"
echo "Repo: https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "Tag: v21.0"
