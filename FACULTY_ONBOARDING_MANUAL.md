# Faculty Onboarding Web App - System Architecture & Integration Manual

A modular, enterprise-grade **Faculty Onboarding Portal** built with **Django REST Framework** (Backend Microservice), **PHP Integration SDK & Portal** (for easy ERP integration), and a **Modern Interactive React UI**.

---

## 🏗️ System Architecture

```
                               ┌──────────────────────────────────────────────────────────┐
                               │                    Bigger Project ERP                    │
                               │           (Campus Intranet / Core PHP / Laravel)         │
                               └──────────────┬────────────────────────────┬──────────────┘
                                              │                            │
                                (Native PHP Widget Embed)      (REST API JSON / Multipart)
                                              │                            │
                                              ▼                            ▼
┌────────────────────────────────────────────────────────┐   ┌───────────────────────────────────────────────────────┐
│               PHP Integration (php_portal/)            │   │               React Frontend (frontend/)              │
│ • index.php: Multi-step Candidate Portal               │   │ • 6-Step Visual Wizard with Upload Buttons            │
│ • embed_widget.php: Drop-in 2-line PHP widget          │   │ • Live File Status Badges & Preview                   │
│ • admin_review.php: HR Document Verification Console   │   │ • HR Document Verification & Allocation Drawer        │
│ • FacultyOnboardingClient.php: OOP cURL Client         │   │ • Application Tracker & ID Generation Preview         │
└───────────────────────────────┬────────────────────────┘   └───────────────────────────┬───────────────────────────┘
                                │                                                        │
                                └───────────────────────┬────────────────────────────────┘
                                                        │ HTTP Multipart / JSON
                                                        ▼
                                ┌────────────────────────────────────────────────────────┐
                                │             Django Microservice (backend/)             │
                                │ • App: faculty_onboarding                              │
                                │ • SQLite/PostgreSQL Database Model                     │
                                │ • Sequential Employee ID Engine: FAC-[DEPT]-YYYY-XXXX  │
                                │ • Django Admin Console with Verification Actions       │
                                │ • REST Endpoints: /api/faculty/*                       │
                                └────────────────────────────────────────────────────────┘
```

---

## 📋 The 6 Onboarding Modules (Fields & Upload Actions)

Each of the 6 sections is built with structured data inputs and dedicated file upload buttons with document validation and verification states:

| # | Section | Form Inputs | Document Upload Buttons | Verification / Processing |
|---|---|---|---|---|
| **1** | **Joining Report & Appointment Order** | Appointment Order No, Appointment Date, Official Joining Date, Reporting Session (FN/AN), Reference/Minute No, Reporting Authority | `📁 Choose Appointment Order` (PDF/Img)<br>`📁 Choose Joining Report` (PDF/Img) | Signed document validation & reporting authority tracking |
| **2** | **Personal & Educational Details** | Full Name, Gender, DOB, Blood Group, Mobile, Emergency Phone, Personal Email, Permanent Address, Current Address, Highest Degree, Discipline, University, Passing Year, CGPA/% | `📷 Choose Photo` (JPG/PNG)<br>`🎓 Choose Degree Certificate` (PDF)<br>`📄 Choose Consolidated Marksheet` (PDF) | Qualification validation against institutional requirements |
| **3** | **Experience & Qualification Verification** | Teaching Experience (Years), Industry/Research Experience (Years), Previous Institution, Previous Designation, Last Salary, Relieving Reason, NET/GATE Roll No, Ph.D. Thesis Title & Guide Name | `💼 Choose Experience Cert` (PDF)<br>`📜 Choose Relieving / NOC` (PDF)<br>`💳 Choose Pay Slip` (PDF)<br>`🎖️ Choose Qualification Proof` (PDF) | Dedicated HR verification flags (`experience_verified`, `qualification_verified`) |
| **4** | **Document Upload & Verification** | Aadhaar Number (12 digits), PAN Card (10 chars), Salary Bank Name, Account Number, IFSC Code, Branch Name | `🆔 Choose Aadhaar Copy` (PDF/Img)<br>`💳 Choose PAN Copy` (PDF/Img)<br>`🏦 Choose Cancelled Cheque / Passbook` (PDF/Img) | Multi-factor compliance verification (`aadhaar_verified`, `pan_verified`, `bank_verified`) |
| **5** | **Employee ID Generation Engine** | Institutional Prefix (`FAC`), Academic Department Code (`CSE`, `ECE`, etc.), Year (`2026`), Generated ID Preview | `⚡ Real-Time Generated ID Preview`<br>`↻ Re-calculate Next Serial` button | Automated collision-free sequential generation: `FAC-[DEPT]-[YEAR]-[0001..9999]` |
| **6** | **Department & Designation Allocation** | Academic Department, Designation (Assistant Prof, Associate Prof, Prof, etc.), Appointment Type (Regular, Contract, Adjunct), Pay Band / Level (Level 10-14), Cabin/Room No, Official College Email | `📑 Choose Allocation Memo` (PDF)<br>`🔘 Choose Biometric & RFID Form` (PDF) | Official allocation memo storage, ID card badge issuance & status completion |

