#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "[+] GitHub Kernel v21 Setup starting..."

# =========================
# CONFIG (EDIT THIS)
# =========================
REPO_NAME="nexa-kernel"
GITHUB_USER="YOUR_GITHUB_USERNAME"
EMAIL="YOUR_EMAIL"

# =========================
# INIT PROJECT
# =========================

cd ~/kernel_v20 2>/dev/null || {
  echo "[!] kernel_v20 not found"
  exit 1
}

echo "[+] Configuring git..."

git config --global user.name "$GITHUB_USER"
git config --global user.email "$EMAIL"

# =========================
# INIT REPO
# =========================

if [ ! -d ".git" ]; then
  git init
fi

# =========================
# CLEAN + ADD
# =========================

git add .

# =========================
# COMMIT SAFE
# =========================

if git diff --cached --quiet; then
  echo "[!] No changes to commit"
else
  git commit -m "v21.0 frozen kernel - execution OS baseline"
fi

# =========================
# BRANCH SETUP
# =========================

git branch -M main

# =========================
# REMOTE SETUP
# =========================

REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

if git remote | grep -q origin; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# =========================
# TAG RELEASE v21
# =========================

git tag -f v21.0

# =========================
# PUSH
# =========================

echo "[+] Pushing to GitHub..."

git push -u origin main --force
git push origin v21.0 --force

# =========================
# DONE
# =========================

echo "[✓] GitHub setup complete"
echo "[✓] Repo: $REMOTE_URL"
echo "[✓] Tag: v21.0"
