<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.milkmitra.model.Farmer" %>
<%
Farmer farmer = (Farmer) request.getAttribute("farmer");
if(farmer == null) {
    response.sendRedirect("FarmerListServlet");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Farmer Profile | MilkMitra</title>

<style>
:root {
    --bg-primary: #f8fafc;
    --card-bg: #ffffff;
    --text-main: #0f172a;
    --text-muted: #64748b;
    --primary: #2563eb;
    --primary-hover: #1d4ed8;
    --primary-light: #eff6ff;
    --border-color: #f1f5f9;
    --success: #10b981;
    --success-bg: #ecfdf5;
    --danger: #ef4444;
    --danger-bg: #fef2f2;
}

*{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
}

body{
    background: linear-gradient(135deg, #f1f5f9 0%, #f8fafc 100%);
    color: var(--text-main);
    min-height: 100vh;
    padding: 40px 20px;
}

.container{
    max-width: 1100px;
    margin: auto;
}

/* Header Action Layout */
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

.page-title {
    font-size: 28px;
    font-weight: 700;
    color: var(--text-main);
    letter-spacing: -0.5px;
}

.action-bar {
    display: flex;
    gap: 12px;
}

/* Main Dashboard Split Layout */
.profile-grid {
    display: grid;
    grid-template-columns: 320px 1fr;
    gap: 30px;
}

@media (max-width: 900px) {
    .profile-grid {
        grid-template-columns: 1fr;
    }
    .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
}

.card {
    background: var(--card-bg);
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
    border: 1px solid rgba(241, 245, 249, 0.8);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02);
}

.card-title-wrapper {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    padding-bottom: 12px;
    border-bottom: 2px solid var(--border-color);
}

.card h3 {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-main);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.card-icon {
    width: 20px;
    height: 20px;
    color: var(--primary);
}

/* Grid for fields */
.fields-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 20px;
}

.field {
    padding: 6px 0;
}

.label {
    font-size: 12px;
    font-weight: 600;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 6px;
}

.value {
    font-size: 16px;
    font-weight: 500;
    color: var(--text-main);
    word-break: break-word;
}

/* Left Sidebar Summary Card */
.summary-card {
    text-align: center;
    background: var(--card-bg);
}

.avatar-placeholder {
    width: 80px;
    height: 80px;
    background: var(--primary-light);
    color: var(--primary);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 32px;
    font-weight: 700;
    margin: 0 auto 16px auto;
}

.summary-name {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 4px;
}

.summary-code {
    font-size: 14px;
    color: var(--text-muted);
    margin-bottom: 16px;
}

/* Badges */
.status-badge {
    display: inline-flex;
    align-items: center;
    padding: 6px 16px;
    border-radius: 30px;
    font-size: 13px;
    font-weight: 600;
}

.status-active {
    background: var(--success-bg);
    color: var(--success);
}

.status-inactive {
    background: var(--danger-bg);
    color: var(--danger);
}

/* Interactive Utility Style (Secure ID Display) */
.secure-wrapper {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: var(--bg-primary);
    padding: 10px 14px;
    border-radius: 8px;
    border: 1px solid var(--border-color);
}

.toggle-btn {
    background: none;
    border: none;
    color: var(--primary);
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
}

/* Buttons */
.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s ease;
    cursor: pointer;
}

.btn-secondary {
    background: var(--card-bg);
    color: var(--text-muted);
    border: 1px solid #cbd5e1;
}

.btn-secondary:hover {
    background: #f1f5f9;
    color: var(--text-main);
}

.btn-primary {
    background: var(--primary);
    color: white;
    border: 1px solid var(--primary);
    box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
}

.btn-primary:hover {
    background: var(--primary-hover);
    box-shadow: 0 4px 6px rgba(37, 99, 235, 0.3);
}
</style>
</head>
<body>

<div class="container">

    <div class="page-header">
        <div class="page-title">Farmer Profile</div>
        <div class="action-bar">
            <a href="FarmerListServlet" class="btn btn-secondary">
                <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
                Back to List
            </a>
            <a href="LoadEditFarmerServlet?farmerCode=<%= farmer.getFarmerCode() %>" class="btn btn-primary">
                <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="color:white;"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                Update Profile
            </a>
        </div>
    </div>

    <div class="profile-grid">
        
        <div class="left-column">
            <div class="card summary-card">
                <div class="avatar-placeholder">
                    <%= farmer.getFarmerName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="summary-name"><%= farmer.getFarmerName() %></div>
                <div class="summary-code">ID: <%= farmer.getFarmerCode() %></div>
                
                <div class="status-badge <%= farmer.isActive() ? "status-active" : "status-inactive" %>">
                    <%= farmer.isActive() ? "Active Status" : "Inactive Status" %>
                </div>
            </div>
            
            <div class="card">
                <div class="card-title-wrapper">
                    <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 014 0m-4 0a2 2 0 004 0"></path></svg>
                    <h3>Identity Verification</h3>
                </div>
                <div class="field">
                    <div class="label">Aadhaar Number</div>
                    <div class="secure-wrapper">
                        <div class="value" id="aadhaarDisplay" data-raw="<%= farmer.getAndharNo() %>"></div>
                        <button type="button" class="toggle-btn" onclick="toggleMask()">Show</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="right-column">
            
            <div class="card">
                <div class="card-title-wrapper">
                    <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    <h3>Registration Details</h3>
                </div>
                <div class="fields-grid">
                    <div class="field">
                        <div class="label">Mobile Number</div>
                        <div class="value"><%= farmer.getMobile() %></div>
                    </div>
                    <div class="field">
                        <div class="label">Joining Date</div>
                        <div class="value"><%= farmer.getJoiningDate() %></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-title-wrapper">
                    <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg>
                    <h3>Contact Information</h3>
                </div>
                <div class="fields-grid">
                    <div class="field">
                        <div class="label">Email Address</div>
                        <div class="value"><%= (farmer.getEmail() != null && !farmer.getEmail().isEmpty()) ? farmer.getEmail() : "N/A" %></div>
                    </div>
                    <div class="field" style="grid-column: span 1;">
                        <div class="label">Residential Address</div>
                        <div class="value"><%= farmer.getAddress() %></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-title-wrapper">
                    <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
                    <h3>Bank Account Information</h3>
                </div>
                <div class="fields-grid">
                    <div class="field">
                        <div class="label">Account Holder</div>
                        <div class="value"><%= farmer.getAccountHolderName() %></div>
                    </div>
                    <div class="field">
                        <div class="label">Bank Name</div>
                        <div class="value"><%= farmer.getBankName() %></div>
                    </div>
                    <div class="field">
                        <div class="label">Account Number</div>
                        <div class="value"><%= farmer.getAccountNo() %></div>
                    </div>
                    <div class="field">
                        <div class="label">IFSC Code</div>
                        <div class="value" style="text-transform: uppercase;"><%= farmer.getIfscCode() %></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
// Masking utility for ID privacy
const targetEl = document.getElementById('aadhaarDisplay');
const rawVal = targetEl.getAttribute('data-raw').trim();

function getMaskedValue(str) {
    if(str.length >= 4) {
        return '•••• •••• ' + str.slice(-4);
    }
    return str;
}

// Initial state
targetEl.textContent = getMaskedValue(rawVal);
let isHidden = true;

function toggleMask() {
    const btn = event.target;
    if(isHidden) {
        targetEl.textContent = rawVal;
        btn.textContent = 'Hide';
    } else {
        targetEl.textContent = getMaskedValue(rawVal);
        btn.textContent = 'Show';
    }
    isHidden = !isHidden;
}
</script>

</body>
</html>