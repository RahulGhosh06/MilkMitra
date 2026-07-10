<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="com.milkmitra.model.Report" %>
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

    String defaultTo   = LocalDate.now().toString();
    String defaultFrom = LocalDate.now().minusDays(10).toString();

    // Date values from last POST (servlet should put them in request attrs or params)
    String fromDateVal = request.getParameter("fromDate");
    String toDateVal   = request.getParameter("toDate");
    if(fromDateVal == null) fromDateVal = defaultFrom;
    if(toDateVal   == null) toDateVal   = defaultTo;

    List<Report> reports = (List<Report>) request.getAttribute("reports");
    if(reports == null) reports = new java.util.ArrayList<>();

    double drTotalLtr=0, drTotalAmt=0;
    for(Report r : reports){ drTotalLtr+=r.getTotalQty(); drTotalAmt+=r.getTotalAmount(); }
    int drRows = reports.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Date-Wise Report</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0a1628;
    --blue:#2563eb;--blue-dark:#1d4ed8;--blue-lt:#eff6ff;--blue-mid:#dbeafe;
    --emerald:#059669;--emerald-lt:#ecfdf5;
    --teal-mid:#99f6e4;
    --amber-mid:#fde68a;
    --violet:#7c3aed;--violet-lt:#f5f3ff;--violet-mid:#ddd6fe;
    --muted:#64748b;--muted-light:#94a3b8;
    --border:#e2e8f0;--border-dark:#cbd5e1;
    --bg:#f1f5f9;--bg-card:#f8fafc;--white:#fff;
    --text-primary:#0f172a;--text-secondary:#475569;
    --sb:252px;--sb-bg:#0f1f3d;
    --radius:14px;--radius-sm:8px;
    --shadow-sm:0 1px 3px rgba(0,0,0,.07),0 1px 2px rgba(0,0,0,.05);
    --shadow-md:0 4px 16px rgba(0,0,0,.08);
}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text-primary);display:flex;min-height:100vh;font-size:14px;}

