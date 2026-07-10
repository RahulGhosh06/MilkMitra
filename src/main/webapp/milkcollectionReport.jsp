<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="com.milkmitra.model.Collection" %>
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

    List<Collection> collections = (List<Collection>) request.getAttribute("collections");
    if(collections == null) collections = new java.util.ArrayList<>();

    String currentView = (String) request.getAttribute("currentView");
    if(currentView == null) currentView = request.getParameter("view");
    if(currentView == null) currentView = "today";

    String selectedShift = (String) request.getAttribute("selectedShift");

    List<Report> reports = (List<Report>) request.getAttribute("reports");
    String fromDateVal   = request.getParameter("fromDate");
    String toDateVal     = request.getParameter("toDate");
    if(fromDateVal == null) fromDateVal = LocalDate.now().minusDays(10).toString();
    if(toDateVal   == null) toDateVal   = LocalDate.now().toString();

    String errorMsg = (String) session.getAttribute("errorMsg");
    if(errorMsg != null) session.removeAttribute("errorMsg");

    double totalLtr=0, cowLtr=0, bufLtr=0, totalAmt=0, fatSum=0, snfSum=0;
    double morningLtr=0, eveningLtr=0;
    int    cowCnt=0, bufCnt=0;
    java.util.Set<String> farmerSet = new java.util.HashSet<>();
  
    for(Collection c : collections){
        totalLtr += c.getQuantity();
        totalAmt += c.getAmount();
        fatSum   += c.getFat();
        snfSum   += c.getSnf();
        farmerSet.add(c.getFarmerCode());
        if("C".equalsIgnoreCase(c.getMilkType())){
            cowLtr += c.getQuantity();
            cowCnt++;
        }
        else if("B".equalsIgnoreCase(c.getMilkType())){
            bufLtr += c.getQuantity();
            bufCnt++;
        }
        if("MORNING".equalsIgnoreCase(c.getShift())) morningLtr+=c.getQuantity();
        else eveningLtr+=c.getQuantity();
    }
    int    cnt       = collections.size();
    double avgFat    = cnt==0 ? 0 : fatSum/cnt;
    double avgSnf    = cnt==0 ? 0 : snfSum/cnt;
    int    totalFarmers = farmerSet.size();
    double morningPct   = totalLtr==0 ? 0 : (morningLtr*100)/totalLtr;
    double eveningPct   = totalLtr==0 ? 0 : (eveningLtr*100)/totalLtr;
    double cowPct       = totalLtr==0 ? 0 : (cowLtr*100)/totalLtr;
    double bufPct       = totalLtr==0 ? 0 : (bufLtr*100)/totalLtr;

    double drTotalLtr=0, drTotalAmt=0;
    int    drRows=0;
    if(reports!=null){ drRows=reports.size(); for(Report r:reports){ drTotalLtr+=r.getTotalQty(); drTotalAmt+=r.getTotalAmount(); } }

    String todayStr   = LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")).format(DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy"));
    String todayShort = LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")).format(DateTimeFormatter.ofPattern("dd MMM yyyy"));

    boolean isMorning = "morning".equals(currentView);
    boolean isEvening = "evening".equals(currentView);
    boolean isShift   = isMorning || isEvening;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Collection Report</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    /* Brand palette */
    --navy:#0a1628;
    --navy-mid:#1e3a5f;
    --blue:#2563eb;
    --blue-dark:#1d4ed8;
    --blue-lt:#eff6ff;
    --blue-mid:#dbeafe;

    /* Accent ramps */
    --emerald:#059669;
    --emerald-lt:#ecfdf5;
    --emerald-mid:#a7f3d0;
    --teal:#0d9488;
    --teal-lt:#f0fdfa;
    --teal-mid:#99f6e4;
    --amber:#d97706;
    --amber-lt:#fffbeb;
    --amber-mid:#fde68a;
    --violet:#7c3aed;
    --violet-lt:#f5f3ff;
    --violet-mid:#ddd6fe;
    --rose:#e11d48;
    --rose-lt:#fff1f2;
    --rose-mid:#fecdd3;
    --cyan:#0891b2;
    --cyan-lt:#ecfeff;
    --cyan-mid:#a5f3fc;
    --orange:#ea580c;
    --orange-lt:#fff7ed;
    --orange-mid:#fed7aa;

    /* Neutrals */
    --muted:#64748b;
    --muted-light:#94a3b8;
    --border:#e2e8f0;
    --border-dark:#cbd5e1;
    --bg:#f1f5f9;
    --bg-card:#f8fafc;
    --white:#ffffff;
    --text-primary:#0f172a;
    --text-secondary:#475569;

    /* Sidebar */
    --sb:252px;
    --sb-bg:#0f1f3d;
    --sb-hover:rgba(255,255,255,.07);
    --sb-active:rgba(99,179,237,.15);
    --sb-text:rgba(255,255,255,.65);
    --sb-text-active:#93c5fd;

    /* Misc */
    --radius:14px;
    --radius-sm:8px;
    --shadow-sm:0 1px 3px rgba(0,0,0,.07),0 1px 2px rgba(0,0,0,.05);
    --shadow-md:0 4px 16px rgba(0,0,0,.08),0 2px 6px rgba(0,0,0,.04);
    --shadow-lg:0 10px 32px rgba(0,0,0,.1),0 4px 12px rgba(0,0,0,.06);
}

body{
    font-family:'Inter',sans-serif;
    background:var(--bg);
    color:var(--text-primary);
    display:flex;
    min-height:100vh;
    font-size:14px;
    line-height:1.5;
}