---

## 🚀 Quick Start Guide

### 1. Launch Django Backend
```powershell
cd backend
python manage.py migrate
python manage.py runserver 127.0.0.1:8000
```
- API Base: `http://127.0.0.1:8000/api/faculty/`
- Django Admin: `http://127.0.0.1:8000/admin/` (Login: `admin` / `admin123`)

### 2. Launch Modern React Web UI
```powershell
cd frontend
npm run dev
```
Open `http://localhost:5173/` in your browser. Use the top navigation bar to switch between:
- **Faculty Onboarding Form** (6-step guided wizard with sample profile pre-filler)
- **HR Document Verification & Allocation Console**
- **Track Application Status**
- **PHP & Django Integration Hub**

### 3. Launch Standalone PHP Portal (or Run via XAMPP)
If PHP is installed or if using XAMPP:
```powershell
# Using the provided launcher script:
start-php-portal.bat

# Or run directly:
cd php_portal
php -S 127.0.0.1:8080
```
Open `http://127.0.0.1:8080/index.php` for the full PHP onboarding portal or `http://127.0.0.1:8080/admin_review.php` for the PHP HR verification console.

---

## 🔌 How to Integrate into Your Bigger PHP Project

### Approach A: 2-Line Drop-in PHP Widget (`embed_widget.php`)
In any existing page or view of your larger PHP project:
```php
<?php
// 1. Include the embed widget
require_once __DIR__ . '/php_portal/embed_widget.php';

// 2. Render the complete 6-stage onboarding module
render_faculty_onboarding_widget([
    'target_api'  => 'http://127.0.0.1:8000/api/faculty/',
    'theme_color' => '#1e3a8a',
    'show_title'  => true,
]);
?>
```

### Approach B: Using the OOP PHP Client SDK (`FacultyOnboardingClient.php`)
```php
<?php
require_once __DIR__ . '/php_portal/FacultyOnboardingClient.php';

$client = new FacultyOnboardingClient('http://127.0.0.1:8000/api/faculty/');

// 1. Submit application with text fields and file attachments
$response = $client->submitOnboarding($_POST, $_FILES);
if ($response['success']) {
    $appId = $response['data']['application_id'];
    echo "Application submitted: " . $appId;
}

// 2. Generate sequential Employee ID
$idRes = $client->generateEmployeeId('CSE', 'FAC');
$empId = $idRes['data']['employee_id']; // e.g. FAC-CSE-2026-0001

// 3. Mark candidate documents verified
$client->verifyDocuments($appId, [
    'aadhaar_verified' => true,
    'pan_verified' => true,
    'bank_verified' => true,
    'experience_verified' => true,
    'qualification_verified' => true
]);
?>
```

---

## 🛠️ How to Modify & Adapt for Other Roles

This onboarding architecture was built cleanly so you can perfect it and apply the exact same pattern to other roles across your institution:

1. **Non-Teaching & Administrative Staff**:
   - Change ID prefix to `STF` (e.g. `STF-ADMIN-2026-0001`).
   - Call `$client->generateEmployeeId('ADMIN', 'STF')`.
2. **Research Scholars & Postdocs**:
   - Change ID prefix to `RES` (e.g. `RES-PHYS-2026-0001`).
