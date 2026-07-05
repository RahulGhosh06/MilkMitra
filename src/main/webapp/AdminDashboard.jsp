<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="com.milkmitra.model.Farmer"%>
<%@ page import="com.milkmitra.model.Dashboard"%>
<%@ page import="com.milkmitra.model.PaymentSummary"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
if (username == null || !"ADMIN".equals(role)) {
	response.sendRedirect("Login.jsp");
	return;
}

/* ── Determine current view ── */
String currentView = (String) request.getAttribute("currentView");

if (currentView == null || currentView.isEmpty()) {
	currentView = request.getParameter("view");
}

if (currentView == null || currentView.isEmpty()) {
	currentView = "dashboard";
}
/* ── Dashboard data ── */
Dashboard dashboard = (Dashboard) request.getAttribute("dashboard");
if (dashboard == null)
	dashboard = new Dashboard();

Farmer selectedFarmer = (Farmer) request.getAttribute("selectedFarmer");
System.out.println("JSP selectedFarmer = " + selectedFarmer);

int todayEntries = dashboard.getTodayEntries();
int morningEntries = dashboard.getMorningEntries();
int eveningEntries = dashboard.getEveningEntries();
double todayTotalLtr = dashboard.getTodayTotalLtr();
double todayCowLtr = dashboard.getTodayCowLtr();
double todayBufLtr = dashboard.getTodayBufLtr();
double todayValue = dashboard.getTodayValue();
double avgFat = dashboard.getAvgFat();
double avgSnf = dashboard.getAvgSnf();
int totalFarmers = dashboard.getTotalFarmers();
int activeFarmers = dashboard.getActiveFarmers();
int inactiveFarmers = dashboard.getInactiveFarmers();
int absentToday = 0;
int pendingFeedOrders = 0;
double pendingPayments = 0.0;
int lowStockItems = 0;

String todayStr = LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")).format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
/* ── Farmer list data (farmerList / viewFarmer views) ── */
List<Farmer> farmers = (List<Farmer>) request.getAttribute("farmers");
int farmerTotal = (farmers != null) ? farmers.size() : 0;
int activeCount = (request.getAttribute("activeCount") != null) ? (Integer) request.getAttribute("activeCount") : 0;
int inactiveCount = (request.getAttribute("inactiveCount") != null)
		? (Integer) request.getAttribute("inactiveCount")
		: 0;
int joinedThisMonth = (request.getAttribute("joinedThisMonth") != null)
		? (Integer) request.getAttribute("joinedThisMonth")
		: 0;

/* ── Single farmer (viewFarmer / editFarmer views) ── */
Farmer farmer = (Farmer) request.getAttribute("farmer");

/* ── Flash messages ── */
String successMsg = (String) session.getAttribute("successMsg");
String errorMsg = (String) session.getAttribute("errorMsg");
if (successMsg == null)
	successMsg = (String) request.getAttribute("successMsg");
if (errorMsg == null)
	errorMsg = (String) request.getAttribute("errorMsg");
session.removeAttribute("successMsg");
session.removeAttribute("errorMsg");

/* ── Page title map ── */
String pageTitle = "Dashboard";
if ("addFarmer".equals(currentView))
	pageTitle = "Add Farmer";
else if ("farmerList".equals(currentView))
	pageTitle = "View Farmers";
else if ("viewFarmer".equals(currentView))
	pageTitle = "Farmer Profile";
else if ("editFarmer".equals(currentView))
	pageTitle = "Edit Farmer";
else if ("payments".equals(currentView))
	pageTitle = "Payments";
else if ("feedStore".equals(currentView))
	pageTitle = "Feed Store";
else if ("reports".equals(currentView))
	pageTitle = "Reports";
else if ("priceConfig".equals(currentView))
	pageTitle = "Price Config";

PaymentSummary cycleSummary = (PaymentSummary) request.getAttribute("cycleSummary");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | <%=pageTitle%></title>
<link
	href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/dist/tabler-icons.min.css">