/* ══ SIDEBAR ══ */
.sidenav{width:var(--sb);flex-shrink:0;background:var(--sb-bg);display:flex;flex-direction:column;position:fixed;top:0;left:0;height:100vh;z-index:100;border-right:1px solid rgba(255,255,255,.06);}
.sn-brand{padding:22px 20px 16px;border-bottom:1px solid rgba(255,255,255,.08);background:linear-gradient(135deg,#0f2040 0%,#1a3a6e 100%);}
.sn-brand h1{font-family:'DM Serif Display',serif;font-size:24px;color:#fff;letter-spacing:-.3px;}
.sn-brand h1 span{color:#60a5fa;}
.sn-brand p{font-size:10px;color:rgba(255,255,255,.4);letter-spacing:1px;text-transform:uppercase;margin-top:3px;}
.sn-brand-dot{display:inline-block;width:6px;height:6px;border-radius:50%;background:#34d399;margin-right:6px;vertical-align:middle;}
.sn-nav{flex:1;overflow-y:auto;padding:14px 10px 0;display:flex;flex-direction:column;gap:1px;}
.sn-label{font-size:9px;font-weight:700;color:rgba(255,255,255,.3);text-transform:uppercase;letter-spacing:1px;padding:12px 10px 5px;}
.sn-item{display:flex;align-items:center;gap:9px;padding:9px 12px;border-radius:var(--radius-sm);text-decoration:none;font-size:12.5px;font-weight:500;color:rgba(255,255,255,.65);transition:background .15s,color .15s;}
.sn-item:hover{background:rgba(255,255,255,.07);color:#e2e8f0;}
.sn-item.active{background:rgba(99,179,237,.15);color:#93c5fd;font-weight:600;}
.sn-item i{font-size:16px;flex-shrink:0;opacity:.8;}
.sn-divider{height:1px;background:rgba(255,255,255,.06);margin:8px 10px;}
.sn-foot{padding:12px;border-top:1px solid rgba(255,255,255,.07);}
.sn-user{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.08);border-radius:var(--radius-sm);margin-bottom:8px;}
.sn-av{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#3b82f6,#1d4ed8);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;}
.sn-meta .name{font-size:12px;font-weight:600;color:#e2e8f0;}
.sn-meta .role{font-size:10px;color:rgba(255,255,255,.35);text-transform:capitalize;margin-top:1px;}
.lo-link{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:var(--radius-sm);background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.2);color:#fca5a5;font-size:12px;font-weight:600;text-decoration:none;transition:background .15s;}
.lo-link:hover{background:rgba(239,68,68,.18);}
.lo-link i{font-size:15px;}

/* ══ MAIN ══ */
.main{margin-left:var(--sb);flex:1;display:flex;flex-direction:column;min-height:100vh;}
.topbar{background:var(--white);border-bottom:1px solid var(--border);padding:0 28px;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;box-shadow:var(--shadow-sm);}
.tb-left{display:flex;align-items:center;gap:12px;}
.tb-crumb{display:flex;align-items:center;gap:6px;font-size:11.5px;color:var(--muted);}
.tb-crumb a{color:var(--muted);text-decoration:none;}
.tb-crumb a:hover{color:var(--blue);}
.tb-crumb .sep{color:var(--border-dark);}
.tb-divider-v{width:1px;height:24px;background:var(--border);}
.tb-title-group h2{font-family:'DM Serif Display',serif;font-size:17px;color:var(--navy);line-height:1.2;}
.tb-title-group p{font-size:11px;color:var(--muted);margin-top:1px;}
.tb-right{display:flex;align-items:center;gap:8px;}
.tb-btn{display:flex;align-items:center;gap:5px;padding:7px 16px;background:linear-gradient(135deg,var(--blue),var(--blue-dark));color:#fff;border:none;border-radius:var(--radius-sm);font-size:12px;font-weight:600;font-family:'Inter',sans-serif;cursor:pointer;text-decoration:none;transition:opacity .15s;box-shadow:0 2px 8px rgba(37,99,235,.3);}
.tb-btn:hover{opacity:.9;}
.tb-btn i{font-size:15px;}
.tb-icon{width:36px;height:36px;background:var(--bg);border:1px solid var(--border);border-radius:var(--radius-sm);display:flex;align-items:center;justify-content:center;color:var(--muted);cursor:pointer;text-decoration:none;transition:all .15s;}
.tb-icon:hover{background:var(--blue-lt);border-color:var(--blue-mid);color:var(--blue);}
.tb-icon i{font-size:17px;}
.tb-date{font-size:11px;color:var(--muted);background:var(--bg);padding:5px 13px;border-radius:20px;border:1px solid var(--border);font-weight:500;}

/* ══ CONTENT ══ */
.content{padding:24px 28px;flex:1;display:flex;flex-direction:column;gap:20px;}

.sec-row{display:flex;align-items:center;justify-content:space-between;}
.sec-title{font-size:13px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px;}
.sec-title i{color:var(--muted);font-size:16px;}

/* ══ DATE-WISE LAYOUT ══ */
.dw-wrap{display:flex;gap:20px;align-items:flex-start;}
.dw-form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);padding:24px;width:320px;flex-shrink:0;box-shadow:var(--shadow-sm);}
.dw-results{flex:1;min-width:0;}
.dw-form-title{font-size:14px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px;margin-bottom:20px;padding-bottom:14px;border-bottom:1px solid var(--border);}
.dw-form-title i{font-size:17px;color:var(--blue);}
.fg{margin-bottom:16px;}
.fg label{display:block;font-size:11px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:.4px;margin-bottom:7px;}
.inp-wrap{position:relative;display:flex;align-items:center;}
.inp-wrap i{position:absolute;left:11px;font-size:15px;color:var(--muted-light);pointer-events:none;}
.inp-wrap input[type=date]{width:100%;padding:9px 12px 9px 36px;font-family:'Inter',sans-serif;font-size:13px;color:var(--text-primary);background:var(--bg);border:1.5px solid var(--border);border-radius:var(--radius-sm);outline:none;transition:border-color .18s,box-shadow .18s;}
.inp-wrap input[type=date]:focus{border-color:var(--blue);background:var(--white);box-shadow:0 0 0 3px rgba(37,99,235,.1);}
.gen-btn{width:100%;padding:11px;background:linear-gradient(135deg,var(--blue),var(--blue-dark));color:#fff;border:none;border-radius:var(--radius-sm);font-family:'Inter',sans-serif;font-size:13px;font-weight:600;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:6px;transition:opacity .18s,transform .1s;margin-top:8px;box-shadow:0 3px 10px rgba(37,99,235,.3);}
.gen-btn:hover{opacity:.9;transform:translateY(-1px);}
.gen-btn i{font-size:15px;}

/* ── Summary chips ── */
.dw-summary{display:flex;gap:10px;margin-bottom:14px;flex-wrap:wrap;}
.dw-chip{background:var(--white);border:1px solid var(--border);border-radius:10px;padding:11px 16px;box-shadow:var(--shadow-sm);min-width:110px;}
.dw-chip .cv{font-size:18px;font-weight:800;color:var(--text-primary);letter-spacing:-.3px;}
.dw-chip .cl{font-size:10.5px;color:var(--muted);margin-top:3px;font-weight:600;text-transform:uppercase;letter-spacing:.3px;}
.dw-chip.emerald{border-left:3px solid var(--emerald);}
.dw-chip.emerald .cv{color:#065f46;}
.dw-chip.blue   {border-left:3px solid var(--blue);}
.dw-chip.blue .cv{color:var(--blue-dark);}
.dw-chip.violet {border-left:3px solid var(--violet);}
.dw-chip.violet .cv{color:#5b21b6;}

/* ── Table panel ── */
.shift-panel{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow-sm);}
.sp-head{display:flex;align-items:center;justify-content:space-between;padding:15px 20px;border-bottom:1px solid var(--border);background:var(--bg-card);}
.sp-left{display:flex;align-items:center;gap:12px;}
.sp-icon{width:38px;height:38px;border-radius:9px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.sp-icon i{font-size:19px;}
.sp-icon.emerald{background:#bbf7d0;color:#065f46;}
.sp-title{font-size:13.5px;font-weight:700;color:var(--navy);}
.sp-sub{font-size:11px;color:var(--muted);margin-top:2px;}
.tbl-wrap{overflow-x:auto;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead tr{background:linear-gradient(90deg,#f8fafc,#f1f5f9);}
thead th{padding:10px 14px;font-size:10.5px;font-weight:700;color:var(--text-secondary);text-transform:uppercase;letter-spacing:.5px;text-align:left;border-bottom:2px solid var(--border);white-space:nowrap;}
tbody tr{border-bottom:1px solid var(--border);transition:background .12s;}
tbody tr:hover{background:#f8faff;}
tbody tr:last-child{border-bottom:none;}
tbody td{padding:10px 14px;vertical-align:middle;white-space:nowrap;}
.fc{font-weight:700;color:var(--blue);}
.fn{font-weight:600;color:var(--text-primary);}
.idx-col{color:var(--muted-light);font-size:11px;font-weight:500;}
.num{font-weight:700;}
.num.emerald{color:#065f46;}
.tfoot-row td{background:linear-gradient(90deg,#f1f5f9,#e8f0fe);font-weight:700;border-top:2px solid var(--border-dark);}

/* ── View details button ── */
.detail-btn{
    display:inline-flex;align-items:center;gap:5px;
    padding:5px 13px;border-radius:7px;
    background:var(--blue-lt);color:var(--blue-dark);
    border:1px solid var(--blue-mid);
    font-size:11.5px;font-weight:700;
    text-decoration:none;
    transition:background .15s,color .15s,transform .1s;
    white-space:nowrap;
}
.detail-btn:hover{
    background:var(--blue);color:#fff;
    border-color:var(--blue);
    transform:translateY(-1px);
    box-shadow:0 2px 8px rgba(37,99,235,.25);
}
.detail-btn i{font-size:13px;}

/* ── Under construction ── */
.wip{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);padding:52px 24px;text-align:center;color:var(--muted);box-shadow:var(--shadow-sm);}
.wip i{font-size:42px;opacity:.2;display:block;margin-bottom:12px;}
.wip .wip-title{font-size:15px;font-weight:700;color:var(--text-secondary);margin-bottom:5px;}
.wip p{font-size:13px;}

.foot{padding:14px 28px;border-top:1px solid var(--border);font-size:11px;color:var(--muted);background:var(--white);display:flex;justify-content:space-between;align-items:center;}
.foot-logo{font-family:'DM Serif Display',serif;font-size:13px;color:var(--navy);}
.foot-logo span{color:var(--blue);}

@media print{
    .sidenav,.topbar,.foot,.gen-btn,.tb-icon,.tb-btn{display:none!important;}
    .main{margin-left:0;}
    .content{padding:12px;}
}
</style>
</head>
<body>

<!-- ════════════ SIDEBAR ════════════ -->
<aside class="sidenav">
    <div class="sn-brand">
        <h1>Milk<span>Mitra</span></h1>
        <p><span class="sn-brand-dot"></span>Collection Reports</p>
    </div>
    <nav class="sn-nav">
        <div class="sn-label">Today's View</div>
        <a href="milkcollectionReportServlet?view=today" class="sn-item"><i class="ti ti-report-analytics"></i>All Collections</a>
        <a href="milkcollectionReportServlet?shift=MORNING&view=morning" class="sn-item"><i class="ti ti-sun"></i>Morning Shift</a>
        <a href="milkcollectionReportServlet?shift=EVENING&view=evening" class="sn-item"><i class="ti ti-moon"></i>Evening Shift</a>
        <div class="sn-divider"></div>
        <div class="sn-label">Analysis</div>
        <a href="milkcollectionReport.jsp?view=datewise" class="sn-item active"><i class="ti ti-calendar-search"></i>Date-wise Report</a>
        <a href="milkcollectionReport.jsp?view=farmerwise" class="sn-item"><i class="ti ti-users"></i>Farmer-wise Report</a>
        <a href="milkcollectionReport.jsp?view=monthly" class="sn-item"><i class="ti ti-calendar-stats"></i>Monthly Report</a>
        <div class="sn-divider"></div>
        <div class="sn-label">Navigation</div>
        <a href="AdminDashboardServlet?view=milkCollection" class="sn-item"><i class="ti ti-plus"></i>New Entry</a>
        <a href="AdminDashboard.jsp" class="sn-item"><i class="ti ti-home"></i>Dashboard</a>
    </nav>
    <div class="sn-foot">
        <div class="sn-user">
            <div class="sn-av"><%= username.substring(0,1).toUpperCase() %></div>
            <div class="sn-meta">
                <div class="name"><%= username %></div>
                <div class="role"><%= role.toLowerCase() %></div>
            </div>
        </div>
        <a href="Logout" class="lo-link"><i class="ti ti-logout"></i>Sign Out</a>
    </div>
</aside>

<!-- ════════════ MAIN ════════════ -->
<div class="main">
    <div class="topbar">
        <div class="tb-left">
            <div class="tb-crumb">
                <a href="AdminDashboard.jsp"><i class="ti ti-home" style="font-size:13px;vertical-align:-1px;"></i></a>
                <span class="sep">/</span>
                <span>Reports</span>
                <span class="sep">/</span>
                <span style="color:var(--text-primary);font-weight:600;">Date-wise Report</span>
            </div>
            <div class="tb-divider-v"></div>
            <div class="tb-title-group">
                <h2>Date-wise Collection Report</h2>
                <p>Milk Collection Reports</p>
            </div>
        </div>
        <div class="tb-right">
            <div class="tb-date" id="dateStr"></div>
            <% if(!reports.isEmpty()) { %>
            <button class="tb-icon" onclick="window.print()" title="Print"><i class="ti ti-printer"></i></button>
            <% } %>
            <a href="AdminDashboardServlet?view=milkCollection" class="tb-btn"><i class="ti ti-plus"></i>New Entry</a>
        </div>
    </div>

    <div class="content">

        <div class="sec-row">
            <div class="sec-title"><i class="ti ti-calendar-search"></i>Date-wise Collection Report</div>
        </div>

        <div class="dw-wrap">

            <!-- ── Form Card ── -->
            <div class="dw-form-card">
                <div class="dw-form-title">
                    <i class="ti ti-calendar-event"></i>Select Date Range
                </div>
                <form action="DateWiseCollectionReportServlet" method="POST">
                    <div class="fg">
                        <label for="fromDate">From Date</label>
                        <div class="inp-wrap">
                            <i class="ti ti-calendar"></i>
                            <input type="date" id="fromDate" name="fromDate" value="<%= fromDateVal %>" required>
                        </div>
                    </div>
                    <div class="fg">
                        <label for="toDate">To Date</label>
                        <div class="inp-wrap">
                            <i class="ti ti-calendar"></i>
                            <input type="date" id="toDate" name="toDate" value="<%= toDateVal %>" required>
                        </div>
                    </div>
                    <button type="submit" class="gen-btn">
                        <i class="ti ti-file-analytics"></i>Generate Report
                    </button>
                </form>
            </div>

            <!-- ── Results Area ── -->
            <div class="dw-results">
                <% if(reports.isEmpty()) { %>
                <div class="wip" style="min-height:240px;display:flex;flex-direction:column;align-items:center;justify-content:center;">
                    <i class="ti ti-calendar-search"></i>
                    <div class="wip-title">No Report Generated</div>
                    <p>Select a date range and click <strong>Generate Report</strong> to view farmer-wise data.</p>
                </div>

                <% } else { %>
                <!-- Summary chips -->
                <div class="dw-summary">
                    <div class="dw-chip blue">
                        <div class="cv"><%= drRows %></div>
                        <div class="cl">Farmers</div>
                    </div>
                    <div class="dw-chip emerald">
                        <div class="cv"><%= String.format("%.2f",drTotalLtr) %> L</div>
                        <div class="cl">Total Quantity</div>
                    </div>
                    <div class="dw-chip violet">
                        <div class="cv">₹<%= String.format("%.2f",drTotalAmt) %></div>
                        <div class="cl">Total Amount</div>
                    </div>
                </div>

                <!-- Table -->
                <div class="shift-panel">
                    <div class="sp-head">
                        <div class="sp-left">
                            <div class="sp-icon emerald"><i class="ti ti-table"></i></div>
                            <div>
                                <div class="sp-title">Farmer-wise Collection Summary</div>
                                <div class="sp-sub">
                                    <%= fromDateVal %> to <%= toDateVal %> &middot; <%= drRows %> farmer<%= drRows==1?"":"s" %>
                                </div>
                            </div>
                        </div>
                        <div style="display:flex;align-items:center;gap:8px;">
                            <button class="tb-icon" onclick="window.print()" title="Print"><i class="ti ti-printer"></i></button>
                        </div>
                    </div>
                    <div class="tbl-wrap">
                        <table>
                            <thead><tr>
                                <th>#</th>
                                <th>Farmer Code</th>
                                <th>Farmer Name</th>
                                <th>Total Qty (L)</th>
                                <th>Total Amount (₹)</th>
                                <th style="width:110px;">Details</th>
                            </tr></thead>
                            <tbody>
                            <%
                                int ri=1;
                                double runLtr=0, runAmt=0;
                                for(Report r : reports){
                                    runLtr += r.getTotalQty();
                                    runAmt += r.getTotalAmount();
                            %>
                            <tr>
                                <td class="idx-col"><%= ri++ %></td>
                                <td class="fc"><%= r.getFarmerCode() %></td>
                                <td class="fn"><%= r.getFarmerName() %></td>
                                <td class="num emerald"><%= String.format("%.2f",r.getTotalQty()) %></td>
                                <td class="num emerald">₹<%= String.format("%.2f",r.getTotalAmount()) %></td>
                                <td>
                                    <a href="FarmerCollectionDetailServlet?farmerCode=<%= r.getFarmerCode() %>&fromDate=<%= fromDateVal %>&toDate=<%= toDateVal %>"
                                       class="detail-btn">
                                        <i class="ti ti-eye"></i>View
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="tfoot-row">
                                    <td colspan="3" style="color:var(--muted);font-size:11px;font-weight:700;">
                                        TOTALS &nbsp;·&nbsp; <%= drRows %> farmer<%= drRows==1?"":"s" %>
                                    </td>
                                    <td class="num emerald"><%= String.format("%.2f",runLtr) %> L</td>
                                    <td class="num emerald">₹<%= String.format("%.2f",runAmt) %></td>
                                    <td>—</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <% } %>
            </div>

        </div><!-- /dw-wrap -->

    </div><!-- /content -->

    <div class="foot">
        <div class="foot-logo">Milk<span>Mitra</span> © 2026. All Rights Reserved.</div>
        <span>Session: <strong><%= username %></strong> · <%= role %></span>
    </div>
</div>

<script>
document.getElementById('dateStr').textContent =
    new Date().toLocaleDateString('en-IN',{weekday:'short',year:'numeric',month:'short',day:'numeric'});
</script>
</body>
</html>