/* ══════════════════════════════════════
   SIDE NAV — deep navy with blue accents
══════════════════════════════════════ */
.sidenav{
    width:var(--sb);
    flex-shrink:0;
    background:var(--sb-bg);
    display:flex;
    flex-direction:column;
    position:fixed;
    top:0;left:0;
    height:100vh;
    z-index:100;
    border-right:1px solid rgba(255,255,255,.06);
}
.sn-brand{
    padding:22px 20px 16px;
    border-bottom:1px solid rgba(255,255,255,.08);
    background:linear-gradient(135deg,#0f2040 0%,#1a3a6e 100%);
}
.sn-brand h1{
    font-family:'DM Serif Display',serif;
    font-size:24px;
    color:#fff;
    letter-spacing:-.3px;
}
.sn-brand h1 span{color:#60a5fa;}
.sn-brand p{
    font-size:10px;
    color:rgba(255,255,255,.4);
    letter-spacing:1px;
    text-transform:uppercase;
    margin-top:3px;
}
/* Online indicator */
.sn-brand-dot{
    display:inline-block;width:6px;height:6px;border-radius:50%;
    background:#34d399;margin-right:6px;vertical-align:middle;
    box-shadow:0 0 0 2px rgba(52,211,153,.25);
}

.sn-nav{
    flex:1;overflow-y:auto;padding:14px 10px 0;
    display:flex;flex-direction:column;gap:1px;
}
.sn-nav::-webkit-scrollbar{width:3px;}
.sn-nav::-webkit-scrollbar-thumb{background:rgba(255,255,255,.12);border-radius:4px;}

.sn-label{
    font-size:9px;font-weight:700;
    color:rgba(255,255,255,.3);
    text-transform:uppercase;letter-spacing:1px;
    padding:12px 10px 5px;
}
.sn-item{
    display:flex;align-items:center;gap:9px;
    padding:9px 12px;border-radius:var(--radius-sm);
    text-decoration:none;font-size:12.5px;font-weight:500;
    color:var(--sb-text);
    transition:background .15s,color .15s;
}
.sn-item:hover{background:var(--sb-hover);color:#e2e8f0;}
.sn-item.active{
    background:var(--sb-active);
    color:var(--sb-text-active);
    font-weight:600;
}
.sn-item i{font-size:16px;flex-shrink:0;opacity:.8;}
.sn-item.active i{opacity:1;}

.sn-pill{
    margin-left:auto;font-size:9px;
    background:rgba(255,255,255,.08);
    color:rgba(255,255,255,.4);
    padding:2px 7px;border-radius:10px;
    border:1px solid rgba(255,255,255,.1);
    font-weight:600;letter-spacing:.3px;
}
.sn-item.active .sn-pill{
    background:rgba(99,179,237,.2);
    color:#93c5fd;
    border-color:rgba(99,179,237,.3);
}

.sn-divider{height:1px;background:rgba(255,255,255,.06);margin:8px 10px;}

.sn-foot{padding:12px;border-top:1px solid rgba(255,255,255,.07);}
.sn-user{
    display:flex;align-items:center;gap:10px;
    padding:10px 12px;
    background:rgba(255,255,255,.05);
    border:1px solid rgba(255,255,255,.08);
    border-radius:var(--radius-sm);
    margin-bottom:8px;
}
.sn-av{
    width:32px;height:32px;border-radius:50%;
    background:linear-gradient(135deg,#3b82f6,#1d4ed8);
    color:#fff;display:flex;align-items:center;justify-content:center;
    font-weight:700;font-size:13px;flex-shrink:0;
    box-shadow:0 0 0 2px rgba(59,130,246,.3);
}
.sn-meta .name{font-size:12px;font-weight:600;color:#e2e8f0;}
.sn-meta .role{
    font-size:10px;color:rgba(255,255,255,.35);
    text-transform:capitalize;margin-top:1px;
}
.lo-link{
    display:flex;align-items:center;justify-content:center;gap:6px;
    padding:8px;border-radius:var(--radius-sm);
    background:rgba(239,68,68,.1);
    border:1px solid rgba(239,68,68,.2);
    color:#fca5a5;font-size:12px;font-weight:600;
    text-decoration:none;transition:background .15s,border-color .15s;
}
.lo-link:hover{background:rgba(239,68,68,.18);border-color:rgba(239,68,68,.35);}
.lo-link i{font-size:15px;}

/* ══════════════════════════════════════
   MAIN LAYOUT
══════════════════════════════════════ */
.main{margin-left:var(--sb);flex:1;display:flex;flex-direction:column;min-height:100vh;}

/* ══════════════════════════════════════
   TOPBAR
══════════════════════════════════════ */
.topbar{
    background:var(--white);
    border-bottom:1px solid var(--border);
    padding:0 28px;height:64px;
    display:flex;align-items:center;justify-content:space-between;
    position:sticky;top:0;z-index:50;
    box-shadow:var(--shadow-sm);
}
.tb-left{display:flex;align-items:center;gap:12px;}
.tb-crumb{
    display:flex;align-items:center;gap:6px;
    font-size:11.5px;color:var(--muted);
}
.tb-crumb a{color:var(--muted);text-decoration:none;}
.tb-crumb a:hover{color:var(--blue);}
.tb-crumb .sep{color:var(--border-dark);}
.tb-divider-v{width:1px;height:24px;background:var(--border);}
.tb-title-group h2{
    font-family:'DM Serif Display',serif;
    font-size:17px;color:var(--navy);
    line-height:1.2;
}
.tb-title-group p{font-size:11px;color:var(--muted);margin-top:1px;}
.tb-right{display:flex;align-items:center;gap:8px;}
.tb-date{
    font-size:11px;color:var(--muted);
    background:var(--bg);padding:5px 13px;
    border-radius:20px;border:1px solid var(--border);
    font-weight:500;
}
.tb-btn{
    display:flex;align-items:center;gap:5px;
    padding:7px 16px;
    background:linear-gradient(135deg,var(--blue) 0%,var(--blue-dark) 100%);
    color:#fff;border:none;border-radius:var(--radius-sm);
    font-size:12px;font-weight:600;font-family:'Inter',sans-serif;
    cursor:pointer;text-decoration:none;
    transition:opacity .15s,transform .1s;
    box-shadow:0 2px 8px rgba(37,99,235,.3);
}
.tb-btn:hover{opacity:.9;transform:translateY(-1px);}
.tb-btn i{font-size:15px;}
.tb-icon{
    width:36px;height:36px;
    background:var(--bg);border:1px solid var(--border);
    border-radius:var(--radius-sm);
    display:flex;align-items:center;justify-content:center;
    color:var(--muted);cursor:pointer;text-decoration:none;
    transition:all .15s;
}
.tb-icon:hover{background:var(--blue-lt);border-color:var(--blue-mid);color:var(--blue);}
.tb-icon i{font-size:17px;}

/* ══════════════════════════════════════
   CONTENT AREA
══════════════════════════════════════ */
.content{padding:24px 28px;flex:1;display:flex;flex-direction:column;gap:20px;}

/* ══════════════════════════════════════
   ERROR BANNER
══════════════════════════════════════ */
.err-banner{
    background:var(--rose-lt);border:1px solid var(--rose-mid);
    border-radius:var(--radius);padding:13px 16px;
    display:flex;align-items:center;gap:10px;
    color:var(--rose);font-size:13px;font-weight:500;
}
.err-banner i{font-size:18px;flex-shrink:0;}

/* ══════════════════════════════════════
   SECTION ROW
══════════════════════════════════════ */
.sec-row{display:flex;align-items:center;justify-content:space-between;}
.sec-title{
    font-size:13px;font-weight:700;color:var(--navy);
    display:flex;align-items:center;gap:8px;
    letter-spacing:-.1px;
}
.sec-title i{color:var(--muted);font-size:16px;}
.sec-tag{
    font-size:11px;
    background:linear-gradient(135deg,var(--blue-lt),#e0f2fe);
    color:var(--blue-dark);padding:4px 13px;
    border-radius:20px;border:1px solid var(--blue-mid);
    font-weight:600;
}

/* ══════════════════════════════════════
   METRIC CARDS  — coloured top bar + icon
══════════════════════════════════════ */
.grid-5{display:grid;grid-template-columns:repeat(5,1fr);gap:12px;}
.grid-4{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;}
.grid-3{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px;}

.mc{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:var(--radius);
    padding:16px;
    display:flex;align-items:flex-start;gap:13px;
    position:relative;overflow:hidden;
    transition:box-shadow .2s,transform .2s;
    box-shadow:var(--shadow-sm);
}
.mc:hover{box-shadow:var(--shadow-md);transform:translateY(-2px);}

/* coloured left accent bar */
.mc::before{
    content:'';position:absolute;left:0;top:0;bottom:0;width:4px;
    border-radius:var(--radius) 0 0 var(--radius);
}
.mc.blue::before{background:linear-gradient(180deg,#3b82f6,#1d4ed8);}
.mc.emerald::before{background:linear-gradient(180deg,#10b981,#047857);}
.mc.amber::before{background:linear-gradient(180deg,#f59e0b,#b45309);}
.mc.teal::before{background:linear-gradient(180deg,#14b8a6,#0f766e);}
.mc.violet::before{background:linear-gradient(180deg,#8b5cf6,#6d28d9);}
.mc.cyan::before{background:linear-gradient(180deg,#06b6d4,#0e7490);}
.mc.rose::before{background:linear-gradient(180deg,#f43f5e,#be123c);}
.mc.orange::before{background:linear-gradient(180deg,#f97316,#c2410c);}

/* subtle background tint behind icon area */
.mc.blue    {background:linear-gradient(135deg,#fff 60%,#eff6ff);}
.mc.emerald {background:linear-gradient(135deg,#fff 60%,#ecfdf5);}
.mc.amber   {background:linear-gradient(135deg,#fff 60%,#fffbeb);}
.mc.teal    {background:linear-gradient(135deg,#fff 60%,#f0fdfa);}
.mc.violet  {background:linear-gradient(135deg,#fff 60%,#f5f3ff);}
.mc.cyan    {background:linear-gradient(135deg,#fff 60%,#ecfeff);}
.mc.rose    {background:linear-gradient(135deg,#fff 60%,#fff1f2);}
.mc.orange  {background:linear-gradient(135deg,#fff 60%,#fff7ed);}

.mi{
    width:44px;height:44px;border-radius:10px;
    display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.mi i{font-size:22px;}
.mi.blue  {background:var(--blue-mid);   color:var(--blue-dark);}
.mi.emerald{background:#bbf7d0;          color:#065f46;}
.mi.amber {background:var(--amber-mid);  color:#92400e;}
.mi.teal  {background:var(--teal-mid);   color:#134e4a;}
.mi.violet{background:var(--violet-mid); color:#4c1d95;}
.mi.cyan  {background:var(--cyan-mid);   color:#164e63;}
.mi.rose  {background:var(--rose-mid);   color:#881337;}
.mi.orange{background:var(--orange-mid); color:#7c2d12;}

.mc-body{flex:1;padding-left:4px;}
.mc-body .val{
    font-size:22px;font-weight:800;
    color:var(--text-primary);line-height:1;
    letter-spacing:-.5px;
}
.mc-body .lbl{font-size:11.5px;color:var(--text-secondary);margin-top:5px;font-weight:600;}
.mc-body .sub{font-size:10.5px;color:var(--muted-light);margin-top:2px;}

/* ══════════════════════════════════════
   TWO-COL PANELS
══════════════════════════════════════ */
.two-col{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
.panel{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:var(--radius);
    overflow:hidden;
    box-shadow:var(--shadow-sm);
}
.panel-head{
    display:flex;align-items:center;gap:12px;
    padding:15px 18px;
    border-bottom:1px solid var(--border);
    background:var(--bg-card);
}
.panel-icon{
    width:36px;height:36px;border-radius:9px;
    display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.panel-icon i{font-size:19px;}
.panel-icon.teal   {background:var(--teal-mid);   color:#134e4a;}
.panel-icon.blue   {background:var(--blue-mid);   color:var(--blue-dark);}
.panel-icon.emerald{background:#bbf7d0;            color:#065f46;}
.panel-icon.violet {background:var(--violet-mid); color:#4c1d95;}
.panel-icon.amber  {background:var(--amber-mid);  color:#92400e;}
.panel-title{font-size:13.5px;font-weight:700;color:var(--navy);}
.panel-sub{font-size:11px;color:var(--muted);margin-top:2px;}
.panel-body{padding:18px;}

/* ══════════════════════════════════════
   BAR CHART ROWS
══════════════════════════════════════ */
.bar-section-label{
    font-size:10.5px;font-weight:700;
    color:var(--muted);text-transform:uppercase;letter-spacing:.5px;
    margin-bottom:10px;
}
.bar-row{display:flex;align-items:center;gap:10px;margin-bottom:10px;}
.bar-row:last-child{margin-bottom:0;}
.bar-emoji{font-size:14px;width:22px;flex-shrink:0;}
.bar-label{font-size:12px;color:var(--text-secondary);width:58px;flex-shrink:0;font-weight:500;}
.bar-track{
    flex:1;height:8px;
    background:var(--bg);border-radius:6px;overflow:hidden;
    border:1px solid var(--border);
}
.bar-fill{height:100%;border-radius:6px;}
.bar-val{font-size:12px;font-weight:700;color:var(--text-primary);width:76px;text-align:right;flex-shrink:0;}

/* bar fill gradients */
.bar-fill.teal   {background:linear-gradient(90deg,#14b8a6,#0d9488);}
.bar-fill.blue   {background:linear-gradient(90deg,#3b82f6,#2563eb);}
.bar-fill.emerald{background:linear-gradient(90deg,#10b981,#059669);}
.bar-fill.amber  {background:linear-gradient(90deg,#f59e0b,#d97706);}

/* ══════════════════════════════════════
   SHIFT PANEL (big table card)
══════════════════════════════════════ */
.shift-panel{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:var(--radius);
    overflow:hidden;
    box-shadow:var(--shadow-sm);
}
.sp-head{
    display:flex;align-items:center;justify-content:space-between;
    padding:15px 20px;border-bottom:1px solid var(--border);
    background:var(--bg-card);
}
.sp-left{display:flex;align-items:center;gap:12px;}
.sp-icon{
    width:38px;height:38px;border-radius:9px;
    display:flex;align-items:center;justify-content:center;flex-shrink:0;
}
.sp-icon i{font-size:19px;}
.sp-icon.teal   {background:var(--teal-mid);   color:#134e4a;}
.sp-icon.blue   {background:var(--blue-mid);   color:var(--blue-dark);}
.sp-icon.emerald{background:#bbf7d0;            color:#065f46;}
.sp-icon.violet {background:var(--violet-mid); color:#4c1d95;}
.sp-title{font-size:13.5px;font-weight:700;color:var(--navy);}
.sp-sub{font-size:11px;color:var(--muted);margin-top:2px;}
.sp-right{display:flex;align-items:center;gap:14px;}
.sp-stat{text-align:right;}
.sp-stat .sv{font-size:15px;font-weight:800;color:var(--text-primary);}
.sp-stat .sl{font-size:10px;color:var(--muted);font-weight:500;margin-top:1px;}
.sp-divider{width:1px;height:30px;background:var(--border);}

/* ══════════════════════════════════════
   TABLE
══════════════════════════════════════ */
.tbl-wrap{overflow-x:auto;}
table{width:100%;border-collapse:collapse;font-size:13px;}
thead tr{background:linear-gradient(90deg,#f8fafc,#f1f5f9);}
thead th{
    padding:10px 14px;font-size:10.5px;font-weight:700;
    color:var(--text-secondary);text-transform:uppercase;
    letter-spacing:.5px;text-align:left;
    border-bottom:2px solid var(--border);white-space:nowrap;
}
tbody tr{border-bottom:1px solid var(--border);transition:background .12s;}
tbody tr:hover{background:#f8faff;}
tbody tr:last-child{border-bottom:none;}
tbody td{padding:10px 14px;vertical-align:middle;white-space:nowrap;}
.fc{font-weight:700;color:var(--blue);}
.fn{font-weight:600;color:var(--text-primary);}
.idx-col{color:var(--muted-light);font-size:11px;font-weight:500;}

/* Pill badges */
.pill{
    display:inline-flex;align-items:center;gap:4px;
    padding:3px 10px;border-radius:20px;
    font-size:11px;font-weight:700;letter-spacing:.2px;
}
.pill.cow{
    background:var(--emerald-lt);color:#065f46;
    border:1px solid #6ee7b7;
}
.pill.buf{
    background:var(--amber-lt);color:#92400e;
    border:1px solid var(--amber-mid);
}
.pill.morning{
    background:var(--teal-lt);color:#134e4a;
    border:1px solid var(--teal-mid);
}
.pill.evening{
    background:var(--violet-lt);color:#4c1d95;
    border:1px solid var(--violet-mid);
}

/* Numeric cells */
.num{font-weight:700;}
.num.emerald{color:#065f46;}
.num.amber  {color:#92400e;}
.num.blue   {color:var(--blue-dark);}
.num.violet {color:#5b21b6;}
.num.teal   {color:#0f766e;}
.num.muted  {color:var(--muted);}

/* Tfoot */
.tfoot-row td{
    background:linear-gradient(90deg,#f1f5f9,#e8f0fe);
    font-weight:700;
    border-top:2px solid var(--border-dark);
}

/* ══════════════════════════════════════
   EMPTY STATE
══════════════════════════════════════ */
.empty{padding:48px 20px;text-align:center;color:var(--muted);}
.empty i{font-size:40px;opacity:.18;display:block;margin-bottom:10px;}
.empty .etitle{font-size:14px;font-weight:700;color:var(--text-secondary);margin-bottom:4px;}
.empty p{font-size:12.5px;}
.empty a{
    display:inline-flex;align-items:center;gap:5px;margin-top:14px;
    padding:8px 18px;
    background:linear-gradient(135deg,var(--blue),var(--blue-dark));
    color:#fff;border-radius:var(--radius-sm);font-size:12px;font-weight:600;
    text-decoration:none;box-shadow:0 2px 8px rgba(37,99,235,.25);
    transition:opacity .15s;
}
.empty a:hover{opacity:.88;}

/* ══════════════════════════════════════
   DATE-WISE FORM
══════════════════════════════════════ */
.dw-wrap{display:flex;gap:20px;align-items:flex-start;}
.dw-form-card{
    background:var(--white);
    border:1px solid var(--border);
    border-radius:var(--radius);
    padding:24px;
    width:320px;flex-shrink:0;
    box-shadow:var(--shadow-sm);
}
.dw-results{flex:1;min-width:0;}
.dw-form-title{
    font-size:14px;font-weight:700;color:var(--navy);
    display:flex;align-items:center;gap:8px;
    margin-bottom:20px;
    padding-bottom:14px;
    border-bottom:1px solid var(--border);
}
.dw-form-title i{font-size:17px;color:var(--blue);}
.fg{margin-bottom:16px;}
.fg label{
    display:block;font-size:11px;font-weight:700;
    color:var(--text-secondary);text-transform:uppercase;
    letter-spacing:.4px;margin-bottom:7px;
}
.inp-wrap{position:relative;display:flex;align-items:center;}
.inp-wrap i{
    position:absolute;left:11px;font-size:15px;
    color:var(--muted-light);pointer-events:none;
}
.inp-wrap input[type=date]{
    width:100%;padding:9px 12px 9px 36px;
    font-family:'Inter',sans-serif;font-size:13px;
    color:var(--text-primary);
    background:var(--bg);border:1.5px solid var(--border);
    border-radius:var(--radius-sm);outline:none;
    transition:border-color .18s,background .18s,box-shadow .18s;
}
.inp-wrap input[type=date]:focus{
    border-color:var(--blue);background:var(--white);
    box-shadow:0 0 0 3px rgba(37,99,235,.1);
}
.gen-btn{
    width:100%;padding:11px;
    background:linear-gradient(135deg,var(--blue),var(--blue-dark));
    color:#fff;border:none;border-radius:var(--radius-sm);
    font-family:'Inter',sans-serif;font-size:13px;font-weight:600;
    cursor:pointer;display:flex;align-items:center;justify-content:center;gap:6px;
    transition:opacity .18s,transform .1s;margin-top:8px;
    box-shadow:0 3px 10px rgba(37,99,235,.3);
}
.gen-btn:hover{opacity:.9;transform:translateY(-1px);}
.gen-btn i{font-size:15px;}

/* Date-wise summary chips */
.dw-summary{display:flex;gap:10px;margin-bottom:14px;flex-wrap:wrap;}
.dw-chip{
    background:var(--white);border:1px solid var(--border);
    border-radius:10px;padding:11px 16px;
    box-shadow:var(--shadow-sm);
    min-width:110px;
}
.dw-chip .cv{font-size:18px;font-weight:800;color:var(--text-primary);letter-spacing:-.3px;}
.dw-chip .cl{font-size:10.5px;color:var(--muted);margin-top:3px;font-weight:600;text-transform:uppercase;letter-spacing:.3px;}
.dw-chip.emerald{border-left:3px solid var(--emerald);}
.dw-chip.emerald .cv{color:#065f46;}
.dw-chip.blue   {border-left:3px solid var(--blue);}
.dw-chip.blue .cv{color:var(--blue-dark);}
.dw-chip.violet {border-left:3px solid var(--violet);}
.dw-chip.violet .cv{color:#5b21b6;}

/* ══════════════════════════════════════
   UNDER CONSTRUCTION
══════════════════════════════════════ */
.wip{
    background:var(--white);border:1px solid var(--border);
    border-radius:var(--radius);padding:52px 24px;
    text-align:center;color:var(--muted);
    box-shadow:var(--shadow-sm);
}
.wip i{font-size:42px;opacity:.2;display:block;margin-bottom:12px;}
.wip .wip-title{font-size:15px;font-weight:700;color:var(--text-secondary);margin-bottom:5px;}
.wip p{font-size:13px;}

/* ══════════════════════════════════════
   STATUS RIBBON (shift indicator)
══════════════════════════════════════ */
.shift-ribbon{
    display:inline-flex;align-items:center;gap:6px;
    padding:4px 12px;border-radius:20px;
    font-size:11px;font-weight:700;margin-left:8px;
}
.shift-ribbon.morning{background:var(--teal-lt);color:#134e4a;border:1px solid var(--teal-mid);}
.shift-ribbon.evening{background:var(--violet-lt);color:#4c1d95;border:1px solid var(--violet-mid);}

/* ══════════════════════════════════════
   FOOTER
══════════════════════════════════════ */
.foot{
    padding:14px 28px;border-top:1px solid var(--border);
    font-size:11px;color:var(--muted);
    background:var(--white);
    display:flex;justify-content:space-between;align-items:center;
}
.foot-logo{font-family:'DM Serif Display',serif;font-size:13px;color:var(--navy);}
.foot-logo span{color:var(--blue);}

/* ══════════════════════════════════════
   PRINT
══════════════════════════════════════ */
/* ── VIEW DETAILS BUTTON ── */
.detail-btn{
    display:inline-flex;align-items:center;gap:5px;
    padding:5px 12px;border-radius:7px;
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

@media print{
    .sidenav,.topbar,.foot,.tb-btn,.gen-btn,.tb-icon{display:none!important;}
    .main{margin-left:0;}
    .content{padding:12px;}
    .mc{box-shadow:none;}
    .shift-panel,.panel{box-shadow:none;}
}
</style>
</head>
<body>

<!-- ════════════════ SIDE NAV ════════════════ -->
<aside class="sidenav">
    <div class="sn-brand">
        <h1>Milk<span>Mitra</span></h1>
        <p><span class="sn-brand-dot"></span>Collection Reports</p>
    </div>
    <nav class="sn-nav">
        <div class="sn-label">Today's View</div>
        <a href="milkcollectionReportServlet?view=today"
           class="sn-item <%= "today".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-report-analytics"></i>All Collections
            <span class="sn-pill">Today</span>
        </a>
        <a href="ShiftWiseCollectionServlet?shift=MORNING&view=morning"
           class="sn-item <%= "morning".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-sun"></i>Morning Shift
            <span class="sn-pill">AM</span>
        </a>
        <a href="ShiftWiseCollectionServlet?shift=EVENING&view=evening"
           class="sn-item <%= "evening".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-moon"></i>Evening Shift
            <span class="sn-pill">PM</span>
        </a>
        <div class="sn-divider"></div>
        <div class="sn-label">Analysis</div>
        <a href="milkcollectionReport.jsp?view=datewise"
           class="sn-item <%= "datewise".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-calendar-search"></i>Date-wise Report
        </a>
        <a href="milkcollectionReport.jsp?view=farmerwise"
           class="sn-item <%= "farmerwise".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-users"></i>Farmer-wise Report
        </a>
        <a href="milkcollectionReport.jsp?view=monthly"
           class="sn-item <%= "monthly".equals(currentView) ? "active" : "" %>">
            <i class="ti ti-calendar-stats"></i>Monthly Report
        </a>
        <div class="sn-divider"></div>
        <div class="sn-label">Navigation</div>
        <a href="AdminDashboardServlet?view=milkCollection" class="sn-item">
            <i class="ti ti-plus"></i>New Entry
        </a>
        <a href="AdminDashboardServlet" class="sn-item">
            <i class="ti ti-home"></i>Dashboard
        </a>
    </nav>
    <div class="sn-foot">
        <div class="sn-user">
            <div class="sn-av"><%= username.substring(0,1).toUpperCase() %></div>
            <div class="sn-meta">
                <div class="name"><%= username %></div>
                <div class="role"><%= role.toLowerCase() %></div>
            </div>
        </div>
        <a href="Logout" class="lo-link"><i class="ti ti-logout"></i>Log Out</a>
    </div>
</aside>

<!-- ════════════════ MAIN ════════════════ -->
<div class="main">
    <div class="topbar">
        <div class="tb-left">
            <%
                String pageTitle = "today".equals(currentView)    ? "Today's Collection Report"
                                 : "morning".equals(currentView)  ? "Morning Shift Report"
                                 : "evening".equals(currentView)  ? "Evening Shift Report"
                                 : "datewise".equals(currentView) ? "Date-wise Collection Report"
                                 : "Collection Report";
                String pageSub  = ("today".equals(currentView)||isShift)
                                 ? todayShort + " · " + (isShift ? (isMorning?"Morning":"Evening")+" shift":"All shifts")
                                 : "Milk Collection Reports";
            %>
            <div class="tb-crumb">
                <a href="AdminDashboard.jsp"><i class="ti ti-home" style="font-size:13px;vertical-align:-1px;"></i></a>
                <span class="sep">/</span>
                <span>Reports</span>
                <span class="sep">/</span>
                <span style="color:var(--text-primary);font-weight:600;"><%= pageTitle %></span>
            </div>
            <div class="tb-divider-v"></div>
            <div class="tb-title-group">
                <h2><%= pageTitle %></h2>
                <p><%= pageSub %></p>
            </div>
        </div>
        <div class="tb-right">
            <div class="tb-date" id="dateStr"></div>
            <% if("today".equals(currentView)||isShift) { %>
            <%
				String refreshUrl = "milkcollectionReportServlet?view=today";

				if(isMorning)
				{
    				refreshUrl = "ShiftWiseCollectionServlet?shift=MORNING&view=morning";
    			}
				else if(isEvening)
				{
					refreshUrl = "ShiftWiseCollectionServlet?shift=EVENING&view=evening";
				}
				else if("datewise".equals(currentView))
				{
    				refreshUrl = "milkcollectionReport.jsp?view=datewise";
				}
			%>

			<a href="<%= refreshUrl %>"class="tb-icon" title="Refresh">
    			<i class="ti ti-refresh"></i>
			</a>
            <button class="tb-icon" onclick="window.print()" title="Print"><i class="ti ti-printer"></i></button>
            <% } %>
            <a href="AdminDashboardServlet?view=milkCollection" class="tb-btn"><i class="ti ti-plus"></i>New Entry</a>
        </div>
    </div>

    <div class="content">

        <!-- ERROR BANNER -->
        <% if(errorMsg!=null && !errorMsg.isEmpty()) { %>
        <div class="err-banner">
            <i class="ti ti-alert-circle"></i><%= errorMsg %>
        </div>
        <% } %>

        <!-- ════════════════════════════════════
             VIEW: TODAY
        ════════════════════════════════════ -->
        <% if("today".equals(currentView)) { %>

        <div class="sec-row">
            <div class="sec-title"><i class="ti ti-calendar-today"></i>Day Summary</div>
            <div class="sec-tag">📅 <%= todayShort %></div>
        </div>

        <div class="grid-5">
            <div class="mc teal">
                <div class="mi teal"><i class="ti ti-clipboard-list"></i></div>
                <div class="mc-body">
                    <div class="val"><%= cnt %></div>
                    <div class="lbl">Total Entries</div>
                    <div class="sub"><%= totalFarmers %> farmers active</div>
                </div>
            </div>
            <div class="mc blue">
                <div class="mi blue"><i class="ti ti-droplet-filled"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",totalLtr) %> L</div>
                    <div class="lbl">Total Litres</div>
                    <div class="sub">Both shifts combined</div>
                </div>
            </div>
            <div class="mc emerald">
                <div class="mi emerald"><i class="ti ti-coin-rupee"></i></div>
                <div class="mc-body">
                    <div class="val">₹<%= String.format("%.2f",totalAmt) %></div>
                    <div class="lbl">Total Value</div>
                    <div class="sub">Estimated payout</div>
                </div>
            </div>
            <div class="mc amber">
                <div class="mi amber"><i class="ti ti-chart-dots"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",avgFat) %>%</div>
                    <div class="lbl">Avg FAT</div>
                    <div class="sub">Today's mean</div>
                </div>
            </div>
            <div class="mc cyan">
                <div class="mi cyan"><i class="ti ti-chart-dots-2"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",avgSnf) %>%</div>
                    <div class="lbl">Avg SNF</div>
                    <div class="sub">Today's mean</div>
                </div>
            </div>
        </div>

        <div class="two-col">
            <!-- Collection breakdown bars -->
            <div class="panel">
                <div class="panel-head">
                    <div class="panel-icon teal"><i class="ti ti-chart-bar"></i></div>
                    <div>
                        <div class="panel-title">Collection Breakdown</div>
                        <div class="panel-sub">Shift &amp; milk type distribution</div>
                    </div>
                </div>
                <div class="panel-body" style="display:flex;flex-direction:column;gap:22px;">
                    <div>
                        <div class="bar-section-label">By Shift</div>
                        <div class="bar-row">
                            <span class="bar-emoji">☀️</span>
                            <span class="bar-label">Morning</span>
                            <div class="bar-track">
                                <div class="bar-fill teal" style="width:<%= String.format("%.0f",morningPct) %>%;"></div>
                            </div>
                            <span class="bar-val"><%= String.format("%.2f",morningLtr) %> L</span>
                        </div>
                        <div class="bar-row">
                            <span class="bar-emoji">🌙</span>
                            <span class="bar-label">Evening</span>
                            <div class="bar-track">
                                <div class="bar-fill blue" style="width:<%= String.format("%.0f",eveningPct) %>%;"></div>
                            </div>
                            <span class="bar-val"><%= String.format("%.2f",eveningLtr) %> L</span>
                        </div>
                    </div>
                    <div>
                        <div class="bar-section-label">By Milk Type</div>
                        <div class="bar-row">
                            <span class="bar-emoji">🐄</span>
                            <span class="bar-label">Cow</span>
                            <div class="bar-track">
                                <div class="bar-fill emerald" style="width:<%= String.format("%.0f",cowPct) %>%;"></div>
                            </div>
                            <span class="bar-val"><%= String.format("%.2f",cowLtr) %> L</span>
                        </div>
                        <div class="bar-row">
                            <span class="bar-emoji">🐃</span>
                            <span class="bar-label">Buffalo</span>
                            <div class="bar-track">
                                <div class="bar-fill amber" style="width:<%= String.format("%.0f",bufPct) %>%;"></div>
                            </div>
                            <span class="bar-val"><%= String.format("%.2f",bufLtr) %> L</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- All entries compact table -->
            <div class="panel">
                <div class="panel-head">
                    <div class="panel-icon blue"><i class="ti ti-list-details"></i></div>
                    <div>
                        <div class="panel-title">All Entries Today</div>
                        <div class="panel-sub"><%= cnt %> record<%= cnt==1?"":"s" %> across both shifts</div>
                    </div>
                </div>
                <div class="tbl-wrap" style="max-height:266px;overflow-y:auto;">
                    <% if(collections.isEmpty()) { %>
                    <div class="empty">
                        <i class="ti ti-droplet-off"></i>
                        <div class="etitle">No collections yet</div>
                        <p>No milk has been recorded today.</p>
                        <a href="AdminDashboardServlet?view=milkCollection"><i class="ti ti-plus"></i>Add Entry</a>
                    </div>
                    <% } else { %>
                    <table>
                        <thead><tr>
                            <th>Farmer</th><th>Shift</th><th>Type</th><th>Qty (L)</th><th>Amount (₹)</th>
                        </tr></thead>
                        <tbody>
                        <% for(Collection c : collections) { %>
                        <tr>
                            <td class="fc"><%= c.getFarmerCode() %></td>
                            <td>
                                <% if("MORNING".equalsIgnoreCase(c.getShift())) { %>
                                <span class="pill morning">☀️ Morning</span>
                                <% } else if("Evening".equalsIgnoreCase(c.getShift())){ %>
                                <span class="pill evening">🌙 Evening</span>
                                <% } %>
                            </td>
                            <td>
                                <% if("C".equalsIgnoreCase(c.getMilkType())) { %>
    							<span class="pill cow">🐄 Cow</span>
								<% } else if("B".equalsIgnoreCase(c.getMilkType())) { %>
    							<span class="pill buf">🐃 Buffalo</span>
								<% } %>
                            </td>
                            <td class="num emerald"><%= String.format("%.2f",c.getQuantity()) %></td>
                            <td class="num emerald">₹<%= String.format("%.2f",c.getAmount()) %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- ════════════════════════════════════
             VIEW: MORNING / EVENING SHIFT
        ════════════════════════════════════ -->
        <% } else if(isShift) { %>

        <div class="sec-row">
            <div class="sec-title">
                <i class="ti ti-<%= isMorning?"sun":"moon" %>"></i>
                <%= isMorning?"Morning":"Evening" %> Shift &mdash; Summary
                <span class="shift-ribbon <%= isMorning?"morning":"evening" %>">
                    <i class="ti ti-<%= isMorning?"sun":"moon" %>" style="font-size:12px;"></i>
                    <%= isMorning?"AM":"PM" %>
                </span>
            </div>
            <div class="sec-tag">📅 <%= todayShort %></div>
        </div>

        <div class="grid-5">
            <div class="mc <%= isMorning?"teal":"violet" %>">
                <div class="mi <%= isMorning?"teal":"violet" %>"><i class="ti ti-clipboard-list"></i></div>
                <div class="mc-body">
                    <div class="val"><%= cnt %></div>
                    <div class="lbl">Entries</div>
                    <div class="sub"><%= cowCnt %> cow · <%= bufCnt %> buffalo</div>
                </div>
            </div>
            <div class="mc blue">
                <div class="mi blue"><i class="ti ti-droplet-filled"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",totalLtr) %> L</div>
                    <div class="lbl">Total Litres</div>
                    <div class="sub">🐄 <%= String.format("%.2f",cowLtr) %> · 🐃 <%= String.format("%.2f",bufLtr) %></div>
                </div>
            </div>
            <div class="mc emerald">
                <div class="mi emerald"><i class="ti ti-coin-rupee"></i></div>
                <div class="mc-body">
                    <div class="val">₹<%= String.format("%.2f",totalAmt) %></div>
                    <div class="lbl">Total Value</div>
                    <div class="sub">Estimated payout</div>
                </div>
            </div>
            <div class="mc amber">
                <div class="mi amber"><i class="ti ti-chart-dots"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",avgFat) %>%</div>
                    <div class="lbl">Avg FAT</div>
                    <div class="sub">Shift mean</div>
                </div>
            </div>
            <div class="mc cyan">
                <div class="mi cyan"><i class="ti ti-chart-dots-2"></i></div>
                <div class="mc-body">
                    <div class="val"><%= String.format("%.2f",avgSnf) %>%</div>
                    <div class="lbl">Avg SNF</div>
                    <div class="sub">Shift mean</div>
                </div>
            </div>
        </div>

        <div class="shift-panel">
            <div class="sp-head">
                <div class="sp-left">
                    <div class="sp-icon <%= isMorning?"teal":"violet" %>">
                        <i class="ti ti-<%= isMorning?"sun":"moon" %>"></i>
                    </div>
                    <div>
                        <div class="sp-title"><%= isMorning?"☀️ Morning":"🌙 Evening" %> Collection Records</div>
                        <div class="sp-sub"><%= cnt %> record<%= cnt==1?"":"s" %> &middot; <%= String.format("%.2f",totalLtr) %> L collected</div>
                    </div>
                </div>
                <div class="sp-right">
                    <div class="sp-stat">
                        <div class="sv"><%= String.format("%.2f",avgFat) %>%</div>
                        <div class="sl">Avg FAT</div>
                    </div>
                    <div class="sp-divider"></div>
                    <div class="sp-stat">
                        <div class="sv"><%= String.format("%.2f",avgSnf) %>%</div>
                        <div class="sl">Avg SNF</div>
                    </div>
                    <div class="sp-divider"></div>
                    <div class="sp-stat">
                        <div class="sv">₹<%= String.format("%.2f",totalAmt) %></div>
                        <div class="sl">Total Value</div>
                    </div>
                    <div class="sp-divider"></div>
                    <button class="tb-icon" onclick="window.print()" title="Print"><i class="ti ti-printer"></i></button>
                </div>
            </div>
            <div class="tbl-wrap">
                <% if(collections.isEmpty()) { %>
                <div class="empty">
                    <i class="ti ti-droplet-off"></i>
                    <div class="etitle">No records found</div>
                    <p>No <%= isMorning?"morning":"evening" %> collections recorded yet.</p>
                    <a href="AdminDashboardServlet?view=milkCollection"><i class="ti ti-plus"></i>Add Entry</a>
                </div>
                <% } else { %>
                <table>
                    <thead><tr>
                        <th>#</th>
                        <th>Farmer Code</th>
                        <th>Milk Type</th>
                        <th>Qty (L)</th>
                        <th>FAT %</th>
                        <th>SNF %</th>
                        <th>Rate / L</th>
                        <th>Amount (₹)</th>
                        <th>Time</th>
                    </tr></thead>
                    <tbody>
                    <% int idx=1; for(Collection c : collections) { %>
                    <tr>
                        <td class="idx-col"><%= idx++ %></td>
                        <td class="fc"><%= c.getFarmerCode() %></td>
                        <td>
                            <% if("C".equalsIgnoreCase(c.getMilkType())) { %>
    							<span class="pill cow">🐄 Cow</span>
								<% } else if("B".equalsIgnoreCase(c.getMilkType())) { %>
    							<span class="pill buf">🐃 Buffalo</span>
							<% } %>
                        </td>
                        <td class="num emerald"><%= String.format("%.2f",c.getQuantity()) %></td>
                        <td class="num amber"><%= String.format("%.1f",c.getFat()) %></td>
                        <td class="num blue"><%= String.format("%.1f",c.getSnf()) %></td>
                        <td class="num violet">₹<%= String.format("%.2f",c.getRatePerLtr()) %></td>
                        <td class="num emerald">₹<%= String.format("%.2f",c.getAmount()) %></td>
                        <td class="idx-col">
                            <% if(c.getCreatedAt()!=null){ %>
                                <%= new java.text.SimpleDateFormat("hh:mm a") 								  		       						{{ setTimeZone(java.util.TimeZone.getTimeZone("Asia/Kolkata")); }}.format(c.getCreatedAt()) %>
                            <% } else { %>—<% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="tfoot-row">
                            <td colspan="3" style="color:var(--muted);font-size:11px;font-weight:700;">
                                TOTALS &nbsp;·&nbsp; <%= cnt %> entr<%= cnt==1?"y":"ies" %>
                            </td>
                            <td class="num emerald"><%= String.format("%.2f",totalLtr) %> L</td>
                            <td class="num amber"><%= String.format("%.1f",avgFat) %></td>
                            <td class="num blue"><%= String.format("%.1f",avgSnf) %></td>
                            <td>—</td>
                            <td class="num emerald">₹<%= String.format("%.2f",totalAmt) %></td>
                            <td>—</td>
                        </tr>
                    </tfoot>
                </table>
                <% } %>
            </div>
        </div>

        <!-- ════════════════════════════════════
             VIEW: DATE-WISE REPORT
        ════════════════════════════════════ -->
        <% } else if("datewise".equals(currentView)) { %>

        <div class="sec-row">
            <div class="sec-title"><i class="ti ti-calendar-search"></i>Date-wise Collection Report</div>
        </div>

        <div class="dw-wrap">

            <!-- Left: form card -->
            <div class="dw-form-card">
                <div class="dw-form-title">
                    <i class="ti ti-calendar-event"></i>Select Date Range
                </div>
                <form action="DateWiseCollectionReportServlet" method="POST">
                    <input type="hidden" name="view" value="datewise">
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

            <!-- Right: results -->
            <div class="dw-results">
                <% if(reports == null) { %>
                <div class="wip" style="min-height:240px;display:flex;flex-direction:column;align-items:center;justify-content:center;">
                    <i class="ti ti-calendar-search"></i>
                    <div class="wip-title">No Report Generated</div>
                    <p>Select a date range and click <strong>Generate Report</strong> to view farmer-wise collection data.</p>
                </div>

                <% } else if(reports.isEmpty()) { %>
                <div class="wip" style="min-height:240px;display:flex;flex-direction:column;align-items:center;justify-content:center;">
                    <i class="ti ti-database-off"></i>
                    <div class="wip-title">No Records Found</div>
                    <p>No collection records for the selected date range.</p>
                </div>

                <% } else { %>
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
                        <div class="sp-right">
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
                                for(Report r : reports) {
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
        </div>

        <!-- ════════════════════════════════════
             VIEW: UNDER CONSTRUCTION
        ════════════════════════════════════ -->
        <% } else { %>
        <div class="wip">
            <i class="ti ti-tools"></i>
            <div class="wip-title">Feature Under Development</div>
            <p>This report section is coming soon. Check back later.</p>
        </div>
        <% } %>

    </div><!-- /content -->

    <div class="foot">
        <div class="foot-logo">Milk<span>Mitra</span> &copy; 2026. All Rights Reserved.</div>
        <span>Session: <strong><%= username %></strong> &middot; <%= role %></span>
    </div>
</div>

<script>
document.getElementById('dateStr').textContent =
    new Date().toLocaleDateString('en-IN',{weekday:'short',year:'numeric',month:'short',day:'numeric'});
</script>
</body>
</html>
