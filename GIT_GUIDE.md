# 🚀 How to Send All Project Data to Git / GitHub

This guide explains step-by-step how to upload this entire project to GitHub, GitLab, or Bitbucket.

---

## 🛠️ Step 1: Install Git (If not already installed)

If you haven't installed Git on your computer yet:
1. Download the official installer from: **[https://git-scm.com/download/win](https://git-scm.com/download/win)**
2. Run the installer with default recommended settings.
3. *Alternative (via PowerShell as Administrator)*:
   ```powershell
   winget install --id Git.Git -e --source winget
   ```

---

## 🌐 Step 2: Create a New Empty Repository on GitHub

1. Go to **[GitHub](https://github.com/)** and sign in.
2. Click the **`+`** icon in the top right corner and choose **"New repository"** (or visit [https://github.com/new](https://github.com/new)).
3. Enter a repository name (e.g., `faculty-management-system`).
4. **Important**: Leave "Initialize this repository with a README" **unchecked** (we already have all the project files and a `.gitignore`).
5. Click **"Create repository"**.
6. Copy the repository URL (e.g. `https://github.com/YOUR_USERNAME/faculty-management-system.git`).

---

## 💻 Step 3: Send All Project Files to Git

### Option A: Using the Automated One-Click Script
Double-click the **`git-push.bat`** file in your project folder `C:\Users\Leena\Desktop\P1\git-push.bat`. It will automatically:
- Initialize Git.
- Stage all files (skipping `node_modules` and database files via `.gitignore`).
- Prompt you to paste your GitHub repository URL and push automatically!

---

### Option B: Using the Terminal / PowerShell

Open PowerShell or Command Prompt in the project folder (`C:\Users\Leena\Desktop\P1`):

```powershell
# 1. Initialize local git repository
git init
git branch -M main

# 2. Configure your identity (if running for the first time)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 3. Add all project files
git add .

# 4. Create your first commit
git commit -m "Initial commit: Faculty Onboarding and Offboarding System (PHP and Django)"

# 5. Link your GitHub repository (replace with your URL)
git remote add origin https://github.com/YOUR_USERNAME/faculty-management-system.git

# 6. Push all data to GitHub
git push -u origin main
```

---

## 🔒 What Is Included / Excluded by `.gitignore`

The included `.gitignore` file automatically protects your repository by:
- ✅ **Including**: All Django backend models, views, APIs, PHP portal files, React components, documentation, and configuration files.
- 🚫 **Excluding**:
  - `frontend/node_modules/` (heavy library packages)
  - `backend/db.sqlite3` (local test database)
  - `backend/**/__pycache__/` (Python compiled cache)
  - `backend/media/*` (temporary uploaded test files)