<style>
*, *::before, *::after {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

:root {
	--navy: #0f1f3d;
	--navy2: #0d2a6b;
	--blue: #2563eb;
	--blue-lt: #eff6ff;
	--green: #16a34a;
	--green-lt: #f0fdf4;
	--amber: #d97706;
	--amber-lt: #fffbeb;
	--red: #dc2626;
	--red-lt: #fef2f2;
	--purple: #7c3aed;
	--purple-lt: #faf5ff;
	--teal: #0d9488;
	--teal-lt: #f0fdfa;
	--orange: #ea580c;
	--orange-lt: #fff7ed;
	--sidebar: 260px;
	--text: #0f1f3d;
	--muted: #6b7a99;
	--border: #e8edf6;
	--bg: #f4f7fe;
	--white: #fff;
	--radius: 12px;
}

body {
	font-family: 'DM Sans', sans-serif;
	background: var(--bg);
	color: var(--text);
	display: flex;
	min-height: 100vh;
	font-size: 14px;
}

/* ═══════════════════════════════════════════════════════════
   SIDEBAR
═══════════════════════════════════════════════════════════ */
.sidebar {
	width: var(--sidebar);
	height: 100vh;
	overflow: hidden;
	background: linear-gradient(175deg, #0d1f45 0%, #0f2a6b 55%, #102f80 100%);
	display: flex;
	flex-direction: column;
	position: fixed;
	top: 0;
	left: 0;
	z-index: 100;
}

.sidebar::before {
	content: '';
	position: absolute;
	width: 300px;
	height: 300px;
	background: radial-gradient(circle, rgba(37, 99, 235, .28) 0%,
		transparent 70%);
	top: -80px;
	right: -80px;
	border-radius: 50%;
	pointer-events: none;
}

.sb-brand {
	padding: 26px 24px 18px;
	border-bottom: 1px solid rgba(255, 255, 255, .08);
	flex-shrink: 0;
}

.sb-brand h1 {
	font-family: 'DM Serif Display', serif;
	font-size: 24px;
	color: #fff;
}

.sb-brand h1 span {
	color: #60a5fa;
}

.sb-brand p {
	margin-top: 4px;
	font-size: 10px;
	color: #4d6ea8;
	letter-spacing: .6px;
	text-transform: uppercase;
}

.sb-user {
	padding: 14px 24px;
	border-bottom: 1px solid rgba(255, 255, 255, .08);
	flex-shrink: 0;
	display: flex;
	align-items: center;
	gap: 12px;
}

.sb-av {
	width: 36px;
	height: 36px;
	background: rgba(37, 99, 235, .35);
	border: 1px solid rgba(37, 99, 235, .5);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 15px;
	color: #fff;
	font-weight: 600;
	flex-shrink: 0;
}

.sb-un {
	font-size: 13px;
	font-weight: 600;
	color: #e2e8f0;
}

.sb-ur {
	font-size: 10px;
	color: #4d6ea8;
	margin-top: 2px;
	text-transform: uppercase;
	letter-spacing: .5px;
}

.sb-nav {
	flex: 1;
	min-height: 0;
	display: flex;
	flex-direction: column;
	gap: 3px;
	padding: 12px;
	overflow-y: auto;
	overflow-x: hidden;
}

.sb-nav::-webkit-scrollbar {
	width: 4px;
}

.sb-nav::-webkit-scrollbar-thumb {
	background: #3b82f6;
	border-radius: 10px;
}

.nl {
	font-size: 9px;
	color: #2d4a70;
	text-transform: uppercase;
	letter-spacing: 1px;
	padding: 8px 10px 3px;
	font-weight: 700;
}

.ni {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 9px 12px;
	border-radius: 8px;
	text-decoration: none;
	color: #7ca0d4;
	font-size: 13px;
	font-weight: 500;
	transition: background .18s, color .18s;
}

.ni:hover {
	background: rgba(37, 99, 235, .2);
	color: #e2e8f0;
}

.ni.active {
	background: rgba(37, 99, 235, .3);
	color: #fff;
	border: 1px solid rgba(37, 99, 235, .4);
}

.ni i {
	font-size: 17px;
	flex-shrink: 0;
}

.nav-note {
	font-size: 9px;
	color: #2d4a70;
	padding: 2px 12px 6px 38px;
	line-height: 1.4;
}

.sb-foot {
	padding: 16px 24px;
	border-top: 1px solid rgba(255, 255, 255, .08);
	flex-shrink: 0;
}

.lo-btn {
	display: flex;
	align-items: center;
	gap: 8px;
	width: 100%;
	padding: 9px 12px;
	background: rgba(220, 38, 38, .15);
	border: 1px solid rgba(220, 38, 38, .3);
	border-radius: 8px;
	color: #fca5a5;
	font-size: 13px;
	font-family: 'DM Sans', sans-serif;
	text-decoration: none;
	cursor: pointer;
	transition: background .18s;
}

.lo-btn:hover {
	background: rgba(220, 38, 38, .28);
	color: #fff;
}

.lo-btn i {
	font-size: 17px;
}

/* ═══════════════════════════════════════════════════════════
   MAIN SHELL
═══════════════════════════════════════════════════════════ */
.main {
	margin-left: var(--sidebar);
	flex: 1;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

.topbar {
	background: var(--white);
	border-bottom: 1px solid var(--border);
	padding: 0 32px;
	height: 64px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	position: sticky;
	top: 0;
	z-index: 50;
}

.tb-l h2 {
	font-family: 'DM Serif Display', serif;
	font-size: 20px;
	color: var(--navy);
}

.tb-l p {
	font-size: 12px;
	color: var(--muted);
	margin-top: 1px;
}

.tb-r {
	display: flex;
	align-items: center;
	gap: 10px;
}

.tb-date {
	font-size: 12px;
	color: var(--muted);
	background: var(--bg);
	padding: 6px 14px;
	border-radius: 20px;
	border: 1px solid var(--border);
}

.content {
	padding: 24px 32px 36px;
	flex: 1;
}

.bc {
	display: flex;
	align-items: center;
	gap: 7px;
	font-size: 12px;
	color: var(--muted);
	margin-bottom: 20px;
}

.bc a {
	color: var(--blue);
	text-decoration: none;
}

.bc a:hover {
	text-decoration: underline;
}

.bc i {
	font-size: 12px;
}

.foot {
	padding: 16px 32px;
	border-top: 1px solid var(--border);
	font-size: 12px;
	color: var(--muted);
	background: var(--white);
	display: flex;
	justify-content: space-between;
}

/* ═══════════════════════════════════════════════════════════
   ALERTS
═══════════════════════════════════════════════════════════ */
.alert {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 13px 16px;
	border-radius: 10px;
	font-size: 13px;
	font-weight: 500;
	margin-bottom: 20px;
	animation: slideDown .3s ease;
}

@
keyframes slideDown {
	from {opacity: 0;
	transform: translateY(-8px)
}

to {
	opacity: 1;
	transform: translateY(0)
}

}
.alert-success {
	background: var(--green-lt);
	border: 1px solid #bbf7d0;
	color: #15803d;
}

.alert-error {
	background: var(--red-lt);
	border: 1px solid #fecaca;
	color: var(--red);
}

.alert i {
	font-size: 18px;
}

/* ═══════════════════════════════════════════════════════════
   SHARED STAT / CARD COMPONENTS
═══════════════════════════════════════════════════════════ */
.sc {
	background: var(--white);
	border-radius: var(--radius);
	border: 1px solid var(--border);
	padding: 16px 18px;
	display: flex;
	align-items: center;
	gap: 14px;
	transition: box-shadow .2s, transform .2s;
	position: relative;
	overflow: hidden;
}

.sc:hover {
	box-shadow: 0 6px 20px rgba(37, 99, 235, .09);
	transform: translateY(-2px);
}

.sc::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
	border-radius: var(--radius) var(--radius) 0 0;
}

.sc.blue::after {
	background: var(--blue);
}

.sc.green::after {
	background: var(--green);
}

.sc.amber::after {
	background: var(--amber);
}

.sc.red::after {
	background: var(--red);
}

.sc.purple::after {
	background: var(--purple);
}

.sc.teal::after {
	background: var(--teal);
}

.sc.orange::after {
	background: var(--orange);
}

.sc.cyan::after {
	background: #0891b2;
}

.si {
	width: 44px;
	height: 44px;
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.si i {
	font-size: 22px;
}

.si.blue {
	background: var(--blue-lt);
	border: 1px solid #bfdbfe;
	color: var(--blue);
}

.si.green {
	background: var(--green-lt);
	border: 1px solid #bbf7d0;
	color: var(--green);
}

.si.amber {
	background: var(--amber-lt);
	border: 1px solid #fde68a;
	color: var(--amber);
}

.si.red {
	background: var(--red-lt);
	border: 1px solid #fecaca;
	color: var(--red);
}

.si.purple {
	background: var(--purple-lt);
	border: 1px solid #e9d5ff;
	color: var(--purple);
}

.si.teal {
	background: var(--teal-lt);
	border: 1px solid #99f6e4;
	color: var(--teal);
}

.si.orange {
	background: var(--orange-lt);
	border: 1px solid #fed7aa;
	color: var(--orange);
}

.si.cyan {
	background: #ecfeff;
	border: 1px solid #a5f3fc;
	color: #0891b2;
}

.sc-body .val {
	font-size: 22px;
	font-weight: 700;
	color: var(--navy);
	line-height: 1;
}

.sc-body .lbl {
	font-size: 11px;
	color: var(--muted);
	margin-top: 4px;
	font-weight: 500;
}

.sc-body .sub {
	font-size: 10px;
	color: var(--muted);
	margin-top: 3px;
}

.grid-4 {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 14px;
	margin-bottom: 14px;
}

.grid-3 {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 14px;
	margin-bottom: 14px;
}

.grid-2 {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 14px;
	margin-bottom: 14px;
}

.cc {
	background: var(--white);
	border-radius: var(--radius);
	border: 1px solid var(--border);
	overflow: hidden;
	transition: box-shadow .2s, transform .2s;
	position: relative;
}

.cc:hover {
	box-shadow: 0 6px 20px rgba(37, 99, 235, .09);
	transform: translateY(-2px);
}

.cc::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
}

.cc.teal::after {
	background: var(--teal);
}

.cc.blue::after {
	background: var(--blue);
}

.cc.green::after {
	background: var(--green);
}

.cc.orange::after {
	background: var(--orange);
}

.cc-head {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 13px 16px;
	border-bottom: 1px solid var(--border);
}

.cc-head .si {
	flex-shrink: 0;
}

.cc.teal .cc-head .si {
	background: var(--teal-lt);
	border: 1px solid #99f6e4;
	color: var(--teal);
}

.cc.blue .cc-head .si {
	background: var(--blue-lt);
	border: 1px solid #bfdbfe;
	color: var(--blue);
}

.cc.green .cc-head .si {
	background: var(--green-lt);
	border: 1px solid #bbf7d0;
	color: var(--green);
}

.cc.orange .cc-head .si {
	background: var(--orange-lt);
	border: 1px solid #fed7aa;
	color: var(--orange);
}

.cc-title {
	font-size: 12px;
	font-weight: 700;
	color: var(--navy);
}

.cc-sub {
	font-size: 10px;
	color: var(--muted);
	margin-top: 1px;
}

.cc-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
}

.cc-item {
	padding: 11px 14px;
	border-right: 1px solid var(--border);
	border-bottom: 1px solid var(--border);
}

.cc-item:nth-child(2n) {
	border-right: none;
}

.cc-item:nth-last-child(-n+2) {
	border-bottom: none;
}

.cc-item .cl {
	font-size: 10px;
	color: var(--muted);
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: .3px;
}

.cc-item .cv {
	font-size: 17px;
	font-weight: 700;
	color: var(--navy);
	margin-top: 3px;
	line-height: 1;
}

.cc-item .cv.green {
	color: var(--green);
}

.cc-item .cv.amber {
	color: var(--amber);
}

.cc-item .cv.red {
	color: var(--red);
}

.cc-item .cv.teal {
	color: var(--teal);
}

.cc-item .cv.blue {
	color: var(--blue);
}

.cc-item .cv.orange {
	color: var(--orange);
}

.divider {
	height: 1px;
	background: var(--border);
	margin: 24px 0;
}

.sec-head {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 14px;
}

.sec-title {
	font-size: 14px;
	font-weight: 700;
	color: var(--navy);
	display: flex;
	align-items: center;
	gap: 8px;
}

.sec-title i {
	font-size: 17px;
	color: var(--muted);
}

.sec-badge {
	font-size: 11px;
	background: var(--bg);
	color: var(--muted);
	padding: 4px 12px;
	border-radius: 20px;
	border: 1px solid var(--border);
}

/* ═══════════════════════════════════════════════════════════
   DASHBOARD VIEW — welcome + quick modules
═══════════════════════════════════════════════════════════ */
.welcome {
	background: linear-gradient(120deg, #0f2a6b, #1d4ed8);
	border-radius: var(--radius);
	padding: 26px 32px;
	margin-bottom: 26px;
	position: relative;
	overflow: hidden;
}

.welcome h3 {
	font-family: 'DM Serif Display', serif;
	font-size: 22px;
	color: #fff;
}

.welcome p {
	font-size: 13px;
	color: #93c5fd;
	margin-top: 5px;
}

.wb-tag {
	display: inline-block;
	margin-top: 12px;
	background: rgba(255, 255, 255, .15);
	color: #bfdbfe;
	font-size: 11px;
	padding: 4px 12px;
	border-radius: 20px;
	border: 1px solid rgba(255, 255, 255, .2);
}

.wb-icon {
	position: absolute;
	right: 32px;
	top: 50%;
	transform: translateY(-50%);
}

.wb-icon i {
	font-size: 64px;
	color: #fff;
	opacity: .1;
}

.absent-card {
	background: linear-gradient(135deg, #fff7ed, #ffedd5);
	border: 1.5px solid #fed7aa;
	border-radius: var(--radius);
	padding: 16px 18px;
	display: flex;
	align-items: center;
	gap: 14px;
}

.absent-card .ab-val {
	font-size: 26px;
	font-weight: 700;
	color: var(--orange);
	line-height: 1;
}

.absent-card .ab-lbl {
	font-size: 12px;
	font-weight: 600;
	color: #9a3412;
	margin-top: 3px;
}

.absent-card .ab-sub {
	font-size: 11px;
	color: #c2410c;
	margin-top: 2px;
}

.modules {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 14px;
}

.mod-card {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	padding: 20px 16px;
	text-align: center;
	text-decoration: none;
	color: var(--text);
	transition: box-shadow .2s, transform .2s;
	position: relative;
	overflow: hidden;
}

.mod-card::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
	background: var(--cc, #2563eb);
	opacity: 0;
	transition: opacity .2s;
	border-radius: var(--radius) var(--radius) 0 0;
}

.mod-card:hover {
	box-shadow: 0 8px 24px rgba(37, 99, 235, .12);
	transform: translateY(-3px);
}

.mod-card:hover::before {
	opacity: 1;
}

.mc-icon {
	width: 44px;
	height: 44px;
	border-radius: 11px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 11px;
}

.mc-icon i {
	font-size: 22px;
}

.mc-icon.blue {
	background: var(--blue-lt);
	border: 1px solid #bfdbfe;
	color: var(--blue);
}

.mc-icon.green {
	background: var(--green-lt);
	border: 1px solid #bbf7d0;
	color: var(--green);
}

.mc-icon.amber {
	background: var(--amber-lt);
	border: 1px solid #fde68a;
	color: var(--amber);
}

.mc-icon.purple {
	background: var(--purple-lt);
	border: 1px solid #e9d5ff;
	color: var(--purple);
}

.mc-icon.teal {
	background: var(--teal-lt);
	border: 1px solid #99f6e4;
	color: var(--teal);
}

.mc-icon.red {
	background: var(--red-lt);
	border: 1px solid #fecaca;
	color: var(--red);
}

.mc-icon.cyan {
	background: #ecfeff;
	border: 1px solid #a5f3fc;
	color: #0891b2;
}

.mc-title {
	font-size: 13px;
	font-weight: 700;
	color: var(--navy);
	margin-bottom: 3px;
}

.mc-sub {
	font-size: 11px;
	color: var(--muted);
}

.mc-arrow {
	display: inline-block;
	margin-top: 10px;
	font-size: 11px;
	color: var(--blue);
	font-weight: 600;
	opacity: 0;
	transition: opacity .2s;
}

.mod-card:hover .mc-arrow {
	opacity: 1;
}

/* ═══════════════════════════════════════════════════════════
   ADD FARMER VIEW
═══════════════════════════════════════════════════════════ */
.form-card {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
	margin-bottom: 0;
}

.form-card-header {
	padding: 22px 28px;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 14px;
	background: linear-gradient(90deg, #f8faff 0%, var(--white) 100%);
}

.form-card-header .hicon {
	width: 44px;
	height: 44px;
	background: var(--blue-lt);
	border: 1px solid #bfdbfe;
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--blue);
}

.form-card-header .hicon i {
	font-size: 24px;
}

.form-card-header h3 {
	font-family: 'DM Serif Display', serif;
	font-size: 18px;
	color: var(--navy);
}

.form-card-header p {
	font-size: 12px;
	color: var(--muted);
	margin-top: 2px;
}

.form-body {
	padding: 28px;
}

.form-section {
	margin-bottom: 28px;
}

.form-section-title {
	font-size: 11px;
	font-weight: 600;
	color: var(--blue);
	text-transform: uppercase;
	letter-spacing: 1px;
	margin-bottom: 16px;
	padding-bottom: 8px;
	border-bottom: 2px solid var(--blue-lt);
	display: flex;
	align-items: center;
	gap: 8px;
}

.form-section-title i {
	font-size: 16px;
}

.form-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 18px 24px;
}

.col-span-2 {
	grid-column: span 2;
}

.field {
	display: flex;
	flex-direction: column;
	gap: 6px;
}

.field label {
	font-size: 12px;
	font-weight: 600;
	color: var(--navy);
	letter-spacing: .03em;
}

.field label .req {
	color: var(--red);
	margin-left: 2px;
}

.field input, .field select, .field textarea {
	padding: 10px 14px;
	border: 1.5px solid var(--border);
	border-radius: 9px;
	font-size: 14px;
	font-family: 'DM Sans', sans-serif;
	color: var(--text);
	background: #fafbff;
	outline: none;
	transition: border-color .2s, box-shadow .2s;
	width: 100%;
}

.field input::placeholder, .field textarea::placeholder {
	color: #b0bcd4;
}

.field input:focus, .field select:focus, .field textarea:focus {
	border-color: var(--blue);
	box-shadow: 0 0 0 3px rgba(37, 99, 235, .10);
	background: var(--white);
}

.field textarea {
	resize: vertical;
	min-height: 80px;
}

.input-wrap {
	position: relative;
}

.input-wrap .prefix {
	position: absolute;
	left: 12px;
	top: 50%;
	transform: translateY(-50%);
	font-size: 13px;
	color: var(--muted);
	pointer-events: none;
}

.input-wrap input {
	padding-left: 36px;
}

.form-footer {
	padding: 20px 28px;
	border-top: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #fafbff;
}

.form-footer .hint {
	font-size: 12px;
	color: var(--muted);
}

.btn-group {
	display: flex;
	gap: 12px;
}

.btn {
	padding: 10px 24px;
	border-radius: 9px;
	font-size: 14px;
	font-weight: 500;
	font-family: 'DM Sans', sans-serif;
	cursor: pointer;
	transition: all .18s;
	border: 1.5px solid transparent;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.btn i {
	font-size: 17px;
}

.btn-primary {
	background: var(--navy);
	color: #fff;
	border-color: var(--navy);
}

.btn-primary:hover {
	background: #0d2a6b;
	border-color: #0d2a6b;
}

.btn-primary:active {
	transform: scale(.98);
}

.btn-outline {
	background: var(--white);
	color: var(--muted);
	border-color: var(--border);
}

.btn-outline:hover {
	border-color: #b0bcd4;
	color: var(--text);
}

/* ═══════════════════════════════════════════════════════════
   FARMER LIST VIEW
═══════════════════════════════════════════════════════════ */
.toolbar {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	padding: 14px 16px;
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 14px;
}

.srch-wrap {
	flex: 1;
	position: relative;
}

.srch-wrap i {
	position: absolute;
	left: 10px;
	top: 50%;
	transform: translateY(-50%);
	font-size: 16px;
	color: var(--muted);
}

.srch-wrap input {
	width: 100%;
	border: 1px solid var(--border);
	border-radius: 8px;
	padding: 8px 12px 8px 34px;
	font-size: 13px;
	color: var(--navy);
	background: var(--bg);
	outline: none;
	font-family: inherit;
	transition: border-color .15s;
}

.srch-wrap input:focus {
	border-color: var(--blue);
}

.srch-wrap input::placeholder {
	color: var(--muted);
}

.fl-select {
	border: 1px solid var(--border);
	border-radius: 8px;
	padding: 8px 30px 8px 12px;
	font-size: 13px;
	color: var(--navy);
	background: var(--bg)
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b7a99' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E")
		no-repeat right 10px center;
	outline: none;
	font-family: inherit;
	appearance: none;
	cursor: pointer;
}

.fl-select:focus {
	border-color: var(--blue);
}

.ref-btn {
	display: flex;
	align-items: center;
	gap: 6px;
	padding: 8px 16px;
	background: var(--blue);
	color: #fff;
	border: none;
	border-radius: 8px;
	font-size: 13px;
	font-weight: 600;
	font-family: inherit;
	cursor: pointer;
	transition: background .15s;
	flex-shrink: 0;
	text-decoration: none;
}

.ref-btn:hover {
	background: #1d4ed8;
}

.ref-btn i {
	font-size: 16px;
}

.tw {
	background: var(--white);
	border-radius: var(--radius);
	border: 1px solid var(--border);
	overflow: hidden;
}

.tw-head {
	padding: 13px 20px;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.tw-head h3 {
	font-size: 14px;
	font-weight: 600;
	color: var(--navy);
}

.tw-head span {
	font-size: 12px;
	color: var(--muted);
}

table {
	width: 100%;
	border-collapse: collapse;
}

thead th {
	background: #f8faff;
	padding: 11px 16px;
	text-align: left;
	font-size: 10px;
	font-weight: 700;
	color: var(--muted);
	text-transform: uppercase;
	letter-spacing: .6px;
	border-bottom: 1px solid var(--border);
}

tbody tr {
	border-bottom: 1px solid var(--border);
	transition: background .12s;
}

tbody tr:last-child {
	border-bottom: none;
}

tbody tr:hover {
	background: #f8faff;
}

td {
	padding: 11px 16px;
	font-size: 13px;
}

.fc {
	color: var(--blue);
	font-weight: 600;
}

.fn {
	font-weight: 500;
}

.mob, .jd {
	color: var(--muted);
}

.status-badge {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 3px 10px;
	border-radius: 20px;
	font-size: 11px;
	font-weight: 600;
}

.status-badge.active {
	background: var(--green-lt);
	color: var(--green);
	border: 1px solid #bbf7d0;
}

.status-badge.inactive {
	background: var(--red-lt);
	color: var(--red);
	border: 1px solid #fecaca;
}

.status-badge i {
	font-size: 11px;
}

.action-wrap {
	display: flex;
	align-items: center;
	gap: 4px;
	flex-wrap: nowrap;
}

.vbtn {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 4px;
	padding: 6px 10px;
	border-radius: 7px;
	font-size: 11px;
	font-weight: 600;
	text-decoration: none;
	transition: all .18s;
	cursor: pointer;
	white-space: nowrap;
	border: 1px solid transparent;
	line-height: 1;
}

.vbtn i {
	font-size: 13px;
}

.vbtn-view {
	background: #eff6ff;
	color: #2563eb;
	border-color: #bfdbfe;
	width: 30px;
	height: 30px;
	padding: 0;
	border-radius: 7px;
}

.vbtn-view:hover {
	background: #2563eb;
	color: #fff;
	border-color: #2563eb;
	box-shadow: 0 2px 8px rgba(37, 99, 235, .3);
	transform: translateY(-1px);
}

.vbtn-edit {
	background: #f0fdf4;
	color: #16a34a;
	border-color: #bbf7d0;
	width: 30px;
	height: 30px;
	padding: 0;
	border-radius: 7px;
}

.vbtn-edit:hover {
	background: #16a34a;
	color: #fff;
	border-color: #16a34a;
	box-shadow: 0 2px 8px rgba(22, 163, 74, .3);
	transform: translateY(-1px);
}

.vbtn-deactivate {
	background: #fef2f2;
	color: #dc2626;
	border-color: #fecaca;
	padding: 6px 10px;
	height: 30px;
}

.vbtn-deactivate:hover {
	background: #dc2626;
	color: #fff;
	border-color: #dc2626;
	box-shadow: 0 2px 8px rgba(220, 38, 38, .25);
	transform: translateY(-1px);
}

.vbtn-reactivate {
	background: #f0fdf4;
	color: #16a34a;
	border-color: #bbf7d0;
	padding: 6px 10px;
	height: 30px;
}

.vbtn-reactivate:hover {
	background: #16a34a;
	color: #fff;
	border-color: #16a34a;
	box-shadow: 0 2px 8px rgba(22, 163, 74, .25);
	transform: translateY(-1px);
}

.vbtn-divider {
	width: 1px;
	height: 20px;
	background: var(--border);
	flex-shrink: 0;
	margin: 0 2px;
}

.empty {
	text-align: center;
	padding: 50px 20px;
	color: var(--muted);
}

.empty i {
	font-size: 40px;
	margin-bottom: 12px;
	display: block;
}

.pag {
	padding: 13px 20px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-top: 1px solid var(--border);
}

.pi {
	font-size: 12px;
	color: var(--muted);
}

.pbtns {
	display: flex;
	gap: 5px;
}

.pb {
	width: 30px;
	height: 30px;
	display: flex;
	align-items: center;
	justify-content: center;
	border: 1px solid var(--border);
	border-radius: 6px;
	background: var(--white);
	color: var(--navy);
	font-size: 12px;
	font-weight: 500;
	cursor: pointer;
}

.pb:hover {
	background: var(--bg);
}

.pb.active {
	background: var(--blue);
	color: #fff;
	border-color: var(--blue);
}

/* ═══════════════════════════════════════════════════════════
   FARMER PROFILE VIEW (viewFarmer)
═══════════════════════════════════════════════════════════ */
.profile-hero {
	background: linear-gradient(120deg, #0f2a6b, #1d4ed8);
	border-radius: var(--radius);
	padding: 28px 32px;
	display: flex;
	align-items: center;
	gap: 22px;
	margin-bottom: 20px;
	position: relative;
	overflow: hidden;
}

.profile-hero::after {
	content: '';
	position: absolute;
	right: -30px;
	top: -30px;
	width: 160px;
	height: 160px;
	background: rgba(255, 255, 255, .06);
	border-radius: 50%;
}

.ph-avatar {
	width: 64px;
	height: 64px;
	border-radius: 50%;
	background: rgba(255, 255, 255, .18);
	border: 2px solid rgba(255, 255, 255, .3);
	display: flex;
	align-items: center;
	justify-content: center;
	font-family: 'DM Serif Display', serif;
	font-size: 26px;
	color: #fff;
	flex-shrink: 0;
}

.ph-name {
	font-family: 'DM Serif Display', serif;
	font-size: 22px;
	color: #fff;
	margin-bottom: 4px;
}

.ph-meta {
	font-size: 12px;
	color: #93c5fd;
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: wrap;
}

.ph-meta span {
	display: flex;
	align-items: center;
	gap: 5px;
}

.ph-status {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	padding: 4px 14px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
	margin-top: 10px;
}

.ph-status.active {
	background: rgba(22, 163, 74, .22);
	color: #86efac;
	border: 1px solid rgba(22, 163, 74, .3);
}

.ph-status.inactive {
	background: rgba(220, 38, 38, .22);
	color: #fca5a5;
	border: 1px solid rgba(220, 38, 38, .3);
}

.detail-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 14px;
}

.detail-card {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
}

.detail-card.full {
	grid-column: span 2;
}

.dc-head {
	padding: 12px 18px;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 9px;
	background: #f8faff;
}

.dc-head i {
	font-size: 17px;
	color: var(--blue);
}

.dc-head span {
	font-size: 12px;
	font-weight: 700;
	color: var(--navy);
	text-transform: uppercase;
	letter-spacing: .5px;
}

.dc-body {
	padding: 0;
}

.dc-row {
	display: flex;
	align-items: baseline;
	padding: 11px 18px;
	border-bottom: 1px solid var(--border);
}

.dc-row:last-child {
	border-bottom: none;
}

.dc-lbl {
	font-size: 11px;
	color: var(--muted);
	font-weight: 600;
	width: 160px;
	flex-shrink: 0;
}

.dc-val {
	font-size: 13px;
	color: var(--navy);
	font-weight: 500;
}

.dc-val.code {
	color: var(--blue);
	font-weight: 700;
}

.profile-actions {
	display: flex;
	gap: 12px;
	margin-top: 18px;
}

.pa-btn {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 22px;
	border-radius: 9px;
	font-size: 13px;
	font-weight: 600;
	text-decoration: none;
	cursor: pointer;
	border: 1.5px solid transparent;
	font-family: inherit;
	transition: all .18s;
}

.pa-btn.edit {
	background: var(--navy);
	color: #fff;
	border-color: var(--navy);
}

.pa-btn.edit:hover {
	background: #0d2a6b;
}

.pa-btn.back {
	background: var(--white);
	color: var(--muted);
	border-color: var(--border);
}

.pa-btn.back:hover {
	border-color: #b0bcd4;
	color: var(--text);
}

.pa-btn.deactivate {
	background: var(--red-lt);
	color: var(--red);
	border-color: #fecaca;
}

.pa-btn.deactivate:hover {
	background: var(--red);
	color: #fff;
}

.pa-btn.reactivate {
	background: var(--green-lt);
	color: var(--green);
	border-color: #bbf7d0;
}

.pa-btn.reactivate:hover {
	background: var(--green);
	color: #fff;
}

.pa-btn i {
	font-size: 16px;
}

/* ═══════════════════════════════════════════════════════════
   EDIT FARMER VIEW
═══════════════════════════════════════════════════════════ */
.ef-header {
	display: flex;
	align-items: center;
	gap: 16px;
	margin-bottom: 24px;
}

.ef-avatar {
	width: 52px;
	height: 52px;
	border-radius: 50%;
	background: var(--blue-lt);
	border: 1px solid #bfdbfe;
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--blue);
	font-size: 17px;
	font-weight: 700;
	flex-shrink: 0;
}

.ef-name {
	font-size: 20px;
	font-weight: 700;
	color: var(--navy);
	margin: 0 0 3px;
}

.ef-meta-line {
	font-size: 12px;
	color: var(--muted);
	display: flex;
	align-items: center;
	gap: 5px;
}

.ef-meta-line i {
	font-size: 14px;
}

.ef-card {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
	margin-bottom: 14px;
}

.ef-sec-lbl {
	font-size: 10px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: .7px;
	color: var(--muted);
	padding: 9px 20px 8px;
	background: #f8fafd;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 7px;
}

.ef-sec-lbl i {
	font-size: 15px;
}

.ef-fields {
	display: grid;
	grid-template-columns: 1fr 1fr;
}

.ef-field {
	padding: 14px 20px;
	border-right: 1px solid var(--border);
	border-bottom: 1px solid var(--border);
}

.ef-field:nth-child(2n) {
	border-right: none;
}

.ef-field.full {
	grid-column: 1/-1;
	border-right: none;
}

.ef-field label {
	display: flex;
	align-items: center;
	gap: 5px;
	font-size: 11px;
	font-weight: 600;
	color: var(--muted);
	text-transform: uppercase;
	letter-spacing: .4px;
	margin-bottom: 7px;
}

.ef-field label i {
	font-size: 13px;
}

.ef-field input[type=text], .ef-field input[type=email], .ef-field textarea
	{
	width: 100%;
	background: transparent;
	border: none;
	outline: none;
	font-size: 14px;
	font-weight: 600;
	color: var(--navy);
	font-family: 'DM Sans', sans-serif;
	padding: 0;
	resize: none;
}

.ef-field input::placeholder, .ef-field textarea::placeholder {
	color: #c4cdd8;
	font-weight: 400;
}

.ef-field input[readonly] {
	color: var(--muted);
}

.ro-wrap {
	display: flex;
	align-items: center;
	gap: 7px;
}

.ro-wrap i {
	font-size: 13px;
	color: #c4cdd8;
	flex-shrink: 0;
}

.ef-actions {
	display: flex;
	gap: 10px;
	padding-top: 4px;
}

.btn-save {
	flex: 1;
	padding: 12px;
	background: var(--navy);
	color: #fff;
	border: none;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 600;
	font-family: 'DM Sans', sans-serif;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	transition: background .18s;
}

.btn-save:hover {
	background: #1e3a6b;
}

.btn-save i {
	font-size: 17px;
}

.btn-back-ef {
	padding: 12px 20px;
	background: var(--white);
	color: var(--muted);
	border: 1px solid var(--border);
	border-radius: 10px;
	font-size: 14px;
	font-weight: 600;
	font-family: 'DM Sans', sans-serif;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	text-decoration: none;
	transition: background .18s;
}

.btn-back-ef:hover {
	background: var(--bg);
}

.btn-back-ef i {
	font-size: 17px;
}

/* ═══════════════════════════════════════════════════════════
   MODALS (deactivate / reactivate)
═══════════════════════════════════════════════════════════ */
.modal-overlay {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, .45);
	z-index: 200;
	align-items: center;
	justify-content: center;
}

.modal-overlay.show {
	display: flex;
}

.modal {
	background: #fff;
	border-radius: var(--radius);
	padding: 28px;
	width: 400px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, .2);
}

.modal-icon {
	width: 52px;
	height: 52px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 16px;
	font-size: 24px;
}

.modal-icon.red {
	background: var(--red-lt);
	color: var(--red);
}

.modal-icon.green {
	background: var(--green-lt);
	color: var(--green);
}

.modal h3 {
	text-align: center;
	font-size: 16px;
	font-weight: 700;
	color: var(--navy);
	margin-bottom: 8px;
}

.modal p {
	text-align: center;
	font-size: 13px;
	color: var(--muted);
	margin-bottom: 24px;
	line-height: 1.6;
}

.modal p strong {
	color: var(--navy);
}

.modal-btns {
	display: flex;
	gap: 10px;
}

.modal-btns a, .modal-btns button {
	flex: 1;
	padding: 10px;
	border-radius: 8px;
	font-size: 13px;
	font-weight: 600;
	text-align: center;
	text-decoration: none;
	border: none;
	cursor: pointer;
	font-family: inherit;
}

.btn-cancel {
	background: var(--bg);
	color: var(--navy);
	border: 1px solid var(--border) !important;
}

.btn-cancel:hover {
	border-color: var(--muted) !important;
}

.btn-confirm-red {
	background: var(--red);
	color: #fff;
}

.btn-confirm-red:hover {
	background: #b91c1c;
}

.btn-confirm-green {
	background: var(--green);
	color: #fff;
}

.btn-confirm-green:hover {
	background: #15803d;
}

/* ═══════════════════════════════════════════════════════════
   WIP / UNDER CONSTRUCTION VIEW
═══════════════════════════════════════════════════════════ */
.wip-card {
	background: var(--white);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
}

.wip-hero {
	background: linear-gradient(120deg, #0f2a6b, #1d4ed8);
	padding: 40px 32px;
	text-align: center;
	position: relative;
	overflow: hidden;
}

.wip-hero::before {
	content: '';
	position: absolute;
	width: 260px;
	height: 260px;
	background: rgba(255, 255, 255, .06);
	border-radius: 50%;
	top: -80px;
	right: -60px;
}

.wip-hero::after {
	content: '';
	position: absolute;
	width: 180px;
	height: 180px;
	background: rgba(255, 255, 255, .04);
	border-radius: 50%;
	bottom: -60px;
	left: -40px;
}

.wip-icon-wrap {
	width: 72px;
	height: 72px;
	background: rgba(255, 255, 255, .15);
	border: 2px solid rgba(255, 255, 255, .25);
	border-radius: 20px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 18px;
	position: relative;
	z-index: 1;
}

.wip-icon-wrap i {
	font-size: 34px;
	color: #fff;
}

.wip-hero h2 {
	font-family: 'DM Serif Display', serif;
	font-size: 24px;
	color: #fff;
	margin-bottom: 8px;
	position: relative;
	z-index: 1;
}

.wip-hero p {
	font-size: 13px;
	color: #93c5fd;
	position: relative;
	z-index: 1;
}

.wip-body {
	padding: 28px 32px;
}

.wip-status-row {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	margin-bottom: 24px;
}

.wip-badge {
	display: inline-flex;
	align-items: center;
	gap: 7px;
	padding: 7px 16px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.wip-badge.building {
	background: #fffbeb;
	color: #92400e;
	border: 1px solid #fde68a;
}

.wip-badge.planned {
	background: var(--blue-lt);
	color: #1e40af;
	border: 1px solid #bfdbfe;
}

.wip-badge i {
	font-size: 14px;
}

.wip-features {
	margin-bottom: 24px;
}

.wip-features h4 {
	font-size: 12px;
	font-weight: 700;
	color: var(--muted);
	text-transform: uppercase;
	letter-spacing: .6px;
	margin-bottom: 12px;
}

.feat-chips {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.feat-chip {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	padding: 6px 14px;
	background: var(--bg);
	border: 1px solid var(--border);
	border-radius: 8px;
	font-size: 12px;
	color: var(--navy);
	font-weight: 500;
}

.feat-chip i {
	font-size: 14px;
	color: var(--muted);
}

.wip-back {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	padding: 10px 22px;
	background: var(--navy);
	color: #fff;
	border-radius: 9px;
	text-decoration: none;
	font-size: 13px;
	font-weight: 600;
	transition: background .18s;
}

.wip-back:hover {
	background: #0d2a6b;
}

.wip-back i {
	font-size: 16px;
}
</style>
</head>
<body>

	<!-- ═══════════════════════════════════════════════════════
     SIDEBAR — always visible
═══════════════════════════════════════════════════════════ -->
	<aside class="sidebar">
		<div class="sb-brand">
			<h1>
				Milk<span>Mitra</span>
			</h1>
			<p>Admin Portal</p>
		</div>
		<div class="sb-user">
			<div class="sb-av"><%=username.substring(0, 1).toUpperCase()%></div>
			<div>
				<div class="sb-un"><%=username%></div>
				<div class="sb-ur"><%=role%></div>
			</div>
		</div>
		<nav class="sb-nav">
			<div class="nl">Menu</div>
			<a href="AdminDashboardServlet?view=dashboard"
				class="ni <%="dashboard".equals(currentView) ? "active" : ""%>">
				<i class="ti ti-home"></i>Dashboard
			</a>

			<div class="nl">Farmer Management</div>
			<a href="AdminDashboardServlet?view=addFarmer"
				class="ni <%="addFarmer".equals(currentView) ? "active" : ""%>">
				<i class="ti ti-user-plus"></i>Add Farmer
			</a> <a href="FarmerListServlet?view=farmerList"
				class="ni <%="farmerList".equals(currentView) || "viewFarmer".equals(currentView) || "editFarmer".equals(currentView)
		? "active"
		: ""%>">
				<i class="ti ti-users"></i>View Farmers
			</a>
			<div class="nav-note">Edit · Deactivate · Reactivate inside
				View Farmers</div>

			<div class="nl">Operations</div>
			<a href="milkcollection.jsp" class="ni"><i class="ti ti-droplet"></i>Milk
				Collection</a> <a href="milkcollectionReportServlet?view=today"
				class="ni"><i class="ti ti-droplet-filled-2"></i>Collection
				Report</a> <a href="AdminDashboardServlet?view=payments"
				class="ni <%="payments".equals(currentView) ? "active" : ""%>"><i
				class="ti ti-cash"></i>Payments</a> <a
				href="AdminDashboardServlet?view=feedStore"
				class="ni <%="feedStore".equals(currentView) ? "active" : ""%>"><i
				class="ti ti-wheat"></i>Feed Store</a>

			<div class="nl">Reports & Settings</div>
			<a href="AdminDashboardServlet?view=reports"
				class="ni <%="reports".equals(currentView) ? "active" : ""%>"><i
				class="ti ti-chart-bar"></i>Reports</a> <a
				href="AdminDashboardServlet?view=priceConfig"
				class="ni <%="priceConfig".equals(currentView) ? "active" : ""%>"><i
				class="ti ti-currency-rupee"></i>Price Config</a>
		</nav>
		<div class="sb-foot">
			<a href="Logout" class="lo-btn"><i class="ti ti-logout"></i>Logout</a>
		</div>
	</aside>

	<!-- ═══════════════════════════════════════════════════════
     MAIN
═══════════════════════════════════════════════════════════ -->
	<div class="main">

		<!-- TOPBAR -->
		<div class="topbar">
			<div class="tb-l">
				<h2 id="topbarTitle"><%=pageTitle%></h2>
				<p id="topbarSub">
					<%
					if ("dashboard".equals(currentView)) {
					%>Overview of your dairy operations
					<%
					} else if ("addFarmer".equals(currentView)) {
					%>Register a new farmer to MilkMitra
					<%
					} else if ("farmerList".equals(currentView)) {
					%>Manage and monitor registered farmers
					<%
					} else if ("viewFarmer".equals(currentView) && farmer != null) {
					%>Viewing profile of
					<%=farmer.getFarmerName()%>
					<%
					} else if ("editFarmer".equals(currentView) && farmer != null) {
					%>Editing profile of
					<%=farmer.getFarmerName()%>
					<%
					} else if ("payments".equals(currentView)) {
					%>10-day cycle payment management
					<%
					} else if ("feedStore".equals(currentView)) {
					%>Feed orders and installments
					<%
					} else if ("reports".equals(currentView)) {
					%>Analytics and export reports
					<%
					} else if ("priceConfig".equals(currentView)) {
					%>Configure milk rate formulas
					<%
					}
					%>
				</p>
			</div>
			<div class="tb-r">
				<div class="tb-date" id="dateStr"></div>
			</div>
		</div>

		<!-- CONTENT SWITCHER -->
		<div class="content">

			<!-- FLASH MESSAGES (all views) -->
			<%
			if (successMsg != null) {
			%>
			<div class="alert alert-success">
				<i class="ti ti-circle-check"></i><%=successMsg%></div>
			<%
			}
			%>
			<%
			if (errorMsg != null) {
			%>
			<div class="alert alert-error">
				<i class="ti ti-alert-circle"></i><%=errorMsg%></div>
			<%
			}
			%>

			<!-- ══════════════════════════════════════════════════
             VIEW: dashboard
        ══════════════════════════════════════════════════ -->
			<%
			if ("dashboard".equals(currentView)) {
			%>

			<!-- Welcome Banner -->
			<div class="welcome">
				<div>
					<h3 id="greeting">
						Good morning,
						<%=username%>
						👋
					</h3>
					<p>Here's what's happening across MilkMitra today.</p>
					<span class="wb-tag">Admin · Full Access · Dudhshree MPP</span>
				</div>
				<div class="wb-icon">
					<i class="ti ti-droplet"></i>
				</div>
			</div>

			<!-- Today's Collection -->
			<div class="sec-head">
				<div class="sec-title">
					<i class="ti ti-calendar-today"></i>Today's Collection
				</div>
				<div class="sec-badge">
					📅
					<%=todayStr%></div>
			</div>

			<div class="grid-2">
				<div class="cc teal">
					<div class="cc-head">
						<div class="si teal">
							<i class="ti ti-clipboard-list"></i>
						</div>
						<div>
							<div class="cc-title">Shift Entries</div>
							<div class="cc-sub">
								Total:
								<%=todayEntries%>
								collections today
							</div>
						</div>
					</div>
					<div class="cc-grid">
						<div class="cc-item">
							<div class="cl">☀️ Morning</div>
							<div class="cv teal"><%=morningEntries%></div>
						</div>
						<div class="cc-item">
							<div class="cl">🌙 Evening</div>
							<div class="cv blue"><%=eveningEntries%></div>
						</div>
					</div>
				</div>

				<div class="cc blue">
					<div class="cc-head">
						<div class="si blue">
							<i class="ti ti-droplet"></i>
						</div>
						<div>
							<div class="cc-title">Milk Collected</div>
							<div class="cc-sub">
								Total:
								<%=String.format("%.2f", todayTotalLtr)%>
								litres today
							</div>
						</div>
					</div>
					<div class="cc-grid">
						<div class="cc-item">
							<div class="cl">🐄 Cow Milk</div>
							<div class="cv green"><%=String.format("%.2f", todayCowLtr)%>
								L
							</div>
						</div>
						<div class="cc-item">
							<div class="cl">🐃 Buffalo Milk</div>
							<div class="cv amber"><%=String.format("%.2f", todayBufLtr)%>
								L
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="grid-4">
				<div class="sc green">
					<div class="si green">
						<i class="ti ti-coin-rupee"></i>
					</div>
					<div class="sc-body">
						<div class="val">
							₹<%=String.format("%.2f", todayValue)%></div>
						<div class="lbl">Today's Value</div>
						<div class="sub">Est. payout</div>
					</div>
				</div>
				<div class="sc teal">
					<div class="si teal">
						<i class="ti ti-chart-dots"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=String.format("%.2f", avgFat)%>%
						</div>
						<div class="lbl">Average FAT</div>
						<div class="sub">Today's average</div>
					</div>
				</div>
				<div class="sc blue">
					<div class="si blue">
						<i class="ti ti-chart-dots-2"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=String.format("%.2f", avgSnf)%>%
						</div>
						<div class="lbl">Average SNF</div>
						<div class="sub">Today's average</div>
					</div>
				</div>
				<div class="sc purple">
					<div class="si purple">
						<i class="ti ti-wheat"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=pendingFeedOrders%></div>
						<div class="lbl">Feed Orders</div>
						<div class="sub">Pending delivery</div>
					</div>
				</div>
			</div>

			<div class="absent-card" style="margin-bottom: 24px;">
				<div class="si orange">
					<i class="ti ti-user-exclamation"></i>
				</div>
				<div>
					<div class="ab-val"><%=absentToday%></div>
					<div class="ab-lbl">Absent Farmers Today</div>
					<div class="ab-sub">
						Active farmers who gave milk yesterday but have not collected
						today yet.<%
					if (absentToday == 0) {
					%>
						✅ All active farmers have collected today!<%
					}
					%>
					</div>
				</div>
			</div>

			<div class="divider"></div>

			<!-- Farmer Overview -->
			<div class="sec-head">
				<div class="sec-title">
					<i class="ti ti-users"></i>Farmer Overview
				</div>
			</div>
			<div class="grid-4">
				<div class="sc blue">
					<div class="si blue">
						<i class="ti ti-users"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=totalFarmers%></div>
						<div class="lbl">Total Farmers</div>
						<div class="sub">All registered</div>
					</div>
				</div>
				<div class="sc green">
					<div class="si green">
						<i class="ti ti-user-check"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=activeFarmers%></div>
						<div class="lbl">Active Farmers</div>
						<div class="sub">Currently supplying</div>
					</div>
				</div>
				<div class="sc amber">
					<div class="si amber">
						<i class="ti ti-cash"></i>
					</div>
					<div class="sc-body">
						<div class="val">
							₹<%=String.format("%.0f", pendingPayments)%></div>
						<div class="lbl">Pending Payments</div>
						<div class="sub">Awaiting release</div>
					</div>
				</div>
				<div class="sc red">
					<div class="si red">
						<i class="ti ti-alert-triangle"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=lowStockItems%></div>
						<div class="lbl">Low Stock Alerts</div>
						<div class="sub">Inventory items</div>
					</div>
				</div>
			</div>

			<div class="divider"></div>

			<!-- Quick Access -->
			<div class="sec-head">
				<div class="sec-title">
					<i class="ti ti-layout-grid"></i>Quick Access
				</div>
			</div>
			<div class="modules">
				<a href="FarmerListServlet?view=farmerList" class="mod-card"
					style="--cc: #2563eb;">
					<div class="mc-icon blue">
						<i class="ti ti-users"></i>
					</div>
					<div class="mc-title">Manage Farmers</div>
					<div class="mc-sub">View · Edit · Deactivate</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="AdminDashboardServlet?view=addFarmer" class="mod-card"
					style="--cc: #16a34a;">
					<div class="mc-icon green">
						<i class="ti ti-user-plus"></i>
					</div>
					<div class="mc-title">Add Farmer</div>
					<div class="mc-sub">Register new farmer</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="milkcollection.jsp" class="mod-card"
					style="--cc: #0d9488;">
					<div class="mc-icon teal">
						<i class="ti ti-droplet"></i>
					</div>
					<div class="mc-title">Milk Collection</div>
					<div class="mc-sub">Morning &amp; evening entry</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="AdminDashboardServlet?view=payments" class="mod-card"
					style="--cc: #d97706;">
					<div class="mc-icon amber">
						<i class="ti ti-cash"></i>
					</div>
					<div class="mc-title">Payments</div>
					<div class="mc-sub">10-day cycle payments</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="AdminDashboardServlet?view=feedStore" class="mod-card"
					style="--cc: #7c3aed;">
					<div class="mc-icon purple">
						<i class="ti ti-wheat"></i>
					</div>
					<div class="mc-title">Feed Store</div>
					<div class="mc-sub">Orders &amp; installments</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="AdminDashboardServlet?view=priceConfig" class="mod-card"
					style="--cc: #dc2626;">
					<div class="mc-icon red">
						<i class="ti ti-currency-rupee"></i>
					</div>
					<div class="mc-title">Price Config</div>
					<div class="mc-sub">Update rate formulas</div>
					<div class="mc-arrow">Open →</div>
				</a> <a href="AdminDashboardServlet?view=reports" class="mod-card"
					style="--cc: #0891b2;">
					<div class="mc-icon cyan">
						<i class="ti ti-chart-bar"></i>
					</div>
					<div class="mc-title">Reports</div>
					<div class="mc-sub">Analytics &amp; exports</div>
					<div class="mc-arrow">Open →</div>
				</a>
			</div>

			<!-- ══════════════════════════════════════════════════
             VIEW: addFarmer
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("addFarmer".equals(currentView)) {
			%>

			<!-- Breadcrumb -->
			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Add Farmer</span>
			</div>

			<div class="form-card">
				<div class="form-card-header">
					<div class="hicon">
						<i class="ti ti-user-plus"></i>
					</div>
					<div>
						<h3>New Farmer Registration</h3>
						<p>
							Fill in the details below. Fields marked <span
								style="color: var(--red)">*</span> are required.
						</p>
					</div>
				</div>

				<form action="AddFarmerServlet" method="post">
					<div class="form-body">
						<div class="form-section">
							<div class="form-section-title">
								<i class="ti ti-user"></i>Basic Information
							</div>
							<div class="form-grid">
								<div class="field">
									<label>Farmer Name <span class="req">*</span></label> <input
										type="text" name="farmerName" placeholder="e.g. Ramesh Ghosh"
										required />
								</div>
								<div class="field">
									<label>Mobile Number <span class="req">*</span></label>
									<div class="input-wrap">
										<span class="prefix">+91</span> <input type="tel"
											name="mobile" placeholder="9876543210" maxlength="10"
											required />
									</div>
								</div>
								<div class="field">
									<label>Email Address</label> <input type="email" name="email"
										placeholder="farmer@example.com" />
								</div>
								<div class="field">
									<label>Aadhaar Number <span class="req">*</span></label> <input
										type="text" name="andharNo" placeholder="XXXX XXXX XXXX"
										maxlength="12" required />
								</div>
								<div class="field col-span-2">
									<label>Address <span class="req">*</span></label>
									<textarea name="address"
										placeholder="Village, Taluka, District, State..." required></textarea>
								</div>
							</div>
						</div>

						<div class="form-section">
							<div class="form-section-title">
								<i class="ti ti-building-bank"></i>Bank Details
							</div>
							<div class="form-grid">
								<div class="field">
									<label>Account Holder Name <span class="req">*</span></label> <input
										type="text" name="accountHolderName"
										placeholder="As per bank records" required />
								</div>
								<div class="field">
									<label>Bank Account Number <span class="req">*</span></label> <input
										type="text" name="bankAccountNo"
										placeholder="e.g. 012345678901" required />
								</div>
								<div class="field">
									<label>IFSC Code <span class="req">*</span></label> <input
										type="text" name="ifscCode" id="ifscInput"
										placeholder="e.g. SBIN0001234"
										style="text-transform: uppercase" maxlength="11" required />
								</div>
								<div class="field">
									<label>Bank Name <span class="req">*</span></label> <input
										type="text" name="bankName"
										placeholder="e.g. State Bank of India" required />
								</div>
							</div>
						</div>
					</div>

					<div class="form-footer">
						<span class="hint">Farmer Code will be auto-generated after
							submission.</span>
						<div class="btn-group">
							<a href="AdminDashboardServlet?view=dashboard"
								class="btn btn-outline"><i class="ti ti-x"></i>Cancel</a>
							<button type="submit" class="btn btn-primary">
								<i class="ti ti-user-plus"></i>Add Farmer
							</button>
						</div>
					</div>
				</form>
			</div>

			<!-- ══════════════════════════════════════════════════
             VIEW: farmerList
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("farmerList".equals(currentView)) {
			%>

			<%
			if (selectedFarmer != null) {
			%>
			<h1 style="color: red;">
				FARMER FOUND :
				<%=selectedFarmer.getFarmerName()%>
			</h1>
			<%
			}
			%>

			<!-- Breadcrumb -->
			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Farmer Management</span> <i
					class="ti ti-chevron-right"></i> <span>View Farmers</span>
			</div>

			<!-- Stats -->
			<div class="grid-4" style="margin-bottom: 14px;">
				<div class="sc blue">
					<div class="si blue">
						<i class="ti ti-users"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=farmerTotal%></div>
						<div class="lbl">All Farmers</div>
					</div>
				</div>
				<div class="sc green">
					<div class="si green">
						<i class="ti ti-user-check"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=activeCount%></div>
						<div class="lbl">Active Farmers</div>
					</div>
				</div>
				<div class="sc red">
					<div class="si red">
						<i class="ti ti-user-x"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=inactiveCount%></div>
						<div class="lbl">Inactive Farmers</div>
					</div>
				</div>
				<div class="sc amber">
					<div class="si amber">
						<i class="ti ti-calendar-stats"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=joinedThisMonth%></div>
						<div class="lbl">Joined This Month</div>
					</div>
				</div>
			</div>

			<!-- Toolbar -->
			<div class="toolbar">
				<div class="srch-wrap">
					<i class="ti ti-search"></i> <input type="text" id="srch"
						placeholder="Search by Code / Name / Mobile..."
						oninput="doFilter()">
				</div>
				<select class="fl-select" id="filt" onchange="doFilter()">
					<option value="all">All Farmers</option>
					<option value="active">Active Only</option>
					<option value="inactive">Inactive Only</option>
					<option value="thismonth">Joined This Month</option>
				</select> <a href="FarmerListServlet?view=farmerList" class="ref-btn"><i
					class="ti ti-refresh"></i>Refresh</a>
			</div>

			<!-- Table -->
			<div class="tw">
				<div class="tw-head">
					<h3>Registered Farmers</h3>
					<span>Showing <span id="sc2"><%=farmerTotal%></span> of <%=farmerTotal%>
						farmers
					</span>
				</div>
				<table>
					<thead>
						<tr>
							<th style="width: 46px">#</th>
							<th style="width: 120px">Code</th>
							<th>Farmer Name</th>
							<th style="width: 150px">Mobile</th>
							<th style="width: 140px">Joining Date</th>
							<th style="width: 90px">Status</th>
							<th style="width: 180px">Actions</th>
						</tr>
					</thead>
					<tbody id="tb">
						<%
						if (farmers != null && !farmers.isEmpty()) {
							int i = 1;
							for (Farmer f : farmers) {
								String dateStr2 = (f.getJoiningDate() != null) ? f.getJoiningDate().toString() : "";
								String dateDisp = (f.getJoiningDate() != null)
								? String.format("%02d-%s-%d", f.getJoiningDate().getDayOfMonth(),
										f.getJoiningDate().getMonth().toString().substring(0, 1)
												+ f.getJoiningDate().getMonth().toString().substring(1, 3).toLowerCase(),
										f.getJoiningDate().getYear())
								: "—";
								String statusVal = f.isActive() ? "active" : "inactive";
						%>
						<tr data-code="<%=f.getFarmerCode().toLowerCase()%>"
							data-name="<%=f.getFarmerName().toLowerCase()%>"
							data-mob="<%=f.getMobile()%>" data-date="<%=dateStr2%>"
							data-status="<%=statusVal%>">
							<td style="color: var(--muted);"><%=i++%></td>
							<td><span class="fc"><%=f.getFarmerCode()%></span></td>
							<td><span class="fn"><%=f.getFarmerName()%></span></td>
							<td><span class="mob"><%=f.getMobile()%></span></td>
							<td><span class="jd"><%=dateDisp%></span></td>
							<td>
								<%
								if (f.isActive()) {
								%> <span class="status-badge active"><i
									class="ti ti-circle-filled"></i>Active</span> <%
 } else {
 %> <span class="status-badge inactive"><i
									class="ti ti-circle-filled"></i>Inactive</span> <%
 }
 %>
							</td>
							<td>
								<div class="action-wrap">
									<a href="ViewFarmerServlet?farmerCode=<%=f.getFarmerCode()%>"
										class="vbtn vbtn-view" title="View Profile"> <i
										class="ti ti-eye"></i>
									</a> <a
										href="LoadEditFarmerServlet?farmerCode=<%=f.getFarmerCode()%>"
										class="vbtn vbtn-edit" title="Edit Farmer"> <i
										class="ti ti-pencil"></i>
									</a>
									<div class="vbtn-divider"></div>
									<%
									if (f.isActive()) {
									%>
									<a href="#" class="vbtn vbtn-deactivate"
										title="Deactivate Farmer"
										onclick="showModal('deactivate','<%=f.getFarmerCode()%>','<%=f.getFarmerName()%>'); return false;">
										<i class="ti ti-user-off"></i>Deactivate
									</a>
									<%
									} else {
									%>
									<a href="#" class="vbtn vbtn-reactivate"
										title="Reactivate Farmer"
										onclick="showModal('reactivate','<%=f.getFarmerCode()%>','<%=f.getFarmerName()%>'); return false;">
										<i class="ti ti-user-check"></i>Reactivate
									</a>
									<%
									}
									%>
								</div>
							</td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="7">
								<div class="empty">
									<i class="ti ti-users-group"></i>
									<p>
										No farmers found. <a
											href="AdminDashboardServlet?view=addFarmer"
											style="color: var(--blue);">Add a farmer</a> to get started.
									</p>
								</div>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				<div class="pag">
					<span class="pi" id="pi">Showing 1 to <%=farmerTotal%> of <%=farmerTotal%>
						farmers
					</span>
					<div class="pbtns">
						<div class="pb">
							<i class="ti ti-chevrons-left"></i>
						</div>
						<div class="pb active">1</div>
						<div class="pb">
							<i class="ti ti-chevrons-right"></i>
						</div>
					</div>
				</div>
			</div>

			<!-- ══════════════════════════════════════════════════
             VIEW: viewFarmer
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("viewFarmer".equals(currentView)) {
			if (farmer == null) {
			%>
			<div class="alert alert-error">
				<i class="ti ti-alert-circle"></i>Farmer not found. <a
					href="AdminDashboardServlet?view=farmerList">Go back to list</a>.
			</div>
			<%
			} else {
			%>

			<!-- Breadcrumb -->
			<div class="bc">
				<a href="FarmerListServlet?view=farmerList">View Farmers</a> <i
					class="ti ti-chevron-right"></i> <a
					href="AdminDashboardServlet?view=farmerList">View Farmers</a> <i
					class="ti ti-chevron-right"></i> <span><%=farmer.getFarmerName()%></span>
			</div>

			<!-- Hero -->
			<div class="profile-hero">
				<div class="ph-avatar"><%=farmer.getFarmerName() != null && farmer.getFarmerName().length() > 0
		? farmer.getFarmerName().substring(0, 1).toUpperCase()
		: "F"%></div>
				<div>
					<div class="ph-name"><%=farmer.getFarmerName()%></div>
					<div class="ph-meta">
						<span><i class="ti ti-hash"></i> <%=farmer.getFarmerCode()%></span>
						<span><i class="ti ti-phone"></i> <%=farmer.getMobile()%></span>
						<%
						if (farmer.getEmail() != null && !farmer.getEmail().isEmpty()) {
						%>
						<span><i class="ti ti-mail"></i> <%=farmer.getEmail()%></span>
						<%
						}
						%>
					</div>
					<div
						class="ph-status <%=farmer.isActive() ? "active" : "inactive"%>">
						<i class="ti ti-circle-filled"></i>
						<%=farmer.isActive() ? "Active" : "Inactive"%>
					</div>
				</div>
			</div>

			<!-- Detail cards -->
			<div class="detail-grid">
				<!-- Personal -->
				<div class="detail-card">
					<div class="dc-head">
						<i class="ti ti-user"></i><span>Personal Information</span>
					</div>
					<div class="dc-body">
						<div class="dc-row">
							<span class="dc-lbl">Farmer Code</span><span class="dc-val code"><%=farmer.getFarmerCode()%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Full Name</span><span class="dc-val"><%=farmer.getFarmerName()%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Mobile</span><span class="dc-val">+91
								<%=farmer.getMobile()%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Email</span><span class="dc-val"><%=(farmer.getEmail() != null && !farmer.getEmail().isEmpty()) ? farmer.getEmail() : "—"%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Aadhaar No.</span><span class="dc-val"><%=(farmer.getAndharNo() != null) ? farmer.getAndharNo() : "—"%></span>
						</div>
						<%
						if (farmer.getJoiningDate() != null) {
						%>
						<div class="dc-row">
							<span class="dc-lbl">Joining Date</span><span class="dc-val"><%=farmer.getJoiningDate()%></span>
						</div>
						<%
						}
						%>
					</div>
				</div>

				<!-- Bank -->
				<div class="detail-card">
					<div class="dc-head">
						<i class="ti ti-building-bank"></i><span>Bank Details</span>
					</div>
					<div class="dc-body">
						<div class="dc-row">
							<span class="dc-lbl">Account Holder</span><span class="dc-val"><%=(farmer.getAccountHolderName() != null) ? farmer.getAccountHolderName() : "—"%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Account Number</span><span class="dc-val"><%=(farmer.getAccountNo() != null) ? farmer.getAccountNo() : "—"%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">Bank Name</span><span class="dc-val"><%=(farmer.getBankName() != null) ? farmer.getBankName() : "—"%></span>
						</div>
						<div class="dc-row">
							<span class="dc-lbl">IFSC Code</span><span class="dc-val"><%=(farmer.getIfscCode() != null) ? farmer.getIfscCode() : "—"%></span>
						</div>
					</div>
				</div>

				<!-- Address -->
				<div class="detail-card full">
					<div class="dc-head">
						<i class="ti ti-map-pin"></i><span>Address</span>
					</div>
					<div class="dc-body">
						<div class="dc-row">
							<span class="dc-lbl">Full Address</span><span class="dc-val"><%=(farmer.getAddress() != null && !farmer.getAddress().isEmpty()) ? farmer.getAddress() : "—"%></span>
						</div>
					</div>
				</div>
			</div>

			<!-- Profile Actions -->
			<div class="profile-actions">
				<a href="AdminDashboardServlet?view=farmerList" class="pa-btn back"><i
					class="ti ti-arrow-left"></i>Back to List</a> <a
					href="LoadEditFarmerServlet?farmerCode=<%=farmer.getFarmerCode()%>"
					class="pa-btn edit"><i class="ti ti-pencil"></i>Edit Farmer</a>
				<%
				if (farmer.isActive()) {
				%>
				<a href="#" class="pa-btn deactivate"
					onclick="showModal('deactivate','<%=farmer.getFarmerCode()%>','<%=farmer.getFarmerName()%>'); return false;">
					<i class="ti ti-user-off"></i>Deactivate
				</a>
				<%
				} else {
				%>
				<a href="#" class="pa-btn reactivate"
					onclick="showModal('reactivate','<%=farmer.getFarmerCode()%>','<%=farmer.getFarmerName()%>'); return false;">
					<i class="ti ti-user-check"></i>Reactivate
				</a>
				<%
				}
				%>
			</div>

			<%
			}
			%>

			<!-- ══════════════════════════════════════════════════
             VIEW: editFarmer
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("editFarmer".equals(currentView)) {
			if (farmer == null) {
			%>
			<div class="alert alert-error">
				<i class="ti ti-alert-circle"></i>Farmer not found. <a
					href="AdminDashboardServlet?view=farmerList">Go back to list</a>.
			</div>
			<%
			} else {
			%>

			<!-- Breadcrumb -->
			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <a
					href="AdminDashboardServlet?view=farmerList">View Farmers</a> <i
					class="ti ti-chevron-right"></i> <span>Edit · <%=farmer.getFarmerName()%></span>
			</div>

			<!-- Header -->
			<div class="ef-header">
				<div class="ef-avatar"><%=farmer.getFarmerName() != null && farmer.getFarmerName().length() > 0
		? farmer.getFarmerName().substring(0, 1).toUpperCase()
		: "F"%></div>
				<div>
					<p class="ef-name"><%=farmer.getFarmerName()%></p>
					<p class="ef-meta-line">
						<i class="ti ti-hash"></i><%=farmer.getFarmerCode()%>
						&nbsp;·&nbsp; Edit farmer profile
					</p>
				</div>
			</div>

			<form action="EditFarmerServlet" method="post">
				<input type="hidden" name="farmerCode"
					value="<%=farmer.getFarmerCode()%>"> <input type="hidden"
					name="returnTo" value="AdminDashboard">

				<!-- Personal -->
				<div class="ef-card">
					<div class="ef-sec-lbl">
						<i class="ti ti-user"></i>Personal information
					</div>
					<div class="ef-fields">
						<div class="ef-field">
							<label><i class="ti ti-hash"></i>Farmer code</label>
							<div class="ro-wrap">
								<input type="text" value="<%=farmer.getFarmerCode()%>" readonly>
								<i class="ti ti-lock"></i>
							</div>
						</div>
						<div class="ef-field">
							<label><i class="ti ti-user"></i>Full name</label> <input
								type="text" name="farmerName"
								value="<%=farmer.getFarmerName()%>" placeholder="Farmer name">
						</div>
						<div class="ef-field">
							<label><i class="ti ti-phone"></i>Mobile</label> <input
								type="text" name="mobile" value="<%=farmer.getMobile()%>"
								placeholder="10-digit number">
						</div>
						<div class="ef-field">
							<label><i class="ti ti-mail"></i>Email</label> <input
								type="email" name="email"
								value="<%=farmer.getEmail() != null ? farmer.getEmail() : ""%>"
								placeholder="email@example.com">
						</div>
						<div class="ef-field full">
							<label><i class="ti ti-map-pin"></i>Address</label>
							<textarea name="address" rows="2" placeholder="Full address"><%=farmer.getAddress() != null ? farmer.getAddress() : ""%></textarea>
						</div>
					</div>
				</div>

				<!-- Bank -->
				<div class="ef-card">
					<div class="ef-sec-lbl">
						<i class="ti ti-building-bank"></i>Bank details
					</div>
					<div class="ef-fields">
						<div class="ef-field">
							<label><i class="ti ti-user-circle"></i>Account holder
								name</label> <input type="text" name="accountHolderName"
								value="<%=farmer.getAccountHolderName() != null ? farmer.getAccountHolderName() : ""%>"
								placeholder="As per bank records">
						</div>
						<div class="ef-field">
							<label><i class="ti ti-credit-card"></i>Account number</label> <input
								type="text" name="bankAccountNo"
								value="<%=farmer.getAccountNo() != null ? farmer.getAccountNo() : ""%>"
								placeholder="Account number">
						</div>
						<div class="ef-field">
							<label><i class="ti ti-building"></i>Bank name</label> <input
								type="text" name="bankName"
								value="<%=farmer.getBankName() != null ? farmer.getBankName() : ""%>"
								placeholder="Bank name">
						</div>
						<div class="ef-field">
							<label><i class="ti ti-code"></i>IFSC code</label> <input
								type="text" name="ifscCode"
								value="<%=farmer.getIfscCode() != null ? farmer.getIfscCode() : ""%>"
								placeholder="e.g. SBIN0001234">
						</div>
					</div>
				</div>

				<!-- Identity -->
				<div class="ef-card">
					<div class="ef-sec-lbl">
						<i class="ti ti-id-badge"></i>Identity
					</div>
					<div class="ef-fields">
						<div class="ef-field full">
							<label><i class="ti ti-fingerprint"></i>Aadhaar number</label> <input
								type="text" name="andharNo"
								value="<%=farmer.getAndharNo() != null ? farmer.getAndharNo() : ""%>"
								placeholder="12-digit Aadhaar">
						</div>
					</div>
				</div>

				<div class="ef-actions">
					<a href="AdminDashboardServlet?view=farmerList" class="btn-back-ef"><i
						class="ti ti-arrow-left"></i>Back</a>
					<button type="submit" class="btn-save">
						<i class="ti ti-device-floppy"></i>Save changes
					</button>
				</div>
			</form>

			<%
			}
			%>

			<!-- ══════════════════════════════════════════════════
             VIEW: payments (Under Development)
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("payments".equals(currentView)) {
			%>

			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Payments</span>
			</div>

			<!-- Cycle Header Card -->
			<div
				style="background: linear-gradient(135deg, #0f2a6b 0%, #1d4ed8 60%, #2563eb 100%); border-radius: var(--radius); padding: 28px 32px; margin-bottom: 20px; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: space-between;">
				<!-- bg decoration -->
				<div
					style="position: absolute; width: 220px; height: 220px; background: rgba(255, 255, 255, .06); border-radius: 50%; top: -80px; right: 60px; pointer-events: none;"></div>
				<div
					style="position: absolute; width: 140px; height: 140px; background: rgba(255, 255, 255, .04); border-radius: 50%; bottom: -50px; right: 200px; pointer-events: none;"></div>

				<div style="position: relative; z-index: 1;">
					<div
						style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
						<div
							style="width: 36px; height: 36px; background: rgba(255, 255, 255, .15); border: 1px solid rgba(255, 255, 255, .25); border-radius: 9px; display: flex; align-items: center; justify-content: center;">
							<i class="ti ti-calendar-stats"
								style="font-size: 18px; color: #fff;"></i>
						</div>
						<span
							style="font-size: 11px; font-weight: 700; color: #93c5fd; text-transform: uppercase; letter-spacing: .8px;">Current
							Payment Cycle</span>
					</div>
					<div
						style="font-family: 'DM Serif Display', serif; font-size: 26px; color: #fff; margin-bottom: 6px;">
						<%=cycleSummary.getCycleStart()%>
						<span style="color: #93c5fd; font-size: 18px; margin: 0 8px;">→</span>
						<%=cycleSummary.getCycleEnd()%>
					</div>
					<div
						style="display: inline-flex; align-items: center; gap: 6px; background: rgba(255, 255, 255, .12); border: 1px solid rgba(255, 255, 255, .2); border-radius: 20px; padding: 4px 14px;">
						<i class="ti ti-circle-filled"
							style="font-size: 8px; color: #4ade80;"></i> <span
							style="font-size: 11px; color: #bfdbfe; font-weight: 600;">Active
							Cycle</span>
					</div>
				</div>

				<div style="position: relative; z-index: 1;">
					<i class="ti ti-coin-rupee"
						style="font-size: 80px; color: #fff; opacity: .08;"></i>
				</div>
			</div>

			<!-- Cycle Summary Stats -->
			<div class="grid-3" style="margin-bottom: 20px;">
				<div class="sc blue">
					<div class="si blue">
						<i class="ti ti-users"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=cycleSummary.getTotalFarmers()%></div>
						<div class="lbl">Farmers in Cycle</div>
						<div class="sub">Supplied this cycle</div>
					</div>
				</div>
				<div class="sc teal">
					<div class="si teal">
						<i class="ti ti-droplet"></i>
					</div>
					<div class="sc-body">
						<div class="val"><%=String.format("%.2f", cycleSummary.getTotalMilk())%>
							L
						</div>
						<div class="lbl">Total Milk Collected</div>
						<div class="sub">This cycle</div>
					</div>
				</div>
				<div class="sc green">
					<div class="si green">
						<i class="ti ti-coin-rupee"></i>
					</div>
					<div class="sc-body">
						<div class="val">
							₹<%=String.format("%.0f", cycleSummary.getTotalAmount())%></div>
						<div class="lbl">Total Amount</div>
						<div class="sub">Payable this cycle</div>
					</div>
				</div>
			</div>

			<!-- Under Development Notice -->
			<div
				style="background: var(--white); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; margin-bottom: 20px;">
				<div
					style="background: #fffbeb; border-bottom: 1px solid #fde68a; padding: 14px 20px; display: flex; align-items: center; gap: 10px;">
					<i class="ti ti-tools" style="font-size: 18px; color: #d97706;"></i>
					<div>
						<div style="font-size: 13px; font-weight: 700; color: #92400e;">Module
							Under Development</div>
						<div style="font-size: 11px; color: #b45309; margin-top: 1px;">
							Full payment processing will be available in the next release</div>
					</div>
					<span
						style="margin-left: auto; background: #fef3c7; color: #92400e; border: 1px solid #fde68a; border-radius: 20px; font-size: 10px; font-weight: 700; padding: 3px 12px;">COMING
						SOON</span>
				</div>
				<div style="padding: 20px 24px;">
					<div
						style="font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .6px; margin-bottom: 12px;">
						Planned Features</div>
					<div class="feat-chips">
						<span class="feat-chip"><i class="ti ti-calendar-repeat"></i>10-day
							payment cycles</span> <span class="feat-chip"><i
							class="ti ti-receipt"></i>Payment vouchers</span> <span
							class="feat-chip"><i class="ti ti-building-bank"></i>Bank
							transfer records</span> <span class="feat-chip"><i
							class="ti ti-file-invoice"></i>Payment history</span> <span
							class="feat-chip"><i class="ti ti-coin-rupee"></i>Advance
							deductions</span> <span class="feat-chip"><i
							class="ti ti-printer"></i>Printable statements</span> <span
							class="feat-chip"><i class="ti ti-users"></i>Farmer-wise
							breakdown</span> <span class="feat-chip"><i
							class="ti ti-file-export"></i>Export to PDF/Excel</span>
					</div>
				</div>
			</div>

			<a href="AdminDashboardServlet?view=dashboard" class="wip-back">
				<i class="ti ti-arrow-left"></i>Back to Dashboard
			</a>

			<%
			} else if ("feedStore".equals(currentView)) {
			%>

			<!-- ══════════════════════════════════════════════════
             VIEW: feedStore (Under Development)
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("feedStore".equals(currentView)) {
			%>

			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Feed Store</span>
			</div>

			<div class="wip-card">
				<div class="wip-hero">
					<div class="wip-icon-wrap">
						<i class="ti ti-wheat"></i>
					</div>
					<h2>Feed Store Module</h2>
					<p>Manage cattle feed orders, stock, and installment payments</p>
				</div>
				<div class="wip-body">
					<div class="wip-status-row">
						<span class="wip-badge building"><i class="ti ti-tools"></i>Under
							Development</span> <span class="wip-badge planned"><i
							class="ti ti-clock"></i>Coming Soon</span>
					</div>
					<div class="wip-features">
						<h4>Planned Features</h4>
						<div class="feat-chips">
							<span class="feat-chip"><i class="ti ti-package"></i>Feed
								inventory</span> <span class="feat-chip"><i
								class="ti ti-shopping-cart"></i>Order management</span> <span
								class="feat-chip"><i class="ti ti-credit-card"></i>Installment
								tracking</span> <span class="feat-chip"><i
								class="ti ti-alert-triangle"></i>Low stock alerts</span> <span
								class="feat-chip"><i class="ti ti-truck"></i>Delivery
								tracking</span> <span class="feat-chip"><i
								class="ti ti-chart-bar"></i>Consumption reports</span>
						</div>
					</div>
					<a href="AdminDashboardServlet?view=dashboard" class="wip-back"><i
						class="ti ti-arrow-left"></i>Back to Dashboard</a>
				</div>
			</div>

			<!-- ══════════════════════════════════════════════════
             VIEW: reports (Under Development)
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("reports".equals(currentView)) {
			%>

			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Reports</span>
			</div>

			<div class="wip-card">
				<div class="wip-hero">
					<div class="wip-icon-wrap">
						<i class="ti ti-chart-bar"></i>
					</div>
					<h2>Reports &amp; Analytics</h2>
					<p>Comprehensive analytics, trends, and exportable reports</p>
				</div>
				<div class="wip-body">
					<div class="wip-status-row">
						<span class="wip-badge building"><i class="ti ti-tools"></i>Under
							Development</span> <span class="wip-badge planned"><i
							class="ti ti-clock"></i>Coming Soon</span>
					</div>
					<div class="wip-features">
						<h4>Planned Features</h4>
						<div class="feat-chips">
							<span class="feat-chip"><i class="ti ti-calendar-stats"></i>Monthly
								summaries</span> <span class="feat-chip"><i class="ti ti-users"></i>Farmer-wise
								reports</span> <span class="feat-chip"><i
								class="ti ti-chart-line"></i>Trend analysis</span> <span
								class="feat-chip"><i class="ti ti-file-export"></i>Excel
								&amp; PDF export</span> <span class="feat-chip"><i
								class="ti ti-droplet"></i>Milk quality reports</span> <span
								class="feat-chip"><i class="ti ti-coin-rupee"></i>Financial
								summaries</span>
						</div>
					</div>
					<a href="AdminDashboardServlet?view=dashboard" class="wip-back"><i
						class="ti ti-arrow-left"></i>Back to Dashboard</a>
				</div>
			</div>

			<!-- ══════════════════════════════════════════════════
             VIEW: priceConfig (Under Development)
        ══════════════════════════════════════════════════ -->
			<%
			} else if ("priceConfig".equals(currentView)) {
			%>

			<div class="bc">
				<a href="AdminDashboardServlet?view=dashboard">Dashboard</a> <i
					class="ti ti-chevron-right"></i> <span>Price Config</span>
			</div>

			<div class="wip-card">
				<div class="wip-hero">
					<div class="wip-icon-wrap">
						<i class="ti ti-currency-rupee"></i>
					</div>
					<h2>Price Configuration</h2>
					<p>Configure milk rate formulas, FAT/SNF slabs and pricing
						rules</p>
				</div>
				<div class="wip-body">
					<div class="wip-status-row">
						<span class="wip-badge building"><i class="ti ti-tools"></i>Under
							Development</span> <span class="wip-badge planned"><i
							class="ti ti-clock"></i>Coming Soon</span>
					</div>
					<div class="wip-features">
						<h4>Planned Features</h4>
						<div class="feat-chips">
							<span class="feat-chip"><i class="ti ti-math"></i>FAT/SNF
								rate formula</span> <span class="feat-chip"><i
								class="ti ti-table"></i>Price slab configuration</span> <span
								class="feat-chip"><i class="ti ti-toggle-right"></i>Cow
								vs Buffalo rates</span> <span class="feat-chip"><i
								class="ti ti-history"></i>Rate change history</span> <span
								class="feat-chip"><i class="ti ti-calculator"></i>Rate
								preview calculator</span> <span class="feat-chip"><i
								class="ti ti-calendar"></i>Effective date setting</span>
						</div>
					</div>
					<a href="AdminDashboardServlet?view=dashboard" class="wip-back"><i
						class="ti ti-arrow-left"></i>Back to Dashboard</a>
				</div>
			</div>

			<%
			} /* end view switch */
			%>

		</div>
		<!-- /content -->

		<div class="foot">
			<span>© 2026 MilkMitra. All Rights Reserved.</span> <span>Logged
				in as <strong><%=username%></strong> · <%=role%></span>
		</div>
	</div>
	<!-- /main -->

	<!-- ═══════════════════════════════════════════════════════
     MODALS — Deactivate & Reactivate
═══════════════════════════════════════════════════════════ -->
	<div class="modal-overlay" id="deactivateModal">
		<div class="modal">
			<div class="modal-icon red">
				<i class="ti ti-user-off"></i>
			</div>
			<h3>Deactivate Farmer?</h3>
			<p>
				You are about to deactivate<br> <strong id="deactivateName">—</strong>
				(<span id="deactivateCode">—</span>).<br>They will no longer be
				able to supply milk.
			</p>
			<div class="modal-btns">
				<button class="btn-cancel" onclick="closeModal('deactivateModal')">Cancel</button>
				<a id="deactivateConfirmBtn" href="#" class="btn-confirm-red">Yes,
					Deactivate</a>
			</div>
		</div>
	</div>

	<div class="modal-overlay" id="reactivateModal">
		<div class="modal">
			<div class="modal-icon green">
				<i class="ti ti-user-check"></i>
			</div>
			<h3>Reactivate Farmer?</h3>
			<p>
				You are about to reactivate<br> <strong id="reactivateName">—</strong>
				(<span id="reactivateCode">—</span>).<br>They will be able to
				supply milk again.
			</p>
			<div class="modal-btns">
				<button class="btn-cancel" onclick="closeModal('reactivateModal')">Cancel</button>
				<a id="reactivateConfirmBtn" href="#" class="btn-confirm-green">Yes,
					Reactivate</a>
			</div>
		</div>
	</div>

	<script>
/* ── Date & greeting ── */
var d = new Date();
document.getElementById('dateStr').textContent =
    d.toLocaleDateString('en-IN',{weekday:'short',year:'numeric',month:'short',day:'numeric'});
var greetEl = document.getElementById('greeting');
if(greetEl){
    var h=d.getHours();
    var g=h<12?'Good morning':h<17?'Good afternoon':'Good evening';
    greetEl.textContent = g + ', <%=username%>
		\uD83D\uDC4B';
		}

		/* ── IFSC uppercase (Add Farmer view) ── */
		var ifscInput = document.getElementById('ifscInput');
		if (ifscInput) {
			ifscInput.addEventListener('input', function() {
				this.value = this.value.toUpperCase();
			});
		}

		/* ── Farmer list search/filter ── */
		function doFilter() {
			var search = document.getElementById('srch').value.toLowerCase()
					.trim();
			var filter = document.getElementById('filt').value;
			var rows = document.querySelectorAll('#tb tr[data-code]');
			var today = new Date();
			var visible = 0;
			rows.forEach(function(row, idx) {
				var code = row.dataset.code || '';
				var name = row.dataset.name || '';
				var mob = row.dataset.mob || '';
				var status = row.dataset.status || '';
				var date = row.dataset.date || '';
				var show = true;
				if (search && !code.includes(search) && !name.includes(search)
						&& !mob.includes(search))
					show = false;
				if (filter === 'active' && status !== 'active')
					show = false;
				if (filter === 'inactive' && status !== 'inactive')
					show = false;
				if (filter === 'thismonth' && date) {
					var joined = new Date(date);
					if (joined.getMonth() !== today.getMonth()
							|| joined.getFullYear() !== today.getFullYear())
						show = false;
				}
				row.style.display = show ? '' : 'none';
				if (show) {
					visible++;
					row.querySelector('td:first-child').textContent = visible;
				}
			});
			var sc2 = document.getElementById('sc2');
			var pi = document.getElementById('pi');
			if (sc2)
				sc2.textContent = visible;
			if (pi)
				pi.textContent = 'Showing 1 to ' + visible + ' of ' + visible
						+ ' farmers';
		}

		/* ── Confirm modal ── */
		function showModal(type, code, name) {
			if (type === 'deactivate') {
				document.getElementById('deactivateName').textContent = name;
				document.getElementById('deactivateCode').textContent = code;
				document.getElementById('deactivateConfirmBtn').href = 'DeactivateFarmerServlet?farmerCode='
						+ code + '&returnTo=AdminDashboard';
				document.getElementById('deactivateModal').classList
						.add('show');
			} else {
				document.getElementById('reactivateName').textContent = name;
				document.getElementById('reactivateCode').textContent = code;
				document.getElementById('reactivateConfirmBtn').href = 'ReactivateFarmerServlet?farmerCode='
						+ code + '&returnTo=AdminDashboard';
				document.getElementById('reactivateModal').classList
						.add('show');
			}
		}
		function closeModal(id) {
			document.getElementById(id).classList.remove('show');
		}
		document.querySelectorAll('.modal-overlay').forEach(function(o) {
			o.addEventListener('click', function(e) {
				if (e.target === o)
					o.classList.remove('show');
			});
		});
		document.addEventListener('keydown', function(e) {
			if (e.key === 'Escape')
				document.querySelectorAll('.modal-overlay').forEach(
						function(m) {
							m.classList.remove('show');
						});
		});
	</script>
</body>
</html>
