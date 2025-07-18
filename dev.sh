#!/bin/bash

# === CONFIGURATION ===
PROJECT_NAME=$1
VISIBILITY=${2:-public}  # Default to public
DATE=$(date)
LOG_FILE="$HOME/.autogit_log.txt"

# === VALIDATION ===
if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Please provide a project name: ./autogit.sh <project_name> [public|private]"
  exit 1
fi

# === CHECK IF DIRECTORY EXISTS ===
if [ -d "$PROJECT_NAME" ]; then
  read -p "⚠️ '$PROJECT_NAME' already exists. Overwrite it? (y/n): " choice
  if [[ "$choice" =~ ^[Yy]$ ]]; then
    rm -rf "$PROJECT_NAME"
    echo "🗑️ Old folder removed."
  else
    echo "❌ Operation canceled."
    exit 1
  fi
fi

# === CREATE FOLDER & INIT GIT ===
mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME" || exit
echo "# $PROJECT_NAME" > README.md
echo -e "📁 Project: $PROJECT_NAME\n🕒 Created: $DATE" >> README.md

git init
git add .
git commit -m "Initial commit by AutoGit"
git branch -M main

# === CREATE REPO ON GITHUB ===
gh repo create "ritesh355/$PROJECT_NAME" --$VISIBILITY --source=. --remote=origin --push

# === LOG SUCCESS ===
echo "$DATE - Project '$PROJECT_NAME' created and pushed [$VISIBILITY]" >> "$LOG_FILE"
echo "✅ '$PROJECT_NAME' successfully created and pushed to GitHub!"
