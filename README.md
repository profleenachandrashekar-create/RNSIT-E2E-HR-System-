# NPTEL Fee & Incentive Reimbursement Portal

A full-stack web application designed for educational institutions to verify student eligibility, automate NPTEL examination fee reimbursement, and award merit-based cash incentives using **React**, **Django REST Framework**, and **SQLite**.

---

## 🏗️ Architecture & Features

### 1. Database Schema (SQLite)
* **`Student` Model**: Pre-approved institutional student records (`roll_number`, `full_name`, `email`, `department`).
* **`ReimbursementClaim` Model**: Submitted claims linked to a verified student (`course_name`, `nptel_roll_no`, `score_obtained`, `fee_amount`, `incentive_eligible`, `bank_account_no`, `ifsc_code`, `certificate_file`, `status`, `submitted_at`).
* **Duplicate Prevention**: `unique_together = ('student', 'course_name')` ensures a student cannot claim reimbursement twice for the same course.

### 2. Django REST API (`backend/`)
* **`POST /api/verify-student/`**: Authenticates Name and Roll Number (case-insensitive lookup) against eligible college records.
* **`POST /api/submit-claim/`**: Validates course details, uploads e-certificate, verifies incentive eligibility (`score_obtained >= 75%`), and stores bank info.
* **`GET /api/claims/?roll_number=...`**: Search claims by Roll Number.
* **`GET /api/claims/` & `PATCH /api/claims/<id>/status/`**: Review and approve/reject claims.
* **`GET /api/students/`**: Search pre-approved students directory.
* **Django Admin**: Complete administrative dashboard at `/admin/` with bulk approval/rejection actions and certificate viewer.

### 3. React Frontend (`frontend/`)
* **Two-Step Reimbursement Flow**:
  1. *Step 1*: Immediate verification against institutional SQLite database with quick-test sample profile buttons.
  2. *Step 2*: NPTEL course details, dynamic score-based merit incentive calculation callout, bank details, and certificate file upload.
* **Claims Tracker**: Students can check the status (Pending Review / Approved / Rejected) of all their claims.
* **Reviewer Admin Portal**: Institutional coordinators can inspect submitted claims, verify certificates, and approve/reject disbursements with real-time analytics.
* **Eligible Students Directory**: Searchable list of institutional student records with quick one-click "Apply Now" pre-filling.

---

## 🚀 Quick Start Guide

### Prerequisites
* Python 3.10+
* Node.js 18+ and npm

---

### Step 1: Run Django Backend
```powershell
cd backend

# (Optional: activate virtualenv if used)
# Install dependencies
pip install django djangorestframework django-cors-headers

# Apply database migrations
python manage.py migrate

# Seed sample eligible students (already pre-seeded in SQLite)
python manage.py seed_students

# Start the Django development server
python manage.py runserver 127.0.0.1:8000
```
Backend API will be live at `http://127.0.0.1:8000/`.
Django Admin is accessible at `http://127.0.0.1:8000/admin/` (Login: `admin` / `admin123`).

---

### Step 2: Run React Frontend
In a new terminal window:
```powershell
cd frontend

# Install npm dependencies (if not already installed)
npm install

# Start Vite dev server
npm run dev
```
Open your browser at `http://localhost:5173/`.

---

## 🧪 Testing Backend
To run the automated Django test suite:
```powershell
cd backend
python manage.py test
```

---

## 👥 Demo Profiles for Quick Testing

You can use any of the pre-approved demo records to test student verification:

| Roll Number | Full Name | Department | Email |
| :--- | :--- | :--- | :--- |
| **`21CS001`** | Aarav Sharma | Computer Science | `aarav.sharma@college.edu` |
| **`21CS042`** | Diya Patel | Computer Science | `diya.patel@college.edu` |
| **`21EC015`** | Rohan Iyer | Electronics & Communication | `rohan.iyer@college.edu` |
| **`21ME028`** | Ananya Mukherjee | Mechanical Engineering | `ananya.m@college.edu` |
| **`21EE033`** | Karthik Verma | Electrical Engineering | `karthik.v@college.edu` |
| **`21IT019`** | Sneha Reddy | Information Technology | `sneha.reddy@college.edu` |

### Importing Custom Student Data from CSV
You can import large student lists via CSV:
```powershell
cd backend
python manage.py seed_students --csv sample_students.csv
```
The CSV format requires: `roll_number,full_name,email,department`.
