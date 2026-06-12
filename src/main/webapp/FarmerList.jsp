<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.milkmitra.model.Farmer" %>
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

    List<Farmer> farmers = (List<Farmer>) request.getAttribute("farmers");
    String errorMsg      = (String) request.getAttribute("errorMsg");
    String successMsg    = (String) request.getAttribute("successMsg");
    int total = (farmers != null) ? farmers.size() : 0;

    int activeCount     = (request.getAttribute("activeCount")     != null) ? (Integer) request.getAttribute("activeCount")     : 0;
    int inactiveCount   = (request.getAttribute("inactiveCount")   != null) ? (Integer) request.getAttribute("inactiveCount")   : 0;
    int joinedThisMonth = (request.getAttribute("joinedThisMonth") != null) ? (Integer) request.getAttribute("joinedThisMonth") : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | View Farmers</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=DM+Serif+Display&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0f1f3d;--blue:#2563eb;--blue-lt:#eff6ff;
    --green:#16a34a;--green-lt:#f0fdf4;
    --red:#dc2626;--red-lt:#fef2f2;
    --amber:#d97706;--amber-lt:#fffbeb;
    --muted:#6b7a99;--border:#e2e8f0;--bg:#f4f7fe;
    --white:#ffffff;--radius:12px;--sidebar:260px;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--navy);display:flex;min-height:100vh;font-size:14px;}

