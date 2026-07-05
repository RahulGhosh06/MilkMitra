<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="com.milkmitra.model.Collection" %>
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

    List<Collection> entries = (List<Collection>) request.getAttribute("entries");
    if(entries == null) entries = new java.util.ArrayList<>();

    String farmerCode = request.getParameter("farmerCode");
    String farmerName = (String) request.getAttribute("farmerName");
    String fromDate   = request.getParameter("fromDate");
    String toDate     = request.getParameter("toDate");
    if(farmerCode == null) farmerCode = "—";
    if(farmerName == null) farmerName = farmerCode;
    if(fromDate   == null) fromDate   = "—";
    if(toDate     == null) toDate     = "—";

    String fromDisp = fromDate, toDisp = toDate;
    try {
        java.time.LocalDate fd  = java.time.LocalDate.parse(fromDate);
        java.time.LocalDate td2 = java.time.LocalDate.parse(toDate);
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd-MMM-yyyy");
        fromDisp = fd.format(df);
        toDisp   = td2.format(df);
    } catch(Exception e2){}

    double totalQty=0, totalAmt=0, fatSum=0, snfSum=0;
    int    morningCnt=0, eveningCnt=0;
    for(Collection c : entries){
        totalQty += c.getQuantity();
        totalAmt += c.getAmount();
        fatSum   += c.getFat();
        snfSum   += c.getSnf();
        if("MORNING".equalsIgnoreCase(c.getShift())) morningCnt++;
        else eveningCnt++;
    }
    int    cnt    = entries.size();
    double avgFat = cnt==0 ? 0 : fatSum/cnt;
    double avgSnf = cnt==0 ? 0 : snfSum/cnt;

   java.text.SimpleDateFormat timeFmt = new java.text.SimpleDateFormat("dd-MMM-yyyy HH:mm");
   timeFmt.setTimeZone(java.util.TimeZone.getTimeZone("Asia/Kolkata"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | <%= farmerName %> — Collection Details</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0a1628;
    --blue:#2563eb;--blue-dark:#1d4ed8;
    --blue-lt:#eff6ff;--blue-mid:#dbeafe;
    --emerald:#059669;--emerald-lt:#ecfdf5;
    --teal:#0d9488;--teal-lt:#f0fdfa;--teal-mid:#99f6e4;
    --amber:#d97706;--amber-lt:#fffbeb;--amber-mid:#fde68a;
    --violet:#7c3aed;--violet-lt:#f5f3ff;--violet-mid:#ddd6fe;
    --cyan:#0891b2;--cyan-lt:#ecfeff;--cyan-mid:#a5f3fc;
    --rose:#e11d48;--rose-lt:#fff1f2;--rose-mid:#fecdd3;
    --muted:#64748b;--muted-light:#94a3b8;
    --border:#e2e8f0;--border-dark:#cbd5e1;
    --bg:#f1f5f9;--bg-card:#f8fafc;--white:#fff;
    --text-primary:#0f172a;--text-secondary:#475569;
    --sb:252px;--sb-bg:#0f1f3d;
    --radius:14px;--radius-sm:8px;
    --shadow-sm:0 1px 3px rgba(0,0,0,.07),0 1px 2px rgba(0,0,0,.05);
    --shadow-md:0 4px 16px rgba(0,0,0,.08),0 2px 6px rgba(0,0,0,.04);
}
body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text-primary);display:flex;min-height:100vh;font-size:14px;}

