<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.milkmitra.model.Dashboard" %>
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
    Dashboard dashboard =
            (Dashboard)request.getAttribute("dashboard");

    if(dashboard == null)
    {
        dashboard = new Dashboard();
    }

    int todayEntries =
            dashboard.getTodayEntries();

    int morningEntries =
            dashboard.getMorningEntries();

    int eveningEntries =
            dashboard.getEveningEntries();

    double todayTotalLtr =
            dashboard.getTodayTotalLtr();

    double todayCowLtr =
            dashboard.getTodayCowLtr();

    double todayBufLtr =
            dashboard.getTodayBufLtr();

    double todayValue =
            dashboard.getTodayValue();

    double avgFat =
            dashboard.getAvgFat();

    double avgSnf =
            dashboard.getAvgSnf();

    int totalFarmers =
            dashboard.getTotalFarmers();

    int activeFarmers =
            dashboard.getActiveFarmers();

    int inactiveFarmers =
            dashboard.getInactiveFarmers();
    // Safe defaults
   int absentToday = 0;
	int pendingFeedOrders = 0;
	double pendingPayments = 0.0;
	int lowStockItems = 0;

    String todayStr = LocalDate.now()
        .format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Admin Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}
:root{
    --navy:#0f1f3d;--blue:#2563eb;--blue-lt:#eff6ff;
    --green:#16a34a;--green-lt:#f0fdf4;
    --amber:#d97706;--amber-lt:#fffbeb;
    --red:#dc2626;--red-lt:#fef2f2;
    --purple:#7c3aed;--purple-lt:#faf5ff;
    --teal:#0d9488;--teal-lt:#f0fdfa;
    --orange:#ea580c;--orange-lt:#fff7ed;
    --sidebar:260px;--text:#0f1f3d;--muted:#6b7a99;
    --border:#e8edf6;--bg:#f4f7fe;--white:#fff;--radius:12px;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);display:flex;min-height:100vh;}

/* ── SIDEBAR ── */
.sidebar{width:var(--sidebar);height:100vh;overflow:hidden;background:linear-gradient(175deg,#0d1f45 0%,#0f2a6b 55%,#102f80 100%);display:flex;flex-direction:column;position:fixed;top:0;left:0;z-index:100;}
.sidebar::before{content:'';position:absolute;width:300px;height:300px;background:radial-gradient(circle,rgba(37,99,235,.28) 0%,transparent 70%);top:-80px;right:-80px;border-radius:50%;pointer-events:none;}
.sb-brand{padding:26px 24px 18px;border-bottom:1px solid rgba(255,255,255,.08);flex-shrink:0;}
.sb-brand h1{font-family:'DM Serif Display',serif;font-size:24px;color:#fff;}
.sb-brand h1 span{color:#60a5fa;}
.sb-brand p{margin-top:4px;font-size:10px;color:#4d6ea8;letter-spacing:.6px;text-transform:uppercase;}
.sb-user{padding:14px 24px;border-bottom:1px solid rgba(255,255,255,.08);flex-shrink:0;display:flex;align-items:center;gap:12px;}
.sb-av{width:36px;height:36px;background:rgba(37,99,235,.35);border:1px solid rgba(37,99,235,.5);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:15px;color:#fff;font-weight:600;flex-shrink:0;}
.sb-un{font-size:13px;font-weight:600;color:#e2e8f0;}
.sb-ur{font-size:10px;color:#4d6ea8;margin-top:2px;text-transform:uppercase;letter-spacing:.5px;}
.sb-nav{flex:1;min-height:0;display:flex;flex-direction:column;gap:3px;padding:12px;overflow-y:auto;overflow-x:hidden;}
.sb-nav::-webkit-scrollbar{width:4px;}
.sb-nav::-webkit-scrollbar-thumb{background:#3b82f6;border-radius:10px;}
.nl{font-size:9px;color:#2d4a70;text-transform:uppercase;letter-spacing:1px;padding:8px 10px 3px;font-weight:700;}
.ni{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:8px;text-decoration:none;color:#7ca0d4;font-size:13px;font-weight:500;transition:background .18s,color .18s;}
.ni:hover{background:rgba(37,99,235,.2);color:#e2e8f0;}
.ni.active{background:rgba(37,99,235,.3);color:#fff;border:1px solid rgba(37,99,235,.4);}
.ni i{font-size:17px;flex-shrink:0;}
.nav-note{font-size:9px;color:#2d4a70;padding:2px 12px 6px 38px;line-height:1.4;}
.sb-foot{padding:16px 24px;border-top:1px solid rgba(255,255,255,.08);flex-shrink:0;}
.lo-btn{display:flex;align-items:center;gap:8px;width:100%;padding:9px 12px;background:rgba(220,38,38,.15);border:1px solid rgba(220,38,38,.3);border-radius:8px;color:#fca5a5;font-size:13px;font-family:'DM Sans',sans-serif;text-decoration:none;cursor:pointer;transition:background .18s;}
.lo-btn:hover{background:rgba(220,38,38,.28);color:#fff;}
.lo-btn i{font-size:17px;}

/* ── MAIN ── */
.main{margin-left:var(--sidebar);flex:1;min-height:100vh;display:flex;flex-direction:column;}
.topbar{background:var(--white);border-bottom:1px solid var(--border);padding:0 32px;height:64px;display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;z-index:50;}
.tb-l h2{font-family:'DM Serif Display',serif;font-size:20px;color:var(--navy);}
.tb-l p{font-size:12px;color:var(--muted);margin-top:1px;}
.tb-r{display:flex;align-items:center;gap:10px;}
.tb-date{font-size:12px;color:var(--muted);background:var(--bg);padding:6px 14px;border-radius:20px;border:1px solid var(--border);}
.tb-icon{width:36px;height:36px;background:var(--blue-lt);border:1px solid #bfdbfe;border-radius:50%;display:flex;align-items:center;justify-content:center;color:var(--blue);cursor:pointer;}
.tb-icon i{font-size:18px;}

/* ── CONTENT ── */
.content{padding:28px 32px;flex:1;}

/* ── WELCOME ── */
.welcome{background:linear-gradient(120deg,#0f2a6b,#1d4ed8);border-radius:var(--radius);padding:26px 32px;margin-bottom:26px;position:relative;overflow:hidden;}
.welcome h3{font-family:'DM Serif Display',serif;font-size:22px;color:#fff;}
.welcome p{font-size:13px;color:#93c5fd;margin-top:5px;}
.wb-tag{display:inline-block;margin-top:12px;background:rgba(255,255,255,.15);color:#bfdbfe;font-size:11px;padding:4px 12px;border-radius:20px;border:1px solid rgba(255,255,255,.2);}
.wb-icon{position:absolute;right:32px;top:50%;transform:translateY(-50%);}
.wb-icon i{font-size:64px;color:#fff;opacity:.1;}

/* ── SECTION HEADER ── */
.sec-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;margin-top:6px;}
.sec-title{font-size:14px;font-weight:700;color:var(--navy);display:flex;align-items:center;gap:8px;}
.sec-title i{font-size:17px;color:var(--muted);}
.sec-badge{font-size:11px;background:var(--bg);color:var(--muted);padding:4px 12px;border-radius:20px;border:1px solid var(--border);}

/* ── STAT CARD BASE ── */
.sc{background:var(--white);border-radius:var(--radius);border:1px solid var(--border);padding:16px 18px;display:flex;align-items:center;gap:14px;transition:box-shadow .2s,transform .2s;position:relative;overflow:hidden;}
.sc:hover{box-shadow:0 6px 20px rgba(37,99,235,.09);transform:translateY(-2px);}
.sc::after{content:'';position:absolute;top:0;left:0;right:0;height:3px;border-radius:var(--radius) var(--radius) 0 0;}
.sc.blue::after{background:var(--blue);}
.sc.green::after{background:var(--green);}
.sc.amber::after{background:var(--amber);}
.sc.red::after{background:var(--red);}
.sc.purple::after{background:var(--purple);}
.sc.teal::after{background:var(--teal);}
.sc.orange::after{background:var(--orange);}
.sc.cyan::after{background:#0891b2;}

.si{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.si i{font-size:22px;}
.si.blue{background:var(--blue-lt);border:1px solid #bfdbfe;color:var(--blue);}
.si.green{background:var(--green-lt);border:1px solid #bbf7d0;color:var(--green);}
.si.amber{background:var(--amber-lt);border:1px solid #fde68a;color:var(--amber);}
.si.red{background:var(--red-lt);border:1px solid #fecaca;color:var(--red);}
.si.purple{background:var(--purple-lt);border:1px solid #e9d5ff;color:var(--purple);}
.si.teal{background:var(--teal-lt);border:1px solid #99f6e4;color:var(--teal);}
.si.orange{background:var(--orange-lt);border:1px solid #fed7aa;color:var(--orange);}
.si.cyan{background:#ecfeff;border:1px solid #a5f3fc;color:#0891b2;}

.sc-body .val{font-size:22px;font-weight:700;color:var(--navy);line-height:1;}
.sc-body .lbl{font-size:11px;color:var(--muted);margin-top:4px;font-weight:500;}
.sc-body .sub{font-size:10px;color:var(--muted);margin-top:3px;}

/* ── GRIDS ── */
.grid-4{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:14px;}
.grid-3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:14px;}
.grid-2{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;}

/* ── COMPOUND CARD (split into sub-stats) ── */
.cc{background:var(--white);border-radius:var(--radius);border:1px solid var(--border);overflow:hidden;transition:box-shadow .2s,transform .2s;position:relative;}
.cc:hover{box-shadow:0 6px 20px rgba(37,99,235,.09);transform:translateY(-2px);}
.cc::after{content:'';position:absolute;top:0;left:0;right:0;height:3px;}
.cc.teal::after{background:var(--teal);}
.cc.blue::after{background:var(--blue);}
.cc.green::after{background:var(--green);}
.cc.orange::after{background:var(--orange);}
.cc-head{display:flex;align-items:center;gap:10px;padding:13px 16px;border-bottom:1px solid var(--border);}
.cc-head .si{flex-shrink:0;}
.cc-title{font-size:12px;font-weight:700;color:var(--navy);}
.cc-sub{font-size:10px;color:var(--muted);margin-top:1px;}
.cc-grid{display:grid;grid-template-columns:1fr 1fr;gap:0;}
.cc-item{padding:11px 14px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);}
.cc-item:nth-child(2n){border-right:none;}
.cc-item:nth-last-child(-n+2){border-bottom:none;}
.cc-item .cl{font-size:10px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.3px;}
.cc-item .cv{font-size:17px;font-weight:700;color:var(--navy);margin-top:3px;line-height:1;}
.cc-item .cv.green{color:var(--green);}
.cc-item .cv.amber{color:var(--amber);}
.cc-item .cv.red{color:var(--red);}
.cc-item .cv.teal{color:var(--teal);}
.cc-item .cv.blue{color:var(--blue);}
.cc-item .cv.orange{color:var(--orange);}

/* ── ABSENT ALERT CARD ── */
.absent-card{background:linear-gradient(135deg,#fff7ed,#ffedd5);border:1.5px solid #fed7aa;border-radius:var(--radius);padding:16px 18px;display:flex;align-items:center;gap:14px;}
.absent-card .si{flex-shrink:0;}
.absent-card .ab-val{font-size:26px;font-weight:700;color:var(--orange);line-height:1;}
.absent-card .ab-lbl{font-size:12px;font-weight:600;color:#9a3412;margin-top:3px;}
.absent-card .ab-sub{font-size:11px;color:#c2410c;margin-top:2px;}

/* ── QUICK ACCESS ── */
.modules{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:10px;}
.mod-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);padding:20px 16px;text-align:center;text-decoration:none;color:var(--text);transition:box-shadow .2s,transform .2s;position:relative;overflow:hidden;}
.mod-card::before{content:'';position:absolute;top:0;left:0;right:0;height:3px;background:var(--cc,#2563eb);opacity:0;transition:opacity .2s;border-radius:var(--radius) var(--radius) 0 0;}
.mod-card:hover{box-shadow:0 8px 24px rgba(37,99,235,.12);transform:translateY(-3px);}
.mod-card:hover::before{opacity:1;}
.mc-icon{width:44px;height:44px;border-radius:11px;display:flex;align-items:center;justify-content:center;margin:0 auto 11px;}
.mc-icon i{font-size:22px;}
.mc-icon.blue{background:var(--blue-lt);border:1px solid #bfdbfe;color:var(--blue);}
.mc-icon.green{background:var(--green-lt);border:1px solid #bbf7d0;color:var(--green);}
.mc-icon.amber{background:var(--amber-lt);border:1px solid #fde68a;color:var(--amber);}
.mc-icon.purple{background:var(--purple-lt);border:1px solid #e9d5ff;color:var(--purple);}
.mc-icon.teal{background:var(--teal-lt);border:1px solid #99f6e4;color:var(--teal);}
.mc-icon.red{background:var(--red-lt);border:1px solid #fecaca;color:var(--red);}
.mc-icon.cyan{background:#ecfeff;border:1px solid #a5f3fc;color:#0891b2;}
.mc-title{font-size:13px;font-weight:700;color:var(--navy);margin-bottom:3px;}
.mc-sub{font-size:11px;color:var(--muted);}
.mc-arrow{display:inline-block;margin-top:10px;font-size:11px;color:var(--blue);font-weight:600;opacity:0;transition:opacity .2s;}
.mod-card:hover .mc-arrow{opacity:1;}

/* ── DIVIDER ── */
.divider{height:1px;background:var(--border);margin:24px 0;}

/* ── FOOTER ── */
.foot{padding:16px 32px;border-top:1px solid var(--border);font-size:12px;color:var(--muted);background:var(--white);display:flex;justify-content:space-between;}
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
        <a href="AdminDashboardServlet" class="ni active"><i class="ti ti-home"></i>Dashboard</a>
        <div class="nl">Farmer Management</div>
        <a href="AddFarmer.jsp"     class="ni"><i class="ti ti-user-plus"></i>Add Farmer</a>
        <a href="FarmerListServlet" class="ni"><i class="ti ti-users"></i>View Farmers</a>
        <div class="nav-note"> Edit · Deactivate · Reactivate inside View Farmers</div>
        <div class="nl">Operations</div>
        <a href="MilkCollection.jsp" class="ni"><i class="ti ti-droplet"></i>Milk Collection</a>
        <a href="MilkCollectionReportServlet" class="ni"><i class="ti ti-droplet"></i>Collection Report</a>
        <a href="payment/paymentList.jsp"  class="ni"><i class="ti ti-cash"></i>Payments</a>
        <a href="feed/feedList.jsp"        class="ni"><i class="ti ti-wheat"></i>Feed Store</a>
        <div class="nl">Reports & Settings</div>
        <a href="reports/reports.jsp" class="ni"><i class="ti ti-chart-bar"></i>Reports</a>
        <a href="priceConfig.jsp"     class="ni"><i class="ti ti-currency-rupee"></i>Price Config</a>
    </nav>
    <div class="sb-foot">
        <a href="Logout" class="lo-btn"><i class="ti ti-logout"></i>Logout</a>
    </div>
</aside>

<!-- MAIN -->
<div class="main">
    <div class="topbar">
        <div class="tb-l">
            <h2>Dashboard</h2>
            <p>Overview of your dairy operations</p>
        </div>
        <div class="tb-r">
            <div class="tb-date" id="dateStr"></div>
            <div class="tb-icon"><i class="ti ti-bell"></i></div>
        </div>
    </div>

    <div class="content">

        <!-- WELCOME -->
        <div class="welcome">
            <div>
                <h3 id="greeting">Good morning, <%= username %> 👋</h3>
                <p>Here's what's happening across MilkMitra today.</p>
                <span class="wb-tag">Admin · Full Access · Dudhshree MPP</span>
            </div>
            <div class="wb-icon"><i class="ti ti-droplet"></i></div>
        </div>

        <!-- ══════════════════════════════════════════
             SECTION 1 — TODAY'S COLLECTION
        ══════════════════════════════════════════ -->
        <div class="sec-head">
            <div class="sec-title">
                <i class="ti ti-calendar-today"></i>
                Today's Collection
            </div>
            <div class="sec-badge">📅 <%= todayStr %></div>
        </div>

        <!-- Row 1: Shift Entries + Milk Breakdown (compound cards) -->
        <div class="grid-2" style="margin-bottom:14px;">

            <!-- Shift Entries compound card -->
            <div class="cc teal">
                <div class="cc-head">
                    <div class="si teal"><i class="ti ti-clipboard-list"></i></div>
                    <div>
                        <div class="cc-title">Shift Entries</div>
                        <div class="cc-sub">Total: <%= todayEntries %> collections today</div>
                    </div>
                </div>
                <div class="cc-grid">
                    <div class="cc-item">
                        <div class="cl">☀️ Morning</div>
                        <div class="cv teal"><%= morningEntries %></div>
                    </div>
                    <div class="cc-item">
                        <div class="cl">🌙 Evening</div>
                        <div class="cv blue"><%= eveningEntries %></div>
                    </div>
                </div>
            </div>

            <!-- Milk type split compound card -->
            <div class="cc blue">
                <div class="cc-head">
                    <div class="si blue"><i class="ti ti-droplet-filled"></i></div>
                    <div>
                        <div class="cc-title">Milk Collected</div>
                        <div class="cc-sub">Total: <%= String.format("%.2f", todayTotalLtr) %> litres today</div>
                    </div>
                </div>
                <div class="cc-grid">
                    <div class="cc-item">
                        <div class="cl">🐄 Cow Milk</div>
                        <div class="cv green"><%= String.format("%.2f", todayCowLtr) %> L</div>
                    </div>
                    <div class="cc-item">
                        <div class="cl">🐃 Buffalo Milk</div>
                        <div class="cv amber"><%= String.format("%.2f", todayBufLtr) %> L</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Row 2: Value + Avg FAT + Avg SNF + Feed Orders -->
        <div class="grid-4" style="margin-bottom:14px;">
            <div class="sc green">
                <div class="si green"><i class="ti ti-coin-rupee"></i></div>
                <div class="sc-body">
                    <div class="val">₹<%= String.format("%.2f", todayValue) %></div>
                    <div class="lbl">Today's Value</div>
                    <div class="sub">Est. payout</div>
                </div>
            </div>
            <div class="sc teal">
                <div class="si teal"><i class="ti ti-chart-dots"></i></div>
                <div class="sc-body">
                    <div class="val"><%= String.format("%.2f", avgFat) %>%</div>
                    <div class="lbl">Average FAT</div>
                    <div class="sub">Today's average</div>
                </div>
            </div>
            <div class="sc blue">
                <div class="si blue"><i class="ti ti-chart-dots-2"></i></div>
                <div class="sc-body">
                    <div class="val"><%= String.format("%.2f", avgSnf) %>%</div>
                    <div class="lbl">Average SNF</div>
                    <div class="sub">Today's average</div>
                </div>
            </div>
            <div class="sc purple">
                <div class="si purple"><i class="ti ti-wheat"></i></div>
                <div class="sc-body">
                    <div class="val"><%= pendingFeedOrders %></div>
                    <div class="lbl">Feed Orders</div>
                    <div class="sub">Pending delivery</div>
                </div>
            </div>
        </div>

        <!-- Row 3: Absent farmers alert -->
        <div class="absent-card" style="margin-bottom:24px;">
            <div class="si orange"><i class="ti ti-user-exclamation"></i></div>
            <div>
                <div class="ab-val"><%= absentToday %></div>
                <div class="ab-lbl">Absent Farmers Today</div>
                <div class="ab-sub">
                    Active farmers who gave milk yesterday but have not collected today yet.
                    <% if(absentToday == 0) { %> ✅ All active farmers have collected today!<% } %>
                </div>
            </div>
        </div>

        <div class="divider"></div>

        <!-- ══════════════════════════════════════════
             SECTION 2 — FARMER OVERVIEW
        ══════════════════════════════════════════ -->
        <div class="sec-head">
            <div class="sec-title">
                <i class="ti ti-users"></i>
                Farmer Overview
            </div>
        </div>

        <div class="grid-4" style="margin-bottom:28px;">
            <div class="sc blue">
                <div class="si blue"><i class="ti ti-users"></i></div>
                <div class="sc-body">
                    <div class="val"><%= totalFarmers %></div>
                    <div class="lbl">Total Farmers</div>
                    <div class="sub">All registered</div>
                </div>
            </div>
            <div class="sc green">
                <div class="si green"><i class="ti ti-user-check"></i></div>
                <div class="sc-body">
                    <div class="val"><%= activeFarmers %></div>
                    <div class="lbl">Active Farmers</div>
                    <div class="sub">Currently supplying</div>
                </div>
            </div>
            <div class="sc amber">
                <div class="si amber"><i class="ti ti-cash"></i></div>
                <div class="sc-body">
                    <div class="val">₹<%= String.format("%.0f", pendingPayments) %></div>
                    <div class="lbl">Pending Payments</div>
                    <div class="sub">Awaiting release</div>
                </div>
            </div>
            <div class="sc red">
                <div class="si red"><i class="ti ti-alert-triangle"></i></div>
                <div class="sc-body">
                    <div class="val"><%= lowStockItems %></div>
                    <div class="lbl">Low Stock Alerts</div>
                    <div class="sub">Inventory items</div>
                </div>
            </div>
        </div>

        <!-- ══════════════════════════════════════════
             SECTION 3 — QUICK ACCESS
        ══════════════════════════════════════════ -->
        <div class="sec-head">
            <div class="sec-title">
                <i class="ti ti-layout-grid"></i>
                Quick Access
            </div>
        </div>
        <div class="modules">
            <a href="FarmerListServlet" class="mod-card" style="--cc:#2563eb;">
                <div class="mc-icon blue"><i class="ti ti-users"></i></div>
                <div class="mc-title">Manage Farmers</div>
                <div class="mc-sub">View · Edit · Deactivate</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="AddFarmer.jsp" class="mod-card" style="--cc:#16a34a;">
                <div class="mc-icon green"><i class="ti ti-user-plus"></i></div>
                <div class="mc-title">Add Farmer</div>
                <div class="mc-sub">Register new farmer</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="MilkCollection.jsp" class="mod-card" style="--cc:#0d9488;">
                <div class="mc-icon teal"><i class="ti ti-droplet"></i></div>
                <div class="mc-title">Milk Collection</div>
                <div class="mc-sub">Morning &amp; evening entry</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="payment/paymentList.jsp" class="mod-card" style="--cc:#d97706;">
                <div class="mc-icon amber"><i class="ti ti-cash"></i></div>
                <div class="mc-title">Payments</div>
                <div class="mc-sub">10-day cycle payments</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="feed/feedList.jsp" class="mod-card" style="--cc:#7c3aed;">
                <div class="mc-icon purple"><i class="ti ti-wheat"></i></div>
                <div class="mc-title">Feed Store</div>
                <div class="mc-sub">Orders &amp; installments</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="priceConfig.jsp" class="mod-card" style="--cc:#dc2626;">
                <div class="mc-icon red"><i class="ti ti-currency-rupee"></i></div>
                <div class="mc-title">Price Config</div>
                <div class="mc-sub">Update rate formulas</div>
                <div class="mc-arrow">Open →</div>
            </a>
            <a href="reports/reports.jsp" class="mod-card" style="--cc:#0891b2;">
                <div class="mc-icon cyan"><i class="ti ti-chart-bar"></i></div>
                <div class="mc-title">Reports</div>
                <div class="mc-sub">Analytics &amp; exports</div>
                <div class="mc-arrow">Open →</div>
            </a>
        </div>

    </div><!-- /content -->

    <div class="foot">
        <span>© 2026 MilkMitra. All Rights Reserved.</span>
        <span>Logged in as <strong><%= username %></strong> · <%= role %></span>
    </div>
</div>

<script>
var d = new Date();
document.getElementById('dateStr').textContent =
    d.toLocaleDateString('en-IN',{weekday:'short',year:'numeric',month:'short',day:'numeric'});
var h = d.getHours();
var g = h < 12 ? 'Good morning' : h < 17 ? 'Good afternoon' : 'Good evening';
document.getElementById('greeting').textContent = g + ', <%= username %> \uD83D\uDC4B';
</script>
</body>
</html>