3. **Adding Custom Fields & Uploads**:
   - Add fields in `backend/faculty_onboarding/models.py`.
   - Run `python manage.py makemigrations && python manage.py migrate`.
   - Add the input/upload field in `php_portal/index.php` or `frontend/src/components/FacultyOnboardingPortal.jsx`.


---

# 🚪 Faculty Offboarding & Exit Management System

The **Faculty Offboarding** module manages the complete lifecycle of faculty departures, from resignation submission to no-dues clearances, final settlement, and relieving letter generation.

### 📋 The 6 Offboarding Modules (Fields & Upload Actions)

| # | Stage | Input Fields | Document Upload Buttons | Clearance & Workflow Processing |
|---|---|---|---|---|
| **1** | **Resignation Submission** | Employee ID, Faculty Name, Department, Designation, Resignation Date, Requested Last Working Date, Reason, Remarks, Forwarded Authority | `📄 Choose Resignation Letter` (PDF/Img)<br>`📑 Choose Acceptance Order` (PDF) | Management approval tracking & formal notification |
| **2** | **Notice-Period Monitoring** | Required Notice Days (30-90), Notice Commencement Date, Notice End Date, Notice Shortfall Days, Waiver Type, Buyout Penalty Amount | `📜 Choose Waiver Memo` (PDF)<br>`📝 Choose Undertaking` (PDF) | Live notice countdown calculation (`remaining_notice_days`) & penalty audit |
| **3** | **Department Clearance** | Coursework Handover, Semester Internal Marks Submitted, Student Mentorship Reallocated, Committee Handover, HOD Sign-off | `📚 Choose Handover Sheet` (PDF)<br>`🏛️ Choose Dept NOC` (PDF) | HOD digital sign-off (`dept_cleared`) |
| **4** | **Library, Laboratory & Asset Clearance** | Books Returned Count, Library Dues Amount, Lab Apparatus Returned, Laptop/PC Asset Tag Surrendered, Smart ID RFID Card Surrendered, Cabin Keys Returned | `📖 Choose Library NOC` (PDF)<br>`🔬 Choose Lab Sign-off` (PDF)<br>`💻 Choose Surrender Receipt` (PDF) | Multi-department clearance matrix (`library_cleared`, `lab_cleared`, `assets_cleared`) |
| **5** | **Final Settlement (Full & Final - F&F)** | Current Month Pending Salary, Earned Leave (EL) Balance Days, EL Encashment Amount, Gratuity Amount, PF Status, Deductions/Recoveries, Net Payable Amount, Bank UTR Reference | `📊 Choose F&F Statement` (PDF)<br>`💳 Choose Disbursement Voucher` (PDF) | Finance officer auditing & bank disbursement tracking |
| **6** | **Relieving and Experience Letters** | Relieving Letter Ref No, Experience Certificate Ref No, Issue Date, Conduct & Character Assessment (Outstanding/Excellent), Total Tenure Served, Authorized Signatory | `📜 Choose Signed Relieving Letter` (PDF)<br>`🎖️ Choose Experience Cert` (PDF) | Official release order generation & formal status transition to `RELIEVED` |

---

### 🔌 PHP Offboarding Integration Snippets

You can manage faculty departures from your larger PHP project using `FacultyOnboardingClient.php`:

```php
<?php
require_once __DIR__ . '/php_portal/FacultyOnboardingClient.php';

$client = new FacultyOnboardingClient();

// 1. Submit Resignation
$res = $client->submitOffboarding($_POST, $_FILES);
$exitId = $res['data']['exit_id'];

// 2. Approve Clearances (HOD, Library, Lab, IT Assets)
$client->updateClearances($exitId, [
    'dept_cleared' => true,
    'library_cleared' => true,
    'lab_cleared' => true,
    'assets_cleared' => true
]);

// 3. Disburse Full & Final Settlement
$client->updateSettlement($exitId, [
    'settlement_status' => 'DISBURSED',
    'disbursement_ref_no' => 'NEFT-AXIS-20261114-0012'
]);

// 4. Issue Official Relieving & Experience Letters
$client->issueRelievingLetters($exitId, [
    'conduct_and_character' => 'Outstanding',
    'total_tenure_served' => '4 Years, 2 Months'
]);
?>
```