/* ── SIDEBAR ── */
.sidebar{width:var(--sidebar);height:100vh;background:linear-gradient(175deg,#0d1f45 0%,#0f2a6b 55%,#102f80 100%);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;}
.sb-brand{padding:26px 24px 18px;border-bottom:1px solid rgba(255,255,255,0.08);}
.sb-brand h1{font-family:'DM Serif Display',serif;font-size:24px;color:#fff;}
.sb-brand h1 span{color:#60a5fa;}
.sb-brand p{font-size:10px;color:#4d6ea8;text-transform:uppercase;letter-spacing:0.6px;margin-top:3px;}
.sb-user{padding:14px 24px;border-bottom:1px solid rgba(255,255,255,0.08);display:flex;align-items:center;gap:12px;}
.sb-av{width:36px;height:36px;background:rgba(37,99,235,0.35);border:1px solid rgba(37,99,235,0.5);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:15px;color:#fff;font-weight:600;flex-shrink:0;}
.sb-un{font-size:13px;font-weight:600;color:#e2e8f0;}
.sb-ur{font-size:10px;color:#4d6ea8;text-transform:uppercase;letter-spacing:0.5px;}
.sb-nav{flex:1;padding:12px;display:flex;flex-direction:column;gap:3px;overflow-y:auto;}
.sb-nav::-webkit-scrollbar{width:4px;}
.sb-nav::-webkit-scrollbar-thumb{background:#3b82f6;border-radius:10px;}
.nl{font-size:9px;color:#2d4a70;text-transform:uppercase;letter-spacing:1px;padding:8px 10px 3px;font-weight:700;}
.ni{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:8px;color:#7ca0d4;font-size:13px;font-weight:500;text-decoration:none;transition:background .15s,color .15s;}
.ni:hover{background:rgba(37,99,235,0.18);color:#e2e8f0;}
.ni.active{background:rgba(37,99,235,0.28);color:#fff;border:1px solid rgba(37,99,235,0.4);}
.ni i{font-size:17px;flex-shrink:0;}
.sb-foot{padding:16px 24px;border-top:1px solid rgba(255,255,255,0.08);}
.lo-btn{display:flex;align-items:center;gap:8px;padding:9px 12px;background:rgba(220,38,38,0.14);border:1px solid rgba(220,38,38,0.28);border-radius:8px;color:#fca5a5;font-size:13px;text-decoration:none;transition:background .15s;}
.lo-btn:hover{background:rgba(220,38,38,0.26);color:#fff;}
.lo-btn i{font-size:17px;}

/* ── MAIN ── */
.main{margin-left:var(--sidebar);flex:1;display:flex;flex-direction:column;min-height:100vh;}
.topbar{background:#fff;border-bottom:1px solid var(--border);padding:0 28px;height:60px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.tb-l h2{font-family:'DM Serif Display',serif;font-size:18px;color:var(--navy);}
.tb-l p{font-size:11px;color:var(--muted);margin-top:1px;}
.tb-date{font-size:11px;color:var(--muted);background:var(--bg);padding:5px 14px;border-radius:20px;border:1px solid var(--border);}
.content{padding:24px 28px;flex:1;display:flex;flex-direction:column;gap:18px;}

/* ── BREADCRUMB ── */
.bc{display:flex;align-items:center;gap:7px;font-size:12px;color:var(--muted);}
.bc a{color:var(--blue);text-decoration:none;}
.bc a:hover{text-decoration:underline;}
.bc i{font-size:12px;}

/* ── ALERTS ── */
.alert-err{background:#fef2f2;border:1px solid #fecaca;color:#dc2626;padding:12px 16px;border-radius:var(--radius);font-size:13px;display:flex;align-items:center;gap:8px;}
.alert-success{background:#f0fdf4;border:1px solid #bbf7d0;color:#15803d;padding:12px 16px;border-radius:var(--radius);font-size:13px;display:flex;align-items:center;gap:8px;}

/* ── STATS ── */
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;}
.sc{background:#fff;border-radius:var(--radius);padding:16px 18px;border:1px solid var(--border);display:flex;align-items:center;gap:12px;transition:transform .15s,box-shadow .15s;}
.sc:hover{transform:translateY(-2px);box-shadow:0 6px 20px rgba(37,99,235,0.08);}
.si{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.si i{font-size:22px;}
.si-b{background:#eff6ff;border:1px solid #bfdbfe;color:#2563eb;}
.si-g{background:#f0fdf4;border:1px solid #bbf7d0;color:#16a34a;}
.si-r{background:#fef2f2;border:1px solid #fecaca;color:#dc2626;}
.si-a{background:#fffbeb;border:1px solid #fde68a;color:#d97706;}
.sv{font-size:22px;font-weight:700;color:var(--navy);line-height:1;}
.sl{font-size:11px;color:var(--muted);margin-top:4px;}

/* ── TOOLBAR ── */
.toolbar{background:#fff;border:1px solid var(--border);border-radius:var(--radius);padding:14px 16px;display:flex;align-items:center;gap:12px;}
.srch-wrap{flex:1;position:relative;}
.srch-wrap i{position:absolute;left:10px;top:50%;transform:translateY(-50%);font-size:16px;color:var(--muted);}
.srch-wrap input{width:100%;border:1px solid var(--border);border-radius:8px;padding:8px 12px 8px 34px;font-size:13px;color:var(--navy);background:var(--bg);outline:none;font-family:inherit;transition:border-color .15s;}
.srch-wrap input:focus{border-color:var(--blue);}
.srch-wrap input::placeholder{color:var(--muted);}
select{border:1px solid var(--border);border-radius:8px;padding:8px 30px 8px 12px;font-size:13px;color:var(--navy);background:var(--bg) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b7a99' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E") no-repeat right 10px center;outline:none;font-family:inherit;appearance:none;cursor:pointer;transition:border-color .15s;}
select:focus{border-color:var(--blue);}
.ref-btn{display:flex;align-items:center;gap:6px;padding:8px 16px;background:var(--blue);color:#fff;border:none;border-radius:8px;font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;transition:background .15s;flex-shrink:0;text-decoration:none;}
.ref-btn:hover{background:#1d4ed8;}
.ref-btn i{font-size:16px;}

/* ── TABLE ── */
.tw{background:#fff;border-radius:var(--radius);border:1px solid var(--border);overflow:hidden;}
.tw-head{padding:13px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.tw-head h3{font-size:14px;font-weight:600;color:var(--navy);}
.tw-head span{font-size:12px;color:var(--muted);}
table{width:100%;border-collapse:collapse;}
thead th{background:#f8faff;padding:11px 16px;text-align:left;font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;border-bottom:1px solid var(--border);}
tbody tr{border-bottom:1px solid var(--border);transition:background .12s;}
tbody tr:last-child{border-bottom:none;}
tbody tr:hover{background:#f8faff;}
td{padding:11px 16px;font-size:13px;}
.fc{color:var(--blue);font-weight:600;}
.fn{font-weight:500;}
.mob,.jd{color:var(--muted);}

/* ── STATUS BADGE ── */
.status-badge{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;}
.status-badge.active{background:var(--green-lt);color:var(--green);border:1px solid #bbf7d0;}
.status-badge.inactive{background:var(--red-lt);color:var(--red);border:1px solid #fecaca;}
.status-badge i{font-size:11px;}

/* ── ACTION BUTTONS ── */
.action-wrap{display:flex;align-items:center;gap:6px;flex-wrap:wrap;}

.vbtn{display:inline-flex;align-items:center;gap:4px;padding:5px 10px;border-radius:6px;font-size:11px;font-weight:600;text-decoration:none;transition:all .15s;cursor:pointer;white-space:nowrap;}

/* View */
.vbtn-view{background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe;}
.vbtn-view:hover{background:var(--blue);color:#fff;border-color:var(--blue);}

/* Deactivate */
.vbtn-deactivate{background:#fef2f2;color:#dc2626;border:1px solid #fecaca;}
.vbtn-deactivate:hover{background:#dc2626;color:#fff;border-color:#dc2626;}

/* Reactivate */
.vbtn-reactivate{background:#f0fdf4;color:#16a34a;border:1px solid #bbf7d0;}
.vbtn-reactivate:hover{background:#16a34a;color:#fff;border-color:#16a34a;}

.vbtn i{font-size:13px;}

/* ── EMPTY ── */
.empty{text-align:center;padding:50px 20px;color:var(--muted);}
.empty i{font-size:40px;margin-bottom:12px;display:block;}

/* ── PAGINATION ── */
.pag{padding:13px 20px;display:flex;align-items:center;justify-content:space-between;border-top:1px solid var(--border);}
.pi{font-size:12px;color:var(--muted);}
.pbtns{display:flex;gap:5px;}
.pb{width:30px;height:30px;display:flex;align-items:center;justify-content:center;border:1px solid var(--border);border-radius:6px;background:#fff;color:var(--navy);font-size:12px;font-weight:500;cursor:pointer;transition:background .12s;}
.pb:hover{background:var(--bg);}
.pb.active{background:var(--blue);color:#fff;border-color:var(--blue);}
.pb i{font-size:13px;}

/* ── FOOTER ── */
.foot{padding:14px 28px;border-top:1px solid var(--border);font-size:11px;color:var(--muted);background:#fff;display:flex;justify-content:space-between;}

/* ── MODAL OVERLAY ── */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:200;align-items:center;justify-content:center;}
.modal-overlay.show{display:flex;}
.modal{background:#fff;border-radius:var(--radius);padding:28px;width:400px;box-shadow:0 20px 60px rgba(0,0,0,.2);}
.modal-icon{width:52px;height:52px;border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 16px;font-size:24px;}
.modal-icon.red{background:#fef2f2;color:#dc2626;}
.modal-icon.green{background:#f0fdf4;color:#16a34a;}
.modal h3{text-align:center;font-size:16px;font-weight:700;color:var(--navy);margin-bottom:8px;}
.modal p{text-align:center;font-size:13px;color:var(--muted);margin-bottom:24px;line-height:1.6;}
.modal p strong{color:var(--navy);}
.modal-btns{display:flex;gap:10px;}
.modal-btns a, .modal-btns button{flex:1;padding:10px;border-radius:8px;font-size:13px;font-weight:600;text-align:center;text-decoration:none;border:none;cursor:pointer;font-family:inherit;}
.btn-cancel{background:var(--bg);color:var(--navy);border:1px solid var(--border);}
.btn-cancel:hover{border-color:var(--muted);}
.btn-confirm-red{background:#dc2626;color:#fff;}
.btn-confirm-red:hover{background:#b91c1c;}
.btn-confirm-green{background:#16a34a;color:#fff;}
.btn-confirm-green:hover{background:#15803d;}
</style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sb-brand">
        <h1>Milk<span>Mitra</span></h1>
        <p>Admin Portal</p>
    </div>
    <div class="sb-user">
        <div class="sb-av"><%= username.substring(0,1).toUpperCase() %></div>
        <div>
            <div class="sb-un"><%= username %></div>
            <div class="sb-ur"><%= role %></div>
        </div>
    </div>
    <nav class="sb-nav">
        <div class="nl">Menu</div>
        <a href="AdminDashboard.jsp" class="ni"><i class="ti ti-home"></i>Dashboard</a>
        <div class="nl">Farmer Management</div>
        <a href="AddFarmer.jsp"          class="ni"><i class="ti ti-user-plus"></i>Add Farmers</a>
        <a href="FarmerListServlet"       class="ni active"><i class="ti ti-users"></i>View Farmers</a>
        <a href="UpdateFarmer.jsp"        class="ni"><i class="ti ti-user-edit"></i>Update Farmers</a>
        <div class="nl">Operations</div>
        <a href="milk/milkList.jsp"       class="ni"><i class="ti ti-droplet"></i>Milk Collection</a>
        <a href="payment/paymentList.jsp" class="ni"><i class="ti ti-cash"></i>Payments</a>
        <a href="inventory/inventoryList.jsp" class="ni"><i class="ti ti-box"></i>Inventory</a>
        <a href="reports/reports.jsp"     class="ni"><i class="ti ti-chart-bar"></i>Reports</a>
    </nav>
    <div class="sb-foot">
        <a href="Logout" class="lo-btn"><i class="ti ti-logout"></i>Logout</a>
    </div>
</aside>

<!-- MAIN -->
<div class="main">
    <div class="topbar">
        <div class="tb-l">
            <h2>View Farmers</h2>
            <p>Manage and monitor registered farmers</p>
        </div>
        <div class="tb-date" id="dateStr"></div>
    </div>

    <div class="content">

        <!-- BREADCRUMB -->
        <div class="bc">
            <a href="AdminDashboard.jsp">Dashboard</a>
            <i class="ti ti-chevron-right"></i>
            <span>Farmer Management</span>
            <i class="ti ti-chevron-right"></i>
            <span>View Farmers</span>
        </div>

        <!-- ALERTS -->
        <% if(errorMsg != null) { %>
        <div class="alert-err">
            <i class="ti ti-alert-circle"></i><%= errorMsg %>
        </div>
        <% } %>

        <% if(successMsg != null) { %>
        <div class="alert-success">
            <i class="ti ti-circle-check"></i><%= successMsg %>
        </div>
        <% } %>

        <!-- STATS -->
        <div class="stats">
            <div class="sc">
                <div class="si si-b"><i class="ti ti-users"></i></div>
                <div><div class="sv"><%= total %></div><div class="sl">All Farmers</div></div>
            </div>
            <div class="sc">
                <div class="si si-g"><i class="ti ti-user-check"></i></div>
                <div><div class="sv"><%= activeCount %></div><div class="sl">Active Farmers</div></div>
            </div>
            <div class="sc">
                <div class="si si-r"><i class="ti ti-user-x"></i></div>
                <div><div class="sv"><%= inactiveCount %></div><div class="sl">Inactive Farmers</div></div>
            </div>
            <div class="sc">
                <div class="si si-a"><i class="ti ti-calendar-stats"></i></div>
                <div><div class="sv"><%= joinedThisMonth %></div><div class="sl">Joined This Month</div></div>
            </div>
        </div>

        <!-- TOOLBAR -->
        <div class="toolbar">
            <div class="srch-wrap">
                <i class="ti ti-search"></i>
                <input type="text" id="srch"
                       placeholder="Search by Farmer Code / Name / Mobile..."
                       oninput="doFilter()">
            </div>
            <select id="filt" onchange="doFilter()">
                <option value="all">All Farmers</option>
                <option value="active">Active Only</option>
                <option value="inactive">Inactive Only</option>
                <option value="thismonth">Joined This Month</option>
            </select>
            <a href="FarmerListServlet" class="ref-btn">
                <i class="ti ti-refresh"></i>Refresh
            </a>
        </div>

        <!-- TABLE -->
        <div class="tw">
            <div class="tw-head">
                <h3>Registered Farmers</h3>
                <span>Showing <span id="sc"><%= total %></span> of <%= total %> farmers</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th style="width:46px">#</th>
                        <th style="width:120px">Code</th>
                        <th>Farmer Name</th>
                        <th style="width:150px">Mobile</th>
                        <th style="width:140px">Joining Date</th>
                        <th style="width:90px">Status</th>
                        <th style="width:210px">Actions</th>
                    </tr>
                </thead>
                <tbody id="tb">
                <% if(farmers != null && !farmers.isEmpty()) {
                       int i = 1;
                       for(Farmer f : farmers) {

                           String dateStr2 = (f.getJoiningDate() != null)
                               ? f.getJoiningDate().toString() : "";

                           String dateDisp = (f.getJoiningDate() != null)
                               ? String.format("%02d-%s-%d",
                                   f.getJoiningDate().getDayOfMonth(),
                                   f.getJoiningDate().getMonth().toString().substring(0,1)
                                   + f.getJoiningDate().getMonth().toString().substring(1,3).toLowerCase(),
                                   f.getJoiningDate().getYear())
                               : "—";

                           String statusVal = f.isActive() ? "active" : "inactive";
                %>
                    <tr data-code="<%= f.getFarmerCode().toLowerCase() %>"
                        data-name="<%= f.getFarmerName().toLowerCase() %>"
                        data-mob="<%= f.getMobile() %>"
                        data-date="<%= dateStr2 %>"
                        data-status="<%= statusVal %>">

                        <td style="color:var(--muted);"><%= i++ %></td>

                        <td><span class="fc"><%= f.getFarmerCode() %></span></td>

                        <td><span class="fn"><%= f.getFarmerName() %></span></td>

                        <td><span class="mob"><%= f.getMobile() %></span></td>

                        <td><span class="jd"><%= dateDisp %></span></td>

                        <!-- STATUS BADGE -->
                        <td>
                            <% if(f.isActive()) { %>
                                <span class="status-badge active">
                                    <i class="ti ti-circle-filled"></i>Active
                                </span>
                            <% } else { %>
                                <span class="status-badge inactive">
                                    <i class="ti ti-circle-filled"></i>Inactive
                                </span>
                            <% } %>
                        </td>

                        <!-- ACTION BUTTONS -->
                        <td>
                            <div class="action-wrap">

                                <!-- View — always shown -->
                                <a href="ViewFarmerServlet?farmerCode=<%= f.getFarmerCode() %>"
                                   class="vbtn vbtn-view">
                                    <i class="ti ti-eye"></i>View
                                </a>

                                <!-- Deactivate — only for ACTIVE farmers -->
                                <% if(f.isActive()) { %>
                                <a href="#"
                                   class="vbtn vbtn-deactivate"
                                   onclick="showModal('deactivate','<%= f.getFarmerCode() %>','<%= f.getFarmerName() %>'); return false;">
                                    <i class="ti ti-user-off"></i>Deactivate
                                </a>
                                <% } %>

                                <!-- Reactivate — only for INACTIVE farmers -->
                                <% if(!f.isActive()) { %>
                                <a href="#"
                                   class="vbtn vbtn-reactivate"
                                   onclick="showModal('reactivate','<%= f.getFarmerCode() %>','<%= f.getFarmerName() %>'); return false;">
                                    <i class="ti ti-user-check"></i>Reactivate
                                </a>
                                <% } %>

                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr><td colspan="7">
                        <div class="empty">
                            <i class="ti ti-users-group"></i>
                            <p>No farmers found.
                               <a href="AddFarmer.jsp" style="color:var(--blue);">
                                   Add a farmer
                               </a> to get started.
                            </p>
                        </div>
                    </td></tr>
                <% } %>
                </tbody>
            </table>

            <div class="pag">
                <span class="pi" id="pi">
                    Showing 1 to <%= total %> of <%= total %> farmers
                </span>
                <div class="pbtns">
                    <div class="pb"><i class="ti ti-chevrons-left"></i></div>
                    <div class="pb active">1</div>
                    <div class="pb"><i class="ti ti-chevrons-right"></i></div>
                </div>
            </div>
        </div>

    </div><!-- /content -->

    <div class="foot">
        <span>© 2026 MilkMitra. All Rights Reserved.</span>
        <span>Logged in as <strong><%= username %></strong> · <%= role %></span>
    </div>
</div>

<!-- ── DEACTIVATE MODAL ── -->
<div class="modal-overlay" id="deactivateModal">
    <div class="modal">
        <div class="modal-icon red">
            <i class="ti ti-user-off"></i>
        </div>
        <h3>Deactivate Farmer?</h3>
        <p>
            You are about to deactivate<br>
            <strong id="deactivateName">—</strong>
            (<span id="deactivateCode">—</span>).<br>
            They will no longer be able to supply milk.
        </p>
        <div class="modal-btns">
            <button class="btn-cancel" onclick="closeModal('deactivateModal')">
                Cancel
            </button>
            <a id="deactivateConfirmBtn" href="#" class="btn-confirm-red">
                Yes, Deactivate
            </a>
        </div>
    </div>
</div>

<!-- ── REACTIVATE MODAL ── -->
<div class="modal-overlay" id="reactivateModal">
    <div class="modal">
        <div class="modal-icon green">
            <i class="ti ti-user-check"></i>
        </div>
        <h3>Reactivate Farmer?</h3>
        <p>
            You are about to reactivate<br>
            <strong id="reactivateName">—</strong>
            (<span id="reactivateCode">—</span>).<br>
            They will be able to supply milk again.
        </p>
        <div class="modal-btns">
            <button class="btn-cancel" onclick="closeModal('reactivateModal')">
                Cancel
            </button>
            <a id="reactivateConfirmBtn" href="#" class="btn-confirm-green">
                Yes, Reactivate
            </a>
        </div>
    </div>
</div>

<script>
// ── DATE ──
document.getElementById('dateStr').textContent =
    new Date().toLocaleDateString('en-IN',{
        weekday:'short',year:'numeric',
        month:'short',day:'numeric'
    });

// ── FILTER ──
function doFilter() {
    const search = document.getElementById('srch').value.toLowerCase().trim();
    const filter = document.getElementById('filt').value;
    const rows   = document.querySelectorAll('#tb tr[data-code]');
    const today  = new Date();
    let visible  = 0;

    rows.forEach(function(row, idx) {
        const code   = row.dataset.code   || '';
        const name   = row.dataset.name   || '';
        const mob    = row.dataset.mob    || '';
        const status = row.dataset.status || '';
        const date   = row.dataset.date   || '';

        let show = true;

        // Search filter
        if(search && !code.includes(search) &&
                     !name.includes(search) &&
                     !mob.includes(search)) {
            show = false;
        }

        // Status filter
        if(filter === 'active'   && status !== 'active')   show = false;
        if(filter === 'inactive' && status !== 'inactive') show = false;

        // This month filter
        if(filter === 'thismonth' && date) {
            const joined = new Date(date);
            if(joined.getMonth()    !== today.getMonth() ||
               joined.getFullYear() !== today.getFullYear()) {
                show = false;
            }
        }

        row.style.display = show ? '' : 'none';

        if(show) {
            visible++;
            // re-number visible rows
            row.querySelector('td:first-child').textContent = visible;
        }
    });

    document.getElementById('sc').textContent = visible;
    document.getElementById('pi').textContent =
        'Showing 1 to ' + visible + ' of ' + visible + ' farmers';
}

// ── MODAL ──
function showModal(type, code, name) {
    if(type === 'deactivate') {
        document.getElementById('deactivateName').textContent = name;
        document.getElementById('deactivateCode').textContent = code;
        document.getElementById('deactivateConfirmBtn').href  =
            'DeactivateFarmerServlet?farmerCode=' + code;
        document.getElementById('deactivateModal').classList.add('show');
    } else {
        document.getElementById('reactivateName').textContent = name;
        document.getElementById('reactivateCode').textContent = code;
        document.getElementById('reactivateConfirmBtn').href  =
            'ReactivateFarmerServlet?farmerCode=' + code;
        document.getElementById('reactivateModal').classList.add('show');
    }
}

function closeModal(id) {
    document.getElementById(id).classList.remove('show');
}

// Close modal on overlay click
document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
    overlay.addEventListener('click', function(e) {
        if(e.target === overlay) overlay.classList.remove('show');
    });
});

// Close modal on Escape key
document.addEventListener('keydown', function(e) {
    if(e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay').forEach(function(m) {
            m.classList.remove('show');
        });
    }
});
</script>

</body>
</html>
