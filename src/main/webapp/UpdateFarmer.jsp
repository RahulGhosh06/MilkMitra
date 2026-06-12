<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.milkmitra.model.Farmer" %>
<%
Farmer farmer = (Farmer) request.getAttribute("farmer");
if(farmer == null){
    response.sendRedirect("FarmerListServlet");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Edit Farmer</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0f1f3d;--blue:#2563eb;--blue-lt:#eff6ff;
    --green:#16a34a;--green-lt:#f0fdf4;
    --text:#0f1f3d;--muted:#6b7a99;
    --border:#e8edf6;--bg:#f4f7fe;--white:#fff;--radius:12px;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:flex-start;justify-content:center;padding:40px 20px;}
.wrap{width:100%;max-width:760px;}

.ef-header{display:flex;align-items:center;gap:16px;margin-bottom:24px;}
.ef-avatar{width:52px;height:52px;border-radius:50%;background:var(--blue-lt);border:1px solid #bfdbfe;display:flex;align-items:center;justify-content:center;color:var(--blue);font-size:17px;font-weight:700;flex-shrink:0;}
.ef-name{font-size:20px;font-weight:700;color:var(--navy);margin:0 0 3px;}
.ef-meta{font-size:12px;color:var(--muted);margin:0;display:flex;align-items:center;gap:5px;}
.ef-meta i{font-size:14px;}

.form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;margin-bottom:14px;}
.sec-lbl{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.7px;color:var(--muted);padding:9px 20px 8px;background:#f8fafd;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:7px;}
.sec-lbl i{font-size:15px;}

.fields{display:grid;grid-template-columns:1fr 1fr;}
.field{padding:14px 20px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);}
.field:nth-child(2n){border-right:none;}
.field.full{grid-column:1/-1;border-right:none;}

.field label{display:flex;align-items:center;gap:5px;font-size:11px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.4px;margin-bottom:7px;}
.field label i{font-size:13px;}

.field input[type=text],
.field input[type=email],
.field textarea{
    width:100%;background:transparent;border:none;outline:none;
    font-size:14px;font-weight:600;color:var(--navy);
    font-family:'DM Sans',sans-serif;padding:0;resize:none;
}
.field input::placeholder,
.field textarea::placeholder{color:#c4cdd8;font-weight:400;}
.field input[readonly]{color:var(--muted);}
.ro-wrap{display:flex;align-items:center;gap:7px;}
.ro-wrap i{font-size:13px;color:#c4cdd8;flex-shrink:0;}

.actions{display:flex;gap:10px;padding-top:4px;}
.btn-save{flex:1;padding:12px;background:var(--navy);color:#fff;border:none;border-radius:10px;font-size:14px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:background .18s;}
.btn-save:hover{background:#1e3a6b;}
.btn-save i{font-size:17px;}
.btn-back{padding:12px 20px;background:var(--white);color:var(--muted);border:1px solid var(--border);border-radius:10px;font-size:14px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;text-decoration:none;transition:background .18s;}
.btn-back:hover{background:var(--bg);}
.btn-back i{font-size:17px;}
</style>
</head>
<body>
<div class="wrap">

    <!-- Header -->
    <div class="ef-header">
        <div class="ef-avatar"><%= farmer.getFarmerName() != null && farmer.getFarmerName().length() > 0 ? farmer.getFarmerName().substring(0,1).toUpperCase() : "F" %></div>
        <div>
            <p class="ef-name"><%= farmer.getFarmerName() %></p>
            <p class="ef-meta"><i class="ti ti-hash"></i><%= farmer.getFarmerCode() %> &nbsp;·&nbsp; Edit farmer profile</p>
        </div>
    </div>

    <form action="EditFarmerServlet" method="post">
        <input type="hidden" name="farmerCode" value="<%= farmer.getFarmerCode() %>">

        <!-- Personal Information -->
        <div class="form-card">
            <div class="sec-lbl"><i class="ti ti-user"></i>Personal information</div>
            <div class="fields">
                <div class="field">
                    <label><i class="ti ti-hash"></i>Farmer code</label>
                    <div class="ro-wrap">
                        <input type="text" value="<%= farmer.getFarmerCode() %>" readonly>
                        <i class="ti ti-lock"></i>
                    </div>
                </div>
                <div class="field">
                    <label><i class="ti ti-user"></i>Full name</label>
                    <input type="text" name="farmerName" value="<%= farmer.getFarmerName() %>" placeholder="Farmer name">
                </div>
                <div class="field">
                    <label><i class="ti ti-phone"></i>Mobile</label>
                    <input type="text" name="mobile" value="<%= farmer.getMobile() %>" placeholder="10-digit number">
                </div>
                <div class="field">
                    <label><i class="ti ti-mail"></i>Email</label>
                    <input type="email" name="email" value="<%= farmer.getEmail() %>" placeholder="email@example.com">
                </div>
                <div class="field full">
                    <label><i class="ti ti-map-pin"></i>Address</label>
                    <textarea name="address" rows="2" placeholder="Full address"><%= farmer.getAddress() %></textarea>
                </div>
            </div>
        </div>

        <!-- Bank Details -->
        <div class="form-card">
            <div class="sec-lbl"><i class="ti ti-building-bank"></i>Bank details</div>
            <div class="fields">
                <div class="field">
                    <label><i class="ti ti-user-circle"></i>Account holder name</label>
                    <input type="text" name="accountHolderName" value="<%= farmer.getAccountHolderName() %>" placeholder="As per bank records">
                </div>
                <div class="field">
                    <label><i class="ti ti-credit-card"></i>Account number</label>
                    <input type="text" name="bankAccountNo" value="<%= farmer.getAccountNo() %>" placeholder="Account number">
                </div>
                <div class="field">
                    <label><i class="ti ti-building"></i>Bank name</label>
                    <input type="text" name="bankName" value="<%= farmer.getBankName() %>" placeholder="Bank name">
                </div>
                <div class="field">
                    <label><i class="ti ti-code"></i>IFSC code</label>
                    <input type="text" name="ifscCode" value="<%= farmer.getIfscCode() %>" placeholder="e.g. SBIN0001234">
                </div>
            </div>
        </div>

        <!-- Identity -->
        <div class="form-card">
            <div class="sec-lbl"><i class="ti ti-id-badge"></i>Identity</div>
            <div class="fields">
                <div class="field full">
                    <label><i class="ti ti-fingerprint"></i>Aadhaar number</label>
                    <input type="text" name="andharNo" value="<%= farmer.getAndharNo() %>" placeholder="12-digit Aadhaar">
                </div>
            </div>
        </div>

        <div class="actions">
            <a href="FarmerListServlet" class="btn-back"><i class="ti ti-arrow-left"></i>Back</a>
            <button type="submit" class="btn-save"><i class="ti ti-device-floppy"></i>Save changes</button>
        </div>
    </form>

</div>
</body>
</html>
