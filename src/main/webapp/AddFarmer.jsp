<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    String username = (String) session.getAttribute("username");
    String role     = (String) session.getAttribute("role");
    if(username == null || !"ADMIN".equals(role)){
        response.sendRedirect("Login.jsp");
        return;
    }
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    session.removeAttribute("successMsg");
    session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Add Farmer</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0f1f3d;--navy2:#0d2a6b;--blue:#2563eb;--blue-lt:#eff6ff;
    --sidebar:260px;--text:#0f1f3d;--muted:#6b7a99;
    --border:#e8edf6;--bg:#f4f7fe;--white:#ffffff;--radius:12px;
    --green:#16a34a;--red:#dc2626;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}

.sidebar{width:var(--sidebar);height:100vh;overflow:hidden;background:linear-gradient(175deg,#0d1f45 0%,#0f2a6b 55%,#102f80 100%);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;}
.sidebar::before{content:'';position:absolute;width:300px;height:300px;background:radial-gradient(circle,rgba(37,99,235,0.28) 0%,transparent 70%);top:-80px;right:-80px;border-radius:50%;pointer-events:none;}
.sidebar-brand{padding:26px 24px 18px;border-bottom:1px solid rgba(255,255,255,0.08);flex-shrink:0;}
.sidebar-brand h1{font-family:'DM Serif Display',serif;font-size:24px;color:#fff;letter-spacing:-0.3px;}
.sidebar-brand h1 span{color:#60a5fa;}
.sidebar-brand p{margin-top:4px;font-size:10px;color:#4d6ea8;letter-spacing:0.6px;text-transform:uppercase;}
.sidebar-user{padding:14px 24px;border-bottom:1px solid rgba(255,255,255,0.08);flex-shrink:0;display:flex;align-items:center;gap:12px;}
.sidebar-user .avatar{width:36px;height:36px;background:rgba(37,99,235,0.35);border:1px solid rgba(37,99,235,0.5);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:15px;color:#fff;font-weight:600;flex-shrink:0;}
.sidebar-user .uname{font-size:13px;font-weight:600;color:#e2e8f0;}
.sidebar-user .urole{font-size:10px;color:#4d6ea8;margin-top:2px;text-transform:uppercase;letter-spacing:0.5px;}
.sidebar-nav{flex:1;min-height:0;display:flex;flex-direction:column;gap:3px;padding:12px;overflow-y:auto;overflow-x:hidden;}
.sidebar-nav::-webkit-scrollbar{width:4px;}
.sidebar-nav::-webkit-scrollbar-track{background:transparent;}
.sidebar-nav::-webkit-scrollbar-thumb{background:#3b82f6;border-radius:10px;}
.nav-label{font-size:9px;color:#2d4a70;text-transform:uppercase;letter-spacing:1px;padding:8px 10px 3px;font-weight:700;}
.nav-item{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:8px;text-decoration:none;color:#7ca0d4;font-size:13px;font-weight:500;transition:background .18s,color .18s;}
.nav-item:hover{background:rgba(37,99,235,0.2);color:#e2e8f0;}
.nav-item.active{background:rgba(37,99,235,0.3);color:#fff;border:1px solid rgba(37,99,235,0.4);}
.nav-item i{font-size:17px;flex-shrink:0;}
.sidebar-footer{padding:16px 24px;border-top:1px solid rgba(255,255,255,0.08);flex-shrink:0;}
.logout-btn{display:flex;align-items:center;gap:8px;width:100%;padding:9px 12px;background:rgba(220,38,38,0.15);border:1px solid rgba(220,38,38,0.3);border-radius:8px;color:#fca5a5;font-size:13px;font-weight:500;font-family:'DM Sans',sans-serif;text-decoration:none;cursor:pointer;transition:background .18s,color .18s;}
.logout-btn:hover{background:rgba(220,38,38,0.28);color:#fff;}
.logout-btn i{font-size:17px;}

.main{margin-left:var(--sidebar);flex:1;min-height:100vh;display:flex;flex-direction:column;}
.topbar{background:var(--white);border-bottom:1px solid var(--border);padding:0 32px;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.topbar-left h2{font-family:'DM Serif Display',serif;font-size:20px;color:var(--navy);}
.topbar-left p{font-size:12px;color:var(--muted);margin-top:1px;}
.topbar-right{display:flex;align-items:center;gap:10px;}
.topbar-date{font-size:12px;color:var(--muted);background:var(--bg);padding:6px 14px;border-radius:20px;border:1px solid var(--border);}
.breadcrumb{display:flex;align-items:center;gap:6px;font-size:12px;color:var(--muted);padding:14px 32px 0;}
.breadcrumb a{color:var(--blue);text-decoration:none;}
.breadcrumb a:hover{text-decoration:underline;}
.breadcrumb i{font-size:12px;}

.content{padding:20px 32px 32px;flex:1;}
.alert{display:flex;align-items:center;gap:12px;padding:14px 18px;border-radius:10px;font-size:14px;font-weight:500;margin-bottom:22px;animation:slideDown .3s ease;}
@keyframes slideDown{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
.alert-success{background:#f0fdf4;border:1px solid #bbf7d0;color:#15803d;}
.alert-error{background:#fef2f2;border:1px solid #fecaca;color:#dc2626;}
.alert i{font-size:20px;}

.form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
.form-card-header{padding:22px 28px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:14px;background:linear-gradient(90deg,#f8faff 0%,var(--white) 100%);}
.form-card-header .hicon{width:44px;height:44px;background:var(--blue-lt);border:1px solid #bfdbfe;border-radius:10px;display:flex;align-items:center;justify-content:center;color:var(--blue);}
.form-card-header .hicon i{font-size:24px;}
.form-card-header h3{font-family:'DM Serif Display',serif;font-size:18px;color:var(--navy);}
.form-card-header p{font-size:12px;color:var(--muted);margin-top:2px;}

.form-body{padding:28px;}
.form-section{margin-bottom:28px;}
.form-section-title{font-size:11px;font-weight:600;color:var(--blue);text-transform:uppercase;letter-spacing:1px;margin-bottom:16px;padding-bottom:8px;border-bottom:2px solid var(--blue-lt);display:flex;align-items:center;gap:8px;}
.form-section-title i{font-size:16px;}
.form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px 24px;}
.form-grid.cols-3{grid-template-columns:1fr 1fr 1fr;}
.col-span-2{grid-column:span 2;}

.field{display:flex;flex-direction:column;gap:6px;}
.field label{font-size:12px;font-weight:600;color:var(--navy);letter-spacing:0.03em;}
.field label .req{color:var(--red);margin-left:2px;}
.field input,.field select,.field textarea{padding:10px 14px;border:1.5px solid var(--border);border-radius:9px;font-size:14px;font-family:'DM Sans',sans-serif;color:var(--text);background:#fafbff;outline:none;transition:border-color .2s,box-shadow .2s;width:100%;}
.field input::placeholder,.field textarea::placeholder{color:#b0bcd4;}
.field input:focus,.field select:focus,.field textarea:focus{border-color:var(--blue);box-shadow:0 0 0 3px rgba(37,99,235,0.10);background:var(--white);}
.field textarea{resize:vertical;min-height:80px;}
.input-wrap{position:relative;}
.input-wrap .prefix{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:13px;color:var(--muted);pointer-events:none;}
.input-wrap input{padding-left:36px;}

.form-footer{padding:20px 28px;border-top:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;background:#fafbff;}
.form-footer .hint{font-size:12px;color:var(--muted);}
.btn-group{display:flex;gap:12px;}
.btn{padding:10px 24px;border-radius:9px;font-size:14px;font-weight:500;font-family:'DM Sans',sans-serif;cursor:pointer;transition:all .18s;border:1.5px solid transparent;text-decoration:none;display:inline-flex;align-items:center;gap:8px;}
.btn i{font-size:17px;}
.btn-primary{background:var(--navy);color:#fff;border-color:var(--navy);}
.btn-primary:hover{background:#0d2a6b;border-color:#0d2a6b;}
.btn-primary:active{transform:scale(0.98);}
.btn-outline{background:var(--white);color:var(--muted);border-color:var(--border);}
.btn-outline:hover{border-color:#b0bcd4;color:var(--text);}

.main-footer{padding:16px 32px;border-top:1px solid var(--border);font-size:12px;color:var(--muted);background:var(--white);display:flex;justify-content:space-between;}
</style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-brand">
        <h1>Milk<span>Mitra</span></h1>
        <p>Admin Portal</p>
    </div>
    <div class="sidebar-user">
        <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
        <div>
            <div class="uname"><%= username %></div>
            <div class="urole"><%= role %></div>
        </div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Menu</div>
        <a href="AdminDashboard.jsp" class="nav-item"><i class="ti ti-home"></i>Dashboard</a>
        <div class="nav-label">Farmer Management</div>
        <a href="AddFarmer.jsp" class="nav-item active"><i class="ti ti-user-plus"></i>Add Farmers</a>
        <a href="FarmerListServlet" class="nav-item"><i class="ti ti-users"></i>View Farmers</a>
        <a href="UpdateFarmer.jsp" class="nav-item"><i class="ti ti-user-edit"></i>Update Farmers</a>
        <a href="DeactivateFarmer.jsp" class="nav-item"><i class="ti ti-user-off"></i>Deactivate Farmers</a>
        <div class="nav-label">Operations</div>
        <a href="milk/milkList.jsp" class="nav-item"><i class="ti ti-droplet"></i>Milk Collection</a>
        <a href="payment/paymentList.jsp" class="nav-item"><i class="ti ti-cash"></i>Payments</a>
        <a href="inventory/inventoryList.jsp" class="nav-item"><i class="ti ti-box"></i>Inventory</a>
        <a href="feed/feedList.jsp" class="nav-item"><i class="ti ti-leaf"></i>Feed Orders</a>
        <a href="price/priceList.jsp" class="nav-item"><i class="ti ti-tag"></i>Milk Prices</a>
        <a href="reports/reports.jsp" class="nav-item"><i class="ti ti-chart-bar"></i>Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="Logout" class="logout-btn"><i class="ti ti-logout"></i>Logout</a>
    </div>
</aside>

<div class="main">
    <div class="topbar">
        <div class="topbar-left">
            <h2>Add Farmer</h2>
            <p>Register a new farmer to MilkMitra</p>
        </div>
        <div class="topbar-right">
            <div class="topbar-date" id="dateStr"></div>
        </div>
    </div>

    <div class="breadcrumb">
        <a href="AdminDashboard.jsp">Dashboard</a>
        <i class="ti ti-chevron-right"></i>
        <span>Add Farmer</span>
    </div>

    <div class="content">
        <% if(successMsg != null){ %>
        <div class="alert alert-success"><i class="ti ti-circle-check"></i><%= successMsg %></div>
        <% } %>
        <% if(errorMsg != null){ %>
        <div class="alert alert-error"><i class="ti ti-alert-circle"></i><%= errorMsg %></div>
        <% } %>

        <div class="form-card">
            <div class="form-card-header">
                <div class="hicon"><i class="ti ti-user-plus"></i></div>
                <div>
                    <h3>New Farmer Registration</h3>
                    <p>Fill in the details below. Fields marked <span style="color:var(--red)">*</span> are required.</p>
                </div>
            </div>

            <form action="AddFarmerServlet" method="post">
            <div class="form-body">
                <div class="form-section">
                    <div class="form-section-title"><i class="ti ti-user"></i>Basic Information</div>
                    <div class="form-grid">
                        <div class="field">
                            <label>Farmer Name <span class="req">*</span></label>
                            <input type="text" name="farmerName" placeholder="e.g. Ramesh Ghosh" required/>
                        </div>
                        <div class="field">
                            <label>Mobile Number <span class="req">*</span></label>
                            <div class="input-wrap">
                                <span class="prefix">+91</span>
                                <input type="tel" name="mobile" placeholder="9876543210" maxlength="10" required/>
                            </div>
                        </div>
                        <div class="field">
                            <label>Email Address</label>
                            <input type="email" name="email" placeholder="farmer@example.com"/>
                        </div>
                        <div class="field">
                            <label>Aadhaar Number <span class="req">*</span></label>
                            <input type="text" name="andharNo" placeholder="XXXX XXXX XXXX" maxlength="12" required/>
                        </div>
                        <div class="field col-span-2">
                            <label>Address <span class="req">*</span></label>
                            <textarea name="address" placeholder="Village, Taluka, District, State..." required></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="form-section-title"><i class="ti ti-building-bank"></i>Bank Details</div>
                    <div class="form-grid">
                        <div class="field">
                            <label>Account Holder Name <span class="req">*</span></label>
                            <input type="text" name="accountHolderName" placeholder="As per bank records" required/>
                        </div>
                        <div class="field">
                            <label>Bank Account Number <span class="req">*</span></label>
                            <input type="text" name="bankAccountNo" placeholder="e.g. 012345678901" required/>
                        </div>
                        <div class="field">
                            <label>IFSC Code <span class="req">*</span></label>
                            <input type="text" name="ifscCode" placeholder="e.g. SBIN0001234" style="text-transform:uppercase" maxlength="11" required/>
                        </div>
                        <div class="field">
                            <label>Bank Name <span class="req">*</span></label>
                            <input type="text" name="bankName" placeholder="e.g. State Bank of India" required/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-footer">
                <span class="hint">Farmer Code will be auto-generated after submission.</span>
                <div class="btn-group">
                    <a href="AddFarmer.jsp" class="btn btn-outline"><i class="ti ti-x"></i>Cancel</a>
                    <button type="submit" class="btn btn-primary"><i class="ti ti-user-plus"></i>Add Farmer</button>
                </div>
            </div>
            </form>
        </div>
    </div>

    <div class="main-footer">
        <span>© 2026 MilkMitra. All Rights Reserved.</span>
        <span>Logged in as <strong><%= username %></strong> · <%= role %></span>
    </div>
</div>

<script>
var d = new Date();
document.getElementById('dateStr').textContent = d.toLocaleDateString('en-IN',{weekday:'short',year:'numeric',month:'short',day:'numeric'});
document.querySelector('input[name="ifscCode"]').addEventListener('input',function(){this.value=this.value.toUpperCase();});
</script>
</body>
</html>