/* ══ SIDEBAR ══ */
.sidenav{
    width:var(--sb);flex-shrink:0;
    background:var(--sb-bg);
    display:flex;flex-direction:column;
    position:fixed;top:0;left:0;height:100vh;z-index:100;
    border-right:1px solid rgba(255,255,255,.06);
}
.sn-brand{
    padding:22px 20px 16px;
    border-bottom:1px solid rgba(255,255,255,.08);
    background:linear-gradient(135deg,#0f2040 0%,#1a3a6e 100%);
}
.sn-brand h1{font-family:'DM Serif Display',serif;font-size:24px;color:#fff;letter-spacing:-.3px;}
.sn-brand h1 span{color:#60a5fa;}
.sn-brand p{font-size:10px;color:rgba(255,255,255,.4);letter-spacing:1px;text-transform:uppercase;margin-top:3px;}
.sn-brand-dot{display:inline-block;width:6px;height:6px;border-radius:50%;background:#34d399;margin-right:6px;vertical-align:middle;box-shadow:0 0 0 2px rgba(52,211,153,.25);}
.sn-nav{flex:1;overflow-y:auto;padding:14px 10px 0;display:flex;flex-direction:column;gap:1px;}
.sn-nav::-webkit-scrollbar{width:3px;}
.sn-nav::-webkit-scrollbar-thumb{background:rgba(255,255,255,.12);border-radius:4px;}
.sn-label{font-size:9px;font-weight:700;color:rgba(255,255,255,.3);text-transform:uppercase;letter-spacing:1px;padding:12px 10px 5px;}
.sn-item{display:flex;align-items:center;gap:9px;padding:9px 12px;border-radius:var(--radius-sm);text-decoration:none;font-size:12.5px;font-weight:500;color:rgba(255,255,255,.65);transition:background .15s,color .15s;}
.sn-item:hover{background:rgba(255,255,255,.07);color:#e2e8f0;}
.sn-item.active{background:rgba(99,179,237,.15);color:#93c5fd;font-weight:600;}
.sn-item i{font-size:16px;flex-shrink:0;opacity:.8;}
.sn-divider{height:1px;background:rgba(255,255,255,.06);margin:8px 10px;}
.sn-foot{padding:12px;border-top:1px solid rgba(255,255,255,.07);}
.sn-user{display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(255,255,255,.05);border:1px solid rgba(255,255,255,.08);border-radius:var(--radius-sm);margin-bottom:8px;}
.sn-av{width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#3b82f6,#1d4ed8);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;box-shadow:0 0 0 2px rgba(59,130,246,.3);}
.sn-meta .name{font-size:12px;font-weight:600;color:#e2e8f0;}
.sn-meta .role{font-size:10px;color:rgba(255,255,255,.35);text-transform:capitalize;margin-top:1px;}
.lo-link{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:var(--radius-sm);background:rgba(239,68,68,.1);border:1px solid rgba(239,68,68,.2);color:#fca5a5;font-size:12px;font-weight:600;text-decoration:none;transition:background .15s;}
.lo-link:hover{background:rgba(239,68,68,.18);}
.lo-link i{font-size:15px;}

/* ══ MAIN ══ */
.main{margin-left:var(--sb);flex:1;display:flex;flex-direction:column;min-height:100vh;}

/* ══ TOPBAR ══ */
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
.tb-icon{width:36px;height:36px;background:var(--bg);border:1px solid var(--border);border-radius:var(--radius-sm);display:flex;align-items:center;justify-content:center;color:var(--muted);cursor:pointer;text-decoration:none;transition:all .15s;}
.tb-icon:hover{background:var(--blue-lt);border-color:var(--blue-mid);color:var(--blue);}
.tb-icon i{font-size:17px;}
.back-btn{display:flex;align-items:center;gap:6px;padding:7px 16px;background:var(--bg);color:var(--text-secondary);border:1px solid var(--border);border-radius:var(--radius-sm);font-size:12px;font-weight:600;text-decoration:none;transition:all .15s;}
.back-btn:hover{background:var(--white);border-color:var(--border-dark);color:var(--navy);}
.back-btn i{font-size:15px;}

/* ══ CONTENT ══ */
.content{padding:20px 28px;flex:1;display:flex;flex-direction:column;gap:16px;}

/* ══ FARMER HEADER CARD ══ */
.farmer-hero{
    background:linear-gradient(135deg,#0f2040 0%,#1a3a6e 60%,#1e4080 100%);
    border-radius:var(--radius);padding:20px 24px;
    display:flex;align-items:center;justify-content:space-between;
    box-shadow:var(--shadow-md);position:relative;overflow:hidden;
}
.farmer-hero::after{content:'';position:absolute;right:-40px;top:-40px;width:200px;height:200px;border-radius:50%;background:rgba(255,255,255,.04);pointer-events:none;}
.fh-left{display:flex;align-items:center;gap:14px;}
.fh-av{width:48px;height:48px;border-radius:50%;background:linear-gradient(135deg,#3b82f6,#60a5fa);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:20px;flex-shrink:0;border:3px solid rgba(255,255,255,.2);box-shadow:0 0 0 4px rgba(59,130,246,.2);}
.fh-info .fname{font-size:18px;font-weight:800;color:#fff;letter-spacing:-.3px;font-family:'DM Serif Display',serif;}
.fh-info .fcode{font-size:11px;color:rgba(255,255,255,.55);margin-top:3px;font-weight:500;}
.fh-info .frange{display:inline-flex;align-items:center;gap:5px;margin-top:6px;padding:3px 10px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.15);border-radius:20px;font-size:10px;color:rgba(255,255,255,.75);font-weight:600;}
.fh-info .frange i{font-size:12px;}
.fh-right{display:flex;gap:14px;}
.fh-stat{text-align:right;}
.fh-stat .sv{font-size:18px;font-weight:800;color:#fff;letter-spacing:-.5px;}
.fh-stat .sl{font-size:9px;color:rgba(255,255,255,.45);text-transform:uppercase;letter-spacing:.5px;margin-top:2px;font-weight:600;}
.fh-divider{width:1px;background:rgba(255,255,255,.15);margin:4px 0;}

/* ══ SUMMARY STRIP ══ */
.summary-strip{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;}
.ss-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);padding:12px 14px;box-shadow:var(--shadow-sm);display:flex;align-items:center;gap:10px;position:relative;overflow:hidden;}
.ss-card::before{content:'';position:absolute;left:0;top:0;bottom:0;width:3px;border-radius:var(--radius) 0 0 var(--radius);}
.ss-card.blue::before   {background:linear-gradient(180deg,#3b82f6,#1d4ed8);}
.ss-card.emerald::before{background:linear-gradient(180deg,#10b981,#047857);}
.ss-card.amber::before  {background:linear-gradient(180deg,#f59e0b,#b45309);}
.ss-card.teal::before   {background:linear-gradient(180deg,#14b8a6,#0f766e);}
.ss-card.violet::before {background:linear-gradient(180deg,#8b5cf6,#6d28d9);}
.ss-icon{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.ss-icon i{font-size:17px;}
.ss-icon.blue   {background:var(--blue-mid);   color:var(--blue-dark);}
.ss-icon.emerald{background:#bbf7d0;             color:#065f46;}
.ss-icon.amber  {background:var(--amber-mid);  color:#92400e;}
.ss-icon.teal   {background:var(--teal-mid);   color:#134e4a;}
.ss-icon.violet {background:var(--violet-mid); color:#4c1d95;}
.ss-body .val{font-size:15px;font-weight:800;color:var(--text-primary);line-height:1;letter-spacing:-.3px;}
.ss-body .lbl{font-size:10px;color:var(--text-secondary);margin-top:3px;font-weight:600;}

/* ══ SECTION HEADING ══ */
.sec-row{display:flex;align-items:center;justify-content:space-between;}
.sec-title{font-size:13px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px;}
.sec-title i{color:var(--muted);font-size:16px;}
.sec-tag{font-size:11px;background:linear-gradient(135deg,var(--blue-lt),#e0f2fe);color:var(--blue-dark);padding:3px 12px;border-radius:20px;border:1px solid var(--blue-mid);font-weight:600;}

/* ══ COMPACT ENTRY CARDS ══ */
.cards-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill, minmax(340px, 1fr));
    gap:10px;
}

.entry-card{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:12px;
    overflow:hidden;
    box-shadow:var(--shadow-sm);
    transition:box-shadow .2s;
}
.entry-card:hover{box-shadow:var(--shadow-md);}

/* top accent line */
.entry-card.morning-card{border-top:3px solid var(--teal);}
.entry-card.evening-card{border-top:3px solid var(--violet);}

/* ── compact header row ── */
.ec-header{
    display:flex;align-items:center;justify-content:space-between;
    padding:7px 12px;
    border-bottom:1px solid var(--border);
}
.ec-header.morning-bg{background:linear-gradient(90deg,#f0fdfa,#fff);}
.ec-header.evening-bg{background:linear-gradient(90deg,#f5f3ff,#fff);}

.ec-shift-badge{
    display:inline-flex;align-items:center;gap:4px;
    padding:3px 10px;border-radius:20px;
    font-size:11px;font-weight:700;
}
.ec-shift-badge.morning{background:var(--teal-mid);color:#134e4a;border:1px solid var(--teal);}
.ec-shift-badge.evening{background:var(--violet-mid);color:#4c1d95;border:1px solid var(--violet);}
.ec-shift-badge i{font-size:12px;}

.ec-date{font-size:11px;color:var(--muted);font-weight:500;}

/* ── compact two-column body ── */
.ec-body{
    display:grid;
    grid-template-columns:1fr 1fr;
}
.ec-col{padding:10px 12px;}
.ec-col:first-child{border-right:1px solid var(--border);}

.ec-field{margin-bottom:8px;}
.ec-field:last-child{margin-bottom:0;}

.ec-label{
    font-size:9.5px;font-weight:700;
    color:#00bcd4;                   /* cyan-blue like reference screenshots */
    text-transform:uppercase;letter-spacing:.3px;
    margin-bottom:2px;
}
.ec-value{
    font-size:13px;font-weight:600;
    color:var(--text-primary);
    line-height:1.3;
}
.ec-value.amount{color:var(--text-primary);font-weight:600;}

/* cattle pill */
.cattle-pill{
    display:inline-flex;align-items:center;gap:3px;
    padding:1px 7px;border-radius:20px;
    font-size:10px;font-weight:700;margin-left:4px;
}
.cattle-pill.cow{background:#bbf7d0;color:#065f46;border:1px solid #6ee7b7;}
.cattle-pill.buf{background:var(--amber-mid);color:#92400e;border:1px solid #fbbf24;}

/* fat-snf inline display */
.fat-snf-row{display:flex;align-items:center;gap:5px;}
.fat-snf-val{
    background:var(--bg);border:1px solid var(--border);
    border-radius:6px;padding:2px 7px;
    font-size:12px;font-weight:600;color:var(--text-primary);
}
.fat-snf-sep{font-size:14px;color:var(--border-dark);}

/* ══ EMPTY STATE ══ */
.empty-state{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);padding:50px 24px;text-align:center;color:var(--muted);box-shadow:var(--shadow-sm);}
.empty-state i{font-size:40px;opacity:.18;display:block;margin-bottom:10px;}
.empty-state .etitle{font-size:14px;font-weight:700;color:var(--text-secondary);margin-bottom:4px;}
.empty-state p{font-size:12px;}
.empty-state a{display:inline-flex;align-items:center;gap:5px;margin-top:12px;padding:7px 16px;background:linear-gradient(135deg,var(--blue),var(--blue-dark));color:#fff;border-radius:var(--radius-sm);font-size:12px;font-weight:600;text-decoration:none;}

/* ══ FOOTER ══ */
.foot{padding:12px 28px;border-top:1px solid var(--border);font-size:11px;color:var(--muted);background:var(--white);display:flex;justify-content:space-between;align-items:center;}
.foot-logo{font-family:'DM Serif Display',serif;font-size:13px;color:var(--navy);}
.foot-logo span{color:var(--blue);}

/* ══ MOBILE RESPONSIVE ══ */
@media(max-width:768px){
    .sidenav{display:none;}
    .main{margin-left:0;}
    .topbar{padding:0 14px;height:56px;}
    .tb-crumb,.tb-divider-v,.tb-title-group p{display:none;}
    .tb-title-group h2{font-size:14px;}
    .content{padding:12px 14px;gap:12px;}
    .farmer-hero{padding:14px 16px;flex-direction:column;align-items:flex-start;gap:12px;}
    .fh-right{width:100%;justify-content:space-between;}
    .summary-strip{grid-template-columns:repeat(3,1fr);}
    .summary-strip .ss-card:nth-child(4),
    .summary-strip .ss-card:nth-child(5){display:none;}
    .cards-grid{grid-template-columns:1fr;}
    .foot{padding:10px 14px;}
}

/* ══ PRINT ══ */
@media print{
    .sidenav,.topbar,.foot,.back-btn,.tb-icon{display:none!important;}
    .main{margin-left:0;}
    .content{padding:12px;}
    .entry-card{box-shadow:none;break-inside:avoid;}
    .farmer-hero{background:#0f1f3d!important;-webkit-print-color-adjust:exact;}
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
        <a href="milkcollection.jsp" class="sn-item"><i class="ti ti-plus"></i>New Entry</a>
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
                <a href="milkcollectionReport.jsp?view=datewise">Reports</a>
                <span class="sep">/</span>
                <span style="color:var(--text-primary);font-weight:600;">Farmer Details</span>
            </div>
            <div class="tb-divider-v"></div>
            <div class="tb-title-group">
                <h2>Collection Detail — <%= farmerName %></h2>
                <p><%= fromDisp %> to <%= toDisp %> · <%= cnt %> entries</p>
            </div>
        </div>
        <div class="tb-right">
            <a href="DateWiseCollectionReportServlet?fromDate=<%= fromDate %>&toDate=<%= toDate %>" class="back-btn">
                <i class="ti ti-arrow-left"></i>Back to Report
            </a>
            <button class="tb-icon" onclick="window.print()" title="Print"><i class="ti ti-printer"></i></button>
        </div>
    </div>

    <div class="content">

        <!-- ── FARMER HERO ── -->
        <div class="farmer-hero">
            <div class="fh-left">
                <div class="fh-av"><%= farmerName.substring(0,1).toUpperCase() %></div>
                <div class="fh-info">
                    <div class="fname"><%= farmerName %></div>
                    <div class="fcode">Code: <strong style="color:rgba(255,255,255,.8)"><%= farmerCode %></strong></div>
                    <div class="frange"><i class="ti ti-calendar-event"></i>Payments: <%= fromDisp %> to <%= toDisp %></div>
                </div>
            </div>
            <div class="fh-right">
                <div class="fh-stat">
                    <div class="sv"><%= cnt %></div>
                    <div class="sl">Entries</div>
                </div>
                <div class="fh-divider"></div>
                <div class="fh-stat">
                    <div class="sv"><%= String.format("%.2f",totalQty) %> L</div>
                    <div class="sl">Total Qty</div>
                </div>
                <div class="fh-divider"></div>
                <div class="fh-stat">
                    <div class="sv">₹<%= String.format("%.2f",totalAmt) %></div>
                    <div class="sl">Total Paid</div>
                </div>
            </div>
        </div>

        <!-- ── SUMMARY STRIP ── -->
        <div class="summary-strip">
            <div class="ss-card blue">
                <div class="ss-icon blue"><i class="ti ti-clipboard-list"></i></div>
                <div class="ss-body"><div class="val"><%= cnt %></div><div class="lbl">Total Entries</div></div>
            </div>
            <div class="ss-card emerald">
                <div class="ss-icon emerald"><i class="ti ti-droplet-filled"></i></div>
                <div class="ss-body"><div class="val"><%= String.format("%.2f",totalQty) %> L</div><div class="lbl">Total Qty</div></div>
            </div>
            <div class="ss-card amber">
                <div class="ss-icon amber"><i class="ti ti-chart-dots"></i></div>
                <div class="ss-body"><div class="val"><%= String.format("%.2f",avgFat) %>%</div><div class="lbl">Avg FAT</div></div>
            </div>
            <div class="ss-card teal">
                <div class="ss-icon teal"><i class="ti ti-chart-dots-2"></i></div>
                <div class="ss-body"><div class="val"><%= String.format("%.2f",avgSnf) %>%</div><div class="lbl">Avg SNF</div></div>
            </div>
            <div class="ss-card violet">
                <div class="ss-icon violet"><i class="ti ti-coin-rupee"></i></div>
                <div class="ss-body"><div class="val">₹<%= String.format("%.2f",totalAmt) %></div><div class="lbl">Total Amount</div></div>
            </div>
        </div>

        <!-- ── ENTRIES HEADING ── -->
        <div class="sec-row">
            <div class="sec-title"><i class="ti ti-list-details"></i>Collection Entries</div>
            <div class="sec-tag">☀️ <%= morningCnt %> Morning &nbsp;·&nbsp; 🌙 <%= eveningCnt %> Evening</div>
        </div>

        <!-- ── ENTRY CARDS ── -->
        <% if(entries.isEmpty()) { %>
        <div class="empty-state">
            <i class="ti ti-database-off"></i>
            <div class="etitle">No entries found</div>
            <p>No collection records for <%= farmerName %> in the selected date range.</p>
            <a href="milkcollectionReport.jsp?view=datewise"><i class="ti ti-arrow-left"></i>Back to Report</a>
        </div>
        <% } else { %>
        <div class="cards-grid">
        <% for(Collection c : entries) {
               boolean isMorning = "MORNING".equalsIgnoreCase(c.getShift());
               boolean isCow     = "COW".equalsIgnoreCase(c.getMilkType());
               String shiftClass = isMorning ? "morning-card" : "evening-card";
               String hdrClass   = isMorning ? "morning-bg"   : "evening-bg";
               String badgeClass = isMorning ? "morning"       : "evening";
               String timeStr    = c.getCreatedAt() != null ? timeFmt.format(c.getCreatedAt()) : "—";
        %>
        <div class="entry-card <%= shiftClass %>">

            <!-- compact header: badge + datetime -->
            <div class="ec-header <%= hdrClass %>">
                <span class="ec-shift-badge <%= badgeClass %>">
                    <i class="ti ti-<%= isMorning?"sun":"moon" %>"></i>
                    <%= isMorning ? "Morning" : "Evening" %>
                </span>
                <span class="ec-date"><%= timeStr %></span>
            </div>

            <!-- two-column body -->
            <div class="ec-body">
                <!-- LEFT -->
                <div class="ec-col">
                    <div class="ec-field">
                        <div class="ec-label">Date Time</div>
                        <div class="ec-value"><%= timeStr %></div>
                    </div>
                    <div class="ec-field">
                        <div class="ec-label">Quantity (Ltr)</div>
                        <div class="ec-value"><%= String.format("%.2f",c.getQuantity()) %></div>
                    </div>
                    <div class="ec-field">
                        <div class="ec-label">Rate Per Ltr</div>
                        <div class="ec-value"><%= String.format("%.2f",c.getRatePerLtr()) %></div>
                    </div>
                </div>

                <!-- RIGHT -->
                <div class="ec-col">
                    <div class="ec-field">
                        <div class="ec-label">Shift – Cattle Type</div>
                        <div class="ec-value">
                            <%= isMorning ? "Morning" : "Evening" %> –
                            <%= isCow ? "C" : "B" %>
                            <span class="cattle-pill <%= isCow?"cow":"buf" %>">
                                <%= isCow ? "🐄" : "🐃" %>
                            </span>
                        </div>
                    </div>
                    <div class="ec-field">
                        <div class="ec-label">Fat(%) – Snf(%)</div>
                        <div class="fat-snf-row">
                            <span class="fat-snf-val"><%= String.format("%.1f",c.getFat()) %></span>
                            <span class="fat-snf-sep">–</span>
                            <span class="fat-snf-val"><%= String.format("%.1f",c.getSnf()) %></span>
                        </div>
                    </div>
                    <div class="ec-field">
                        <div class="ec-label">Amount</div>
                        <div class="ec-value amount"><%= String.format("%.2f",c.getAmount()) %></div>
                    </div>
                </div>
            </div>

        </div>
        <% } %>
        </div>
        <% } %>

    </div><!-- /content -->

    <div class="foot">
        <div class="foot-logo">Milk<span>Mitra</span> © 2026. All Rights Reserved.</div>
        <span>Session: <strong><%= username %></strong> · <%= role %></span>
    </div>
</div>

<script>
setTimeout(function(){
    var alerts = document.querySelectorAll('.alert-auto');
    alerts.forEach(function(a){ a.style.transition='opacity .5s'; a.style.opacity='0'; setTimeout(function(){a.remove();},500); });
}, 4000);
</script>
</body>
</html>
