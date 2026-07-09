<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="com.milkmitra.model.Farmer,
	        com.milkmitra.model.User,
	        com.milkmitra.model.FarmerDashboard,
	        com.milkmitra.model.PaymentSummary,
	        java.util.*"
	import="com.milkmitra.model.Farmer,
            com.milkmitra.model.User,
            com.milkmitra.model.FarmerDashboard,
            com.milkmitra.model.PaymentSummary,
            java.time.LocalDate,
            java.util.*"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
if (username == null || !"FARMER".equals(role)) {
	response.sendRedirect("Login.jsp");
	return;
}

Farmer farmer = (Farmer) request.getAttribute("farmerProfile");
String farmerName = (farmer != null) ? farmer.getFarmerName() : "";
String farmerCode = (farmer != null) ? farmer.getFarmerCode() : "";
String mppCode = (farmer != null) ? farmer.getMppCode() : "";
String mobile = (farmer != null) ? farmer.getMobile() : "";
String address = (farmer != null) ? farmer.getAddress() : "";
String bankName = (farmer != null) ? farmer.getBankName() : "";
String accountNo = (farmer != null) ? farmer.getAccountNo() : "";
String ifscCode = (farmer != null) ? farmer.getIfscCode() : "";
String joinedDate = (farmer != null && farmer.getJoiningDate() != null) ? farmer.getJoiningDate().toString() : "";
String mppStatus = (farmer != null) ? (farmer.isActive() ? "Active" : "Inactive") : "Active";
String avatarChar = (farmerName != null && !farmerName.isEmpty()) ? farmerName.substring(0, 1).toUpperCase() : "F";

FarmerDashboard dashboard = (FarmerDashboard) request.getAttribute("dashboard");
int activeDays = dashboard != null ? dashboard.getTotalActiveDaysThisYear() : 0;
double totalMilkYear = dashboard != null ? dashboard.getTotalMilkThisYear() : 0;
double totalEarnYear = dashboard != null ? dashboard.getTotalEarningThisYear() : 0;

int daysPercent = Math.min((int) ((activeDays / 365.0) * 100), 100);
int milkPercent = Math.min((int) ((totalMilkYear / 1000.0) * 100), 100);

PaymentSummary cycleSummary = (PaymentSummary) request.getAttribute("cycleSummary");

double todayMilk = dashboard != null ? dashboard.getTodayMilk() : 0;
double todayEarning = dashboard != null ? dashboard.getTodayEarning() : 0;

double morningCowQty = dashboard != null ? dashboard.getMorningCowQty() : 0;
double morningCowFat = dashboard != null ? dashboard.getMorningCowFat() : 0;
double morningCowSnf = dashboard != null ? dashboard.getMorningCowSnf() : 0;
double morningCowAmt = dashboard != null ? dashboard.getMorningCowAmount() : 0;

double morningBufQty = dashboard != null ? dashboard.getMorningBufQty() : 0;
double morningBufFat = dashboard != null ? dashboard.getMorningBufFat() : 0;
double morningBufSnf = dashboard != null ? dashboard.getMorningBufSnf() : 0;
double morningBufAmt = dashboard != null ? dashboard.getMorningBufAmount() : 0;

double eveningCowQty = dashboard != null ? dashboard.getEveningCowQty() : 0;
double eveningCowFat = dashboard != null ? dashboard.getEveningCowFat() : 0;
double eveningCowSnf = dashboard != null ? dashboard.getEveningCowSnf() : 0;
double eveningCowAmt = dashboard != null ? dashboard.getEveningCowAmount() : 0;

double eveningBufQty = dashboard != null ? dashboard.getEveningBufQty() : 0;
double eveningBufFat = dashboard != null ? dashboard.getEveningBufFat() : 0;
double eveningBufSnf = dashboard != null ? dashboard.getEveningBufSnf() : 0;
double eveningBufAmt = dashboard != null ? dashboard.getEveningBufAmount() : 0;

double morningTotal = morningCowAmt + morningBufAmt;
double eveningTotal = eveningCowAmt + eveningBufAmt;
double todayTotal = morningTotal + eveningTotal;

// Payment history
String currentView = (String) request.getAttribute("currentView");
boolean isCycleDetailScreen = "cycleDetail".equals(currentView);

List<PaymentSummary> paymentList = (List<PaymentSummary>) request.getAttribute("paymentList");
double histTotalMilk = 0, histTotalAmt = 0;
if (paymentList != null) {
	for (PaymentSummary ps : paymentList) {
		histTotalMilk += ps.getTotalMilk();
		histTotalAmt += ps.getTotalAmount();
	}
}

//Cycle detail view
List<PaymentSummary> cycleEntries = (List<PaymentSummary>) request.getAttribute("cycleEntries");
String cycleStartAttr = request.getAttribute("cycleStart") != null ? request.getAttribute("cycleStart").toString() : "";
String cycleEndAttr = request.getAttribute("cycleEnd") != null ? request.getAttribute("cycleEnd").toString() : "";

//Override isPaymentView so topbar title and nav still work
boolean isPaymentView = "paymentHistory".equals(currentView) || isCycleDetailScreen;

java.time.ZoneId indiaZone = java.time.ZoneId.of("Asia/Kolkata");

java.time.LocalDate today2 = java.time.LocalDate.now(indiaZone);

String[] days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
String[] months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
		"November", "December"};

java.time.DayOfWeek dow = today2.getDayOfWeek();
String dayName = days[dow.getValue() % 7];

String dateStr = dayName + ", " + today2.getDayOfMonth() + " " + months[today2.getMonthValue() - 1];

int hour = java.time.LocalTime.now(indiaZone).getHour();

String greeting = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<title>MilkMitra | Farmer Portal</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Nunito+Sans:wght@300;400;500;600&display=swap"
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
	--bg: #0e1a1f;
	--surface: #152028;
	--surface2: #0f1c22;
	--surface3: #1c2e38;
	--teal: #48c7a2;
	--teal-d: #2a8f72;
	--teal-glow: rgba(72, 199, 162, 0.12);
	--teal-line: rgba(72, 199, 162, 0.14);
	--text: #e0f2ec;
	--text2: #6b9e8a;
	--text3: #2e5248;
	--border: rgba(72, 199, 162, 0.13);
	--radius: 16px;
	--radius-sm: 10px;
	--font: 'Nunito Sans', sans-serif;
	--font-h: 'Nunito', sans-serif;
}

body {
	font-family: var(--font);
	background: var(--bg);
	color: var(--text);
	font-size: 14px;
	-webkit-font-smoothing: antialiased;
}

.app {
	max-width: 420px;
	margin: 0 auto;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

/* TOP BAR */
.topbar {
	background: var(--surface2);
	border-bottom: 0.5px solid var(--border);
	padding: 13px 16px;
	display: flex;
	align-items: center;
	gap: 10px;
	position: sticky;
	top: 0;
	z-index: 100;
}

.tb-menu {
	background: var(--teal-glow);
	border: 0.5px solid var(--teal-line);
	color: var(--teal);
	width: 34px;
	height: 34px;
	border-radius: var(--radius-sm);
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 18px;
	flex-shrink: 0;
}

.tb-title {
	font-family: var(--font-h);
	font-size: 16px;
	font-weight: 700;
	color: var(--text);
	flex: 1;
}

.tb-bell {
	background: none;
	border: none;
	color: var(--text2);
	font-size: 20px;
	cursor: pointer;
}

/* DRAWER */
.drawer-overlay {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.55);
	z-index: 200;
	opacity: 0;
	pointer-events: none;
	transition: opacity .25s;
}

.drawer-overlay.open {
	opacity: 1;
	pointer-events: all;
}

.drawer {
	position: fixed;
	top: 0;
	left: -280px;
	width: 280px;
	height: 100%;
	background: #0b1a22;
	border-right: 0.5px solid var(--border);
	z-index: 201;
	transition: left .28s cubic-bezier(.4, 0, .2, 1);
	display: flex;
	flex-direction: column;
	overflow-y: auto;
}

.drawer.open {
	left: 0;
}

.dr-brand {
	padding: 28px 20px 18px;
	border-bottom: 0.5px solid var(--border);
}

.dr-brand h1 {
	font-family: var(--font-h);
	font-size: 22px;
	font-weight: 800;
	color: var(--text);
}

.dr-brand h1 span {
	color: var(--teal);
}

.dr-brand p {
	font-size: 11px;
	color: var(--text2);
	margin-top: 2px;
	letter-spacing: .4px;
}

.dr-user {
	padding: 14px 20px;
	border-bottom: 0.5px solid var(--border);
	display: flex;
	align-items: center;
	gap: 10px;
}

.dr-av {
	width: 38px;
	height: 38px;
	background: var(--teal-glow);
	border: 1.5px solid var(--teal-line);
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-family: var(--font-h);
	font-size: 15px;
	font-weight: 700;
	color: var(--teal);
	flex-shrink: 0;
}

.dr-un {
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
}

.dr-id {
	font-size: 11px;
	color: var(--text2);
	margin-top: 1px;
}

.dr-nav {
	flex: 1;
	padding: 10px 12px;
}

.dn-lbl {
	font-size: 9px;
	color: var(--text3);
	text-transform: uppercase;
	letter-spacing: 1px;
	padding: 10px 8px 4px;
	font-weight: 700;
}

.dr-item {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 10px;
	border-radius: var(--radius-sm);
	color: var(--text2);
	font-size: 13px;
	font-weight: 500;
	cursor: pointer;
	transition: background .15s, color .15s;
	margin-bottom: 2px;
}

.dr-item:hover {
	background: var(--teal-glow);
	color: var(--text);
}

.dr-item.active {
	background: var(--teal-glow);
	color: var(--teal);
	border: 0.5px solid var(--teal-line);
}

.dr-item i {
	font-size: 18px;
	flex-shrink: 0;
}

.dr-item .coming-tag {
	margin-left: auto;
	font-size: 9px;
	background: rgba(72, 199, 162, 0.1);
	color: var(--teal-d);
	border-radius: 10px;
	padding: 2px 7px;
	font-weight: 700;
	letter-spacing: .3px;
}

.dr-foot {
	padding: 14px 20px;
	border-top: 0.5px solid var(--border);
}

.dr-logout {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 9px 12px;
	background: rgba(220, 38, 38, .1);
	border: 0.5px solid rgba(220, 38, 38, .25);
	border-radius: var(--radius-sm);
	color: #f87171;
	font-size: 13px;
	cursor: pointer;
	text-decoration: none;
}

.dr-logout i {
	font-size: 17px;
}

/* CONTENT */
.content {
	flex: 1;
	overflow-y: auto;
	padding-bottom: 72px;
}

.screen {
	display: none;
}

.screen.active {
	display: block;
}

/* BOTTOM NAV */
.bottom-nav {
	position: fixed;
	bottom: 0;
	left: 50%;
	transform: translateX(-50%);
	width: 100%;
	max-width: 420px;
	background: var(--surface2);
	border-top: 0.5px solid var(--border);
	display: flex;
	z-index: 100;
}

.nav-btn {
	flex: 1;
	padding: 10px 4px 8px;
	border: none;
	background: none;
	cursor: pointer;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 3px;
	color: var(--text3);
	font-family: var(--font);
	font-size: 10px;
	font-weight: 600;
	transition: color .15s;
}

.nav-btn.active {
	color: var(--teal);
}

.nav-btn i {
	font-size: 22px;
}

/* DASHBOARD */
.dash-header {
	padding: 20px 18px 0;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.dash-date {
	font-size: 12px;
	color: var(--text2);
	letter-spacing: .04em;
}

.dash-greeting {
	font-size: 18px;
	font-weight: 500;
	color: var(--text);
	margin-top: 3px;
}

.dash-av {
	width: 42px;
	height: 42px;
	border-radius: 50%;
	background: var(--teal-glow);
	border: 1px solid var(--teal-line);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 15px;
	font-weight: 600;
	color: var(--teal);
	flex-shrink: 0;
}

.progress-card {
	margin: 18px 16px 0;
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 18px;
	display: flex;
	align-items: center;
	gap: 18px;
}

.ring-wrap {
	position: relative;
	width: 130px;
	height: 130px;
	flex-shrink: 0;
}

.ring-label {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	text-align: center;
}

.ring-num {
	font-size: 24px;
	font-weight: 600;
	color: var(--text);
	line-height: 1;
}

.ring-sub {
	font-size: 10px;
	color: var(--text2);
	margin-top: 3px;
}

.prog-label {
	font-size: 11px;
	margin-bottom: 4px;
	display: flex;
	justify-content: space-between;
}

.prog-track {
	height: 5px;
	background: rgba(72, 199, 162, 0.1);
	border-radius: 3px;
	margin-bottom: 12px;
}

.prog-fill {
	height: 5px;
	border-radius: 3px;
}

.stat-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 10px;
	padding: 14px 16px 0;
}

.stat-tile {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 14px;
}

.stat-tile i {
	font-size: 22px;
}

.stat-num {
	font-size: 24px;
	font-weight: 600;
	color: var(--text);
	margin: 8px 0 2px;
}

.stat-lbl {
	font-size: 11px;
	color: var(--text2);
}

.stat-pill {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	margin-top: 10px;
	padding: 3px 10px;
	border-radius: 100px;
	font-size: 11px;
	font-weight: 500;
}

.coll-card {
	margin: 14px 16px 0;
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 18px;
}

.coll-head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 18px;
}

.coll-title {
	font-size: 14px;
	font-weight: 600;
	color: var(--text);
}

.logged-pill {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: 3px 10px;
	border-radius: 100px;
	font-size: 11px;
	font-weight: 500;
	background: rgba(72, 199, 162, 0.12);
	color: var(--teal);
}

.shift-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 16px;
}

.shift-lbl {
	font-size: 10px;
	color: var(--text2);
	text-transform: uppercase;
	letter-spacing: .07em;
	margin-bottom: 12px;
}

.shift-row {
	display: flex;
	justify-content: space-between;
	align-items: baseline;
	margin-bottom: 8px;
}

.shift-key {
	font-size: 12px;
	color: var(--text2);
}

.shift-val {
	font-size: 18px;
	font-weight: 500;
	color: var(--text);
}

.shift-unit {
	font-size: 11px;
	color: var(--text2);
	margin-left: 1px;
}

.coll-divider {
	border: none;
	border-top: 0.5px solid var(--border);
	margin: 16px 0;
}

.summary-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 8px;
}

.summary-tile {
	background: rgba(72, 199, 162, 0.06);
	border-radius: 10px;
	padding: 12px;
}

.sum-lbl {
	font-size: 11px;
	color: var(--text2);
	margin-bottom: 4px;
}

.sum-val {
	font-size: 20px;
	font-weight: 500;
	color: var(--text);
}

.sum-unit {
	font-size: 11px;
	color: var(--text2);
	margin-left: 2px;
}

/* COMING SOON */
.coming-screen {
	padding: 20px 16px;
}

.coming-hero {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 30px 20px;
	text-align: center;
	margin-bottom: 14px;
}

.coming-hero i {
	font-size: 48px;
	color: var(--teal);
}

.coming-hero h2 {
	font-family: var(--font-h);
	font-size: 17px;
	font-weight: 700;
	color: var(--text);
	margin: 12px 0 6px;
}

.coming-hero p {
	font-size: 13px;
	color: var(--text2);
	line-height: 1.6;
}

.cf-item {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 14px 16px;
	display: flex;
	align-items: center;
	gap: 14px;
	margin-bottom: 10px;
}

.cf-icon {
	width: 42px;
	height: 42px;
	border-radius: var(--radius-sm);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 20px;
	flex-shrink: 0;
}

.cf-icon.teal {
	background: rgba(72, 199, 162, 0.12);
	color: var(--teal);
}

.cf-icon.teal-d {
	background: rgba(42, 143, 114, 0.12);
	color: var(--teal-d);
}

.cf-text h4 {
	font-family: var(--font-h);
	font-size: 13px;
	font-weight: 700;
	color: var(--text);
	margin-bottom: 2px;
}

.cf-text p {
	font-size: 11px;
	color: var(--text2);
	line-height: 1.5;
}

.cf-badge {
	margin-left: auto;
	flex-shrink: 0;
	font-size: 10px;
	font-weight: 700;
	background: rgba(72, 199, 162, 0.1);
	color: var(--teal-d);
	border: 0.5px solid var(--teal-line);
	border-radius: 20px;
	padding: 3px 9px;
	white-space: nowrap;
}

/* PAYMENT HISTORY */
.pay-screen {
	padding: 16px 16px 80px;
}

.pay-year-badge {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius-sm);
	padding: 10px 14px;
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 12px;
}

.pay-year-badge i {
	font-size: 20px;
	color: var(--teal);
}

.pay-year-lbl {
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
}

.pay-year-hint {
	font-size: 11px;
	color: var(--text2);
	margin-top: 2px;
}

.pay-summary-bar {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 14px 16px;
	margin-bottom: 14px;
}

.pay-sbar-title {
	font-size: 10px;
	color: var(--text2);
	text-transform: uppercase;
	letter-spacing: .5px;
	font-weight: 700;
	margin-bottom: 10px;
}

.pay-sbar-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 10px;
}

.pay-sbar-item {
	background: rgba(72, 199, 162, 0.06);
	border-radius: var(--radius-sm);
	padding: 10px 12px;
}

.pay-sbar-lbl {
	font-size: 10px;
	color: var(--text2);
	margin-bottom: 3px;
}

.pay-sbar-val {
	font-size: 18px;
	font-weight: 600;
	color: var(--text);
}

.pay-sbar-unit {
	font-size: 10px;
	color: var(--text2);
	margin-left: 2px;
}

.pay-list-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
	padding: 0 2px;
}

.pay-list-title {
	font-size: 12px;
	font-weight: 700;
	color: var(--text2);
	text-transform: uppercase;
	letter-spacing: .5px;
}

.pay-list-count {
	font-size: 11px;
	color: var(--text3);
}

.pay-card {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
	margin-bottom: 10px;
	cursor: pointer;
	transition: background .15s;
}

.pay-card:hover {
	background: var(--surface3);
}

.pay-card-row {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 14px 16px;
}

.pay-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	flex-shrink: 0;
}

.pay-info {
	flex: 1;
}

.pay-range {
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
	margin-bottom: 2px;
}

.pay-meta {
	font-size: 11px;
	color: var(--text2);
}

.pay-amt {
	font-size: 16px;
	font-weight: 600;
	color: var(--teal);
	margin-right: 4px;
}

.pay-chev {
	font-size: 18px;
	color: var(--text3);
	transition: transform .2s;
}

.pay-detail {
	display: none;
	background: var(--surface2);
	border-top: 0.5px solid var(--border);
	padding: 12px 16px;
}

.pay-detail-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 6px 0;
	border-bottom: 0.5px solid rgba(72, 199, 162, 0.07);
}

.pay-detail-row:last-child {
	border-bottom: none;
}

.pay-detail-key {
	font-size: 12px;
	color: var(--text2);
	display: flex;
	align-items: center;
	gap: 6px;
}

.pay-detail-key i {
	font-size: 15px;
	color: var(--teal-d);
}

.pay-detail-val {
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
}

.pay-empty {
	text-align: center;
	padding: 40px 20px;
	color: var(--text3);
}

.pay-empty i {
	font-size: 40px;
	display: block;
	margin-bottom: 10px;
}

.pay-empty p {
	font-size: 13px;
}

/* PROFILE */
.profile-header {
	background: var(--surface);
	border-bottom: 0.5px solid var(--border);
	padding: 28px 18px 22px;
	text-align: center;
}

.ph-av {
	width: 70px;
	height: 70px;
	border-radius: 50%;
	background: var(--teal-glow);
	border: 2px solid var(--teal-line);
	margin: 0 auto 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-family: var(--font-h);
	font-size: 26px;
	font-weight: 800;
	color: var(--teal);
}

.ph-name {
	font-family: var(--font-h);
	font-size: 17px;
	font-weight: 700;
	color: var(--text);
	margin-bottom: 4px;
}

.ph-id {
	font-size: 12px;
	color: var(--text2);
	font-family: 'Courier New', monospace;
	letter-spacing: .5px;
}

.profile-body {
	padding: 14px;
}

.prof-section {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
	margin-bottom: 12px;
}

.prof-sec-title {
	padding: 10px 14px;
	border-bottom: 0.5px solid var(--border);
	font-size: 11px;
	font-weight: 700;
	color: var(--text2);
	text-transform: uppercase;
	letter-spacing: .5px;
	background: var(--surface2);
}

.prof-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px 14px;
	border-bottom: 0.5px solid var(--border);
}

.prof-row:last-child {
	border-bottom: none;
}

.prof-key {
	font-size: 13px;
	color: var(--text2);
	display: flex;
	align-items: center;
	gap: 7px;
}

.prof-key i {
	font-size: 16px;
	color: var(--teal-d);
}

.prof-val {
	font-size: 13px;
	font-weight: 600;
	color: var(--text);
	text-align: right;
	max-width: 55%;
}

@
keyframes fadeUp {from { opacity:0;
	transform: translateY(8px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.screen.active>* {
	animation: fadeUp .22s ease both;
}
/* View button */
.pay-view-btn-row {
	margin-top: 10px;
	display: flex;
	justify-content: flex-end;
}

.pay-view-btn {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background: var(--teal);
	color: #111;
	padding: 7px 16px;
	border-radius: 20px;
	font-size: 0.82rem;
	font-weight: 700;
	text-decoration: none;
	transition: background .2s;
}

.pay-view-btn:hover {
	background: var(--teal-d);
	color: #fff;
}

/* Cycle detail header */
.cycle-detail-header {
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 16px;
}

.cycle-back-btn {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	color: var(--teal);
	font-weight: 700;
	text-decoration: none;
	font-size: 0.88rem;
	background: var(--teal-glow);
	border: 0.5px solid var(--teal-line);
	padding: 6px 12px;
	border-radius: 20px;
}

.cycle-detail-title {
	font-weight: 700;
	font-size: 1rem;
	color: var(--text);
}

.cycle-detail-subtitle {
	font-size: 0.75rem;
	color: var(--text2);
	margin-top: 2px;
}

/* Entry smart cards */
.entry-card {
	background: var(--surface);
	border: 0.5px solid var(--border);
	border-radius: var(--radius);
	padding: 14px 16px;
	margin-bottom: 12px;
}

.entry-card-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 14px 10px;
}

.entry-field {
	display: flex;
	flex-direction: column;
	gap: 3px;
}

.entry-lbl {
	font-size: 0.68rem;
	color: var(--teal);
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.4px;
}

.entry-val {
	font-size: 0.9rem;
	color: var(--text);
	font-weight: 600;
}

.entry-amount {
	color: var(--teal);
	font-size: 1rem;
	font-weight: 700;
}

.cycle-total-bar {
	background: rgba(72, 199, 162, 0.08);
	border: 0.5px solid var(--border);
	border-radius: var(--radius-sm);
	padding: 12px 16px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 14px;
}

.cycle-total-lbl {
	font-size: 12px;
	color: var(--text2);
	font-weight: 600;
}

.cycle-total-val {
	font-size: 18px;
	font-weight: 700;
	color: var(--teal);
}
</style>
</head>
<body>
	<div class="app">

		<!-- DRAWER OVERLAY -->
		<div class="drawer-overlay" id="overlay" onclick="closeDrawer()"></div>

		<!-- SIDE DRAWER -->
		<div class="drawer" id="drawer">
			<div class="dr-brand">
				<h1>
					Milk<span>Mitra</span>
				</h1>
				<p>Farmer Portal</p>
			</div>
			<div class="dr-user">
				<div class="dr-av"><%=avatarChar%></div>
				<div>
					<div class="dr-un"><%=farmerName%></div>
					<div class="dr-id"><%=farmerCode%></div>
				</div>
			</div>
			<nav class="dr-nav">
				<div class="dn-lbl">Main Menu</div>
				<div class="dr-item <%=isPaymentView ? "" : "active"%>"
					onclick="window.location.href='FarmerDashboardServlet'">
					<i class="ti ti-home"></i>Dashboard
				</div>
				<div class="dr-item <%=isPaymentView ? "active" : ""%>"
					onclick="window.location.href='FarmerPaymentHistoryServlet';closeDrawer()">
					<i class="ti ti-cash"></i>Latest Payment
				</div>
				<div class="dr-item"
					onclick="navTo('coming',this,'Features Coming Soon');closeDrawer()">
					<i class="ti ti-notebook"></i>Feeds <span class="coming-tag">SOON</span>
				</div>
				<div class="dr-item"
					onclick="navTo('coming',this,'Features Coming Soon');closeDrawer()">
					<i class="ti ti-chart-bar"></i>Report <span class="coming-tag">SOON</span>
				</div>
				<div class="dr-item"
					onclick="navTo('coming',this,'Features Coming Soon');closeDrawer()">
					<i class="ti ti-currency-rupee"></i>Milk Price Checker <span
						class="coming-tag">SOON</span>
				</div>
				<div class="dn-lbl">Account</div>
				<div class="dr-item"
					onclick="navTo('profile',this,'My Profile');closeDrawer()">
					<i class="ti ti-user-circle"></i>My Profile
				</div>
			</nav>
			<div class="dr-foot">
				<a href="LogoutServlet" class="dr-logout"> <i
					class="ti ti-logout"></i>Sign Out
				</a>
			</div>
		</div>

		<!-- TOP BAR -->
		<div class="topbar">
			<button class="tb-menu" onclick="openDrawer()" aria-label="Open menu">
				<i class="ti ti-menu-2" aria-hidden="true"></i>
			</button>
			<h1 class="tb-title" id="page-title"><%=isCycleDetailScreen ? "Payment Details" : isPaymentView ? "Latest Payment" : "Dashboard"%></h1>
			<button class="tb-bell" aria-label="Notifications">
				<i class="ti ti-bell" aria-hidden="true"></i>
			</button>
		</div>

		<!-- CONTENT -->
		<div class="content">

			<!-- ── DASHBOARD ── -->
			<div class="screen <%=isPaymentView ? "" : "active"%>"
				id="screen-dashboard">

				<div class="dash-header">
					<div>
						<div class="dash-date"><%=dateStr%></div>
						<div class="dash-greeting"><%=greeting%>,
							<%=farmerName.split(" ")[0]%></div>
					</div>
					<div class="dash-av"><%=avatarChar%></div>
				</div>

				<div class="progress-card">
					<div class="ring-wrap">
						<svg style="transform: rotate(-90deg)" width="130" height="130"
							viewBox="0 0 130 130">
				<circle cx="65" cy="65" r="50" fill="none"
								stroke="rgba(72,199,162,0.09)" stroke-width="11" />
				<circle cx="65" cy="65" r="50" fill="none" stroke="#48c7a2"
								stroke-width="11" stroke-dasharray="314.2"
								stroke-dashoffset="<%=(int) (314.2 - (314.2 * daysPercent / 100))%>"
								stroke-linecap="round" />
				<circle cx="65" cy="65" r="36" fill="none"
								stroke="rgba(72,199,162,0.07)" stroke-width="8" />
				<circle cx="65" cy="65" r="36" fill="none" stroke="#2a8f72"
								stroke-width="8" stroke-dasharray="226.2"
								stroke-dashoffset="<%=(int) (226.2 - (226.2 * milkPercent / 100))%>"
								stroke-linecap="round" />
			</svg>
						<div class="ring-label">
							<div class="ring-num"><%=activeDays%></div>
							<div class="ring-sub">days active</div>
						</div>
					</div>
					<div style="flex: 1">
						<div
							style="font-size: 11px; color: var(--text2); margin-bottom: 14px;">Season
							overview</div>
						<div class="prog-label">
							<span style="color: var(--teal); font-size: 12px;">Total
								Earning</span> <span
								style="color: var(--text); font-size: 12px; font-weight: 500;">₹<%=String.format("%.0f", totalEarnYear)%></span>
						</div>
						<div class="prog-track">
							<div class="prog-fill"
								style="background:var(--teal);width:<%=daysPercent%>%"></div>
						</div>
						<div class="prog-label">
							<span style="color: var(--teal-d); font-size: 12px;">Total
								Milk</span> <span
								style="color: var(--text); font-size: 12px; font-weight: 500;"><%=String.format("%.2f", totalMilkYear)%>
								L</span>
						</div>
						<div class="prog-track" style="margin-bottom: 0">
							<div class="prog-fill"
								style="background:var(--teal-d);width:<%=milkPercent%>%"></div>
						</div>
					</div>
				</div>

				<div class="stat-grid">
					<div class="stat-tile">
						<i class="ti ti-droplet" style="color: var(--teal)"
							aria-hidden="true"></i>
						<div class="stat-num"><%=String.format("%.2f", cycleSummary.getTotalMilk())%></div>
						<div class="stat-lbl">Total Litres This Cycle</div>
						<span class="stat-pill"
							style="background: rgba(72, 199, 162, 0.1); color: var(--teal);">
							+<%=String.format("%.2f", todayMilk)%> today
						</span>
					</div>
					<div class="stat-tile">
						<i class="ti ti-cash" style="color: var(--teal-d)"
							aria-hidden="true"></i>
						<div class="stat-num">
							₹<%=String.format("%.0f", cycleSummary.getTotalAmount())%></div>
						<div class="stat-lbl">Total Earned This Cycle</div>
						<span class="stat-pill"
							style="background: rgba(72, 199, 162, 0.1); color: var(--teal);">
							+<%=String.format("%.0f", todayEarning)%> Rs today
						</span>
					</div>
				</div>

				<div class="coll-card">
					<div class="coll-head">
						<span class="coll-title">Today's collection</span> <span
							class="logged-pill"><i class="ti ti-check"
							style="font-size: 11px"></i> Logged</span>
					</div>
					<div class="shift-grid">
						<!-- MORNING -->
						<div>
							<div class="shift-lbl">&#9728;&#65039; Morning</div>
							<%
							if (morningCowQty > 0) {
							%>
							<div style="margin-bottom: 10px;">
								<div
									style="font-size: 10px; color: var(--teal); font-weight: 700; margin-bottom: 6px; letter-spacing: .04em;">&#x1F404;
									COW</div>
								<div class="shift-row">
									<span class="shift-key">Qty</span><span class="shift-val"><%=String.format("%.2f", morningCowQty)%><span
										class="shift-unit">L</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">FAT</span><span class="shift-val"><%=String.format("%.2f", morningCowFat)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">SNF</span><span class="shift-val"><%=String.format("%.2f", morningCowSnf)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">Amt</span><span class="shift-val"
										style="color: var(--teal); font-size: 14px;">&#8377;<%=String.format("%.0f", morningCowAmt)%></span>
								</div>
							</div>
							<%
							}
							%>
							<%
							if (morningBufQty > 0) {
							%>
							<%
							if (morningCowQty > 0) {
							%><div
								style="border-top: 0.5px solid var(--border); margin: 8px 0;"></div>
							<%
							}
							%>
							<div>
								<div
									style="font-size: 10px; color: var(--teal-d); font-weight: 700; margin-bottom: 6px; letter-spacing: .04em;">&#x1F403;
									BUFFALO</div>
								<div class="shift-row">
									<span class="shift-key">Qty</span><span class="shift-val"><%=String.format("%.2f", morningBufQty)%><span
										class="shift-unit">L</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">FAT</span><span class="shift-val"><%=String.format("%.2f", morningBufFat)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">SNF</span><span class="shift-val"><%=String.format("%.2f", morningBufSnf)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">Amt</span><span class="shift-val"
										style="color: var(--teal); font-size: 14px;">&#8377;<%=String.format("%.0f", morningBufAmt)%></span>
								</div>
							</div>
							<%
							}
							%>
							<%
							if (morningCowQty == 0 && morningBufQty == 0) {
							%>
							<div
								style="font-size: 12px; color: var(--text3); margin-top: 8px;">No
								collection</div>
							<%
							}
							%>
						</div>
						<!-- EVENING -->
						<div
							style="border-left: 0.5px solid var(--border); padding-left: 16px">
							<div class="shift-lbl">&#127769; Evening</div>
							<%
							if (eveningCowQty > 0) {
							%>
							<div style="margin-bottom: 10px;">
								<div
									style="font-size: 10px; color: var(--teal); font-weight: 700; margin-bottom: 6px; letter-spacing: .04em;">&#x1F404;
									COW</div>
								<div class="shift-row">
									<span class="shift-key">Qty</span><span class="shift-val"><%=String.format("%.2f", eveningCowQty)%><span
										class="shift-unit">L</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">FAT</span><span class="shift-val"><%=String.format("%.2f", eveningCowFat)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">SNF</span><span class="shift-val"><%=String.format("%.2f", eveningCowSnf)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">Amt</span><span class="shift-val"
										style="color: var(--teal); font-size: 14px;">&#8377;<%=String.format("%.0f", eveningCowAmt)%></span>
								</div>
							</div>
							<%
							}
							%>
							<%
							if (eveningBufQty > 0) {
							%>
							<%
							if (eveningCowQty > 0) {
							%><div
								style="border-top: 0.5px solid var(--border); margin: 8px 0;"></div>
							<%
							}
							%>
							<div>
								<div
									style="font-size: 10px; color: var(--teal-d); font-weight: 700; margin-bottom: 6px; letter-spacing: .04em;">&#x1F403;
									BUFFALO</div>
								<div class="shift-row">
									<span class="shift-key">Qty</span><span class="shift-val"><%=String.format("%.2f", eveningBufQty)%><span
										class="shift-unit">L</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">FAT</span><span class="shift-val"><%=String.format("%.2f", eveningBufFat)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">SNF</span><span class="shift-val"><%=String.format("%.2f", eveningBufSnf)%><span
										class="shift-unit">%</span></span>
								</div>
								<div class="shift-row">
									<span class="shift-key">Amt</span><span class="shift-val"
										style="color: var(--teal); font-size: 14px;">&#8377;<%=String.format("%.0f", eveningBufAmt)%></span>
								</div>
							</div>
							<%
							}
							%>
							<%
							if (eveningCowQty == 0 && eveningBufQty == 0) {
							%>
							<div
								style="font-size: 12px; color: var(--text3); margin-top: 8px;">No
								collection</div>
							<%
							}
							%>
						</div>
					</div>
					<hr class="coll-divider">
					<div class="summary-grid">
						<div class="summary-tile">
							<div class="sum-lbl">Morning Earned</div>
							<div class="sum-val"><%=String.format("%.0f", morningTotal)%><span
									class="sum-unit">Rs</span>
							</div>
						</div>
						<div class="summary-tile">
							<div class="sum-lbl">Evening Earned</div>
							<div class="sum-val"><%=String.format("%.0f", eveningTotal)%><span
									class="sum-unit">Rs</span>
							</div>
						</div>
					</div>
					<div
						style="margin-top: 10px; background: rgba(72, 199, 162, 0.08); border: 0.5px solid var(--border); border-radius: 10px; padding: 10px 14px; display: flex; justify-content: space-between; align-items: center;">
						<span
							style="font-size: 12px; color: var(--text2); font-weight: 600;">Today's
							Total Earned</span> <span
							style="font-size: 20px; font-weight: 600; color: var(--teal);">&#8377;<%=String.format("%.0f", todayTotal)%></span>
					</div>
				</div>

			</div>
			<!-- /dashboard -->

			<!-- ── COMING SOON ── -->
			<div class="screen" id="screen-coming">
				<div class="coming-screen">
					<div class="coming-hero">
						<i class="ti ti-rocket" aria-hidden="true"></i>
						<h2>Features Under Development</h2>
						<p>
							Actively building these features.<br>They will be available
							in an upcoming release.
						</p>
					</div>
					<div class="cf-item">
						<div class="cf-icon teal">
							<i class="ti ti-notebook" aria-hidden="true"></i>
						</div>
						<div class="cf-text">
							<h4>Passbook</h4>
							<p>Shift-wise milk collection history with FAT, SNF and
								amount.</p>
						</div>
						<span class="cf-badge">In Progress</span>
					</div>
					<div class="cf-item">
						<div class="cf-icon teal-d">
							<i class="ti ti-chart-bar" aria-hidden="true"></i>
						</div>
						<div class="cf-text">
							<h4>Monthly &amp; Annual Report</h4>
							<p>Month-by-month breakdown of quantity, fat, SNF and
								earnings.</p>
						</div>
						<span class="cf-badge">In Progress</span>
					</div>
					<div class="cf-item">
						<div class="cf-icon teal">
							<i class="ti ti-currency-rupee" aria-hidden="true"></i>
						</div>
						<div class="cf-text">
							<h4>Milk Price Checker</h4>
							<p>Compare rates of different dairy companies by FAT/SNF.</p>
						</div>
						<span class="cf-badge">In Progress</span>
					</div>
				</div>
			</div>
			<!-- /coming -->

			<!-- ── PAYMENT HISTORY ── -->
			<div
				class="screen <%=isPaymentView && !isCycleDetailScreen ? "active" : ""%>"
				id="screen-payment">
				<div class="pay-screen">

					<div class="pay-year-badge">
						<i class="ti ti-calendar-stats" aria-hidden="true"></i>
						<div>
							<div class="pay-year-lbl">
								<%
								int yr = java.time.LocalDate.now().getYear();
								int mn = java.time.LocalDate.now().getMonthValue();
								int startYear = (mn >= 4) ? yr : yr - 1;
								out.print(startYear + "–" + (startYear + 1));
								%>
							</div>
							<div class="pay-year-hint">Tap a cycle row to see details</div>
						</div>
					</div>

					<div class="pay-summary-bar">
						<div class="pay-sbar-title">Total this year</div>
						<div class="pay-sbar-grid">
							<div class="pay-sbar-item">
								<div class="pay-sbar-lbl">Total Earned</div>
								<div class="pay-sbar-val">
									&#8377;<%=String.format("%.2f", histTotalAmt)%></div>
							</div>
							<div class="pay-sbar-item">
								<div class="pay-sbar-lbl">Total Milk</div>
								<div class="pay-sbar-val"><%=String.format("%.2f", histTotalMilk)%><span
										class="pay-sbar-unit">L</span>
								</div>
							</div>
						</div>
					</div>

					<div class="pay-list-header">
						<span class="pay-list-title">Payment Cycles</span> <span
							class="pay-list-count"><%=paymentList != null ? paymentList.size() : 0%>
							cycles</span>
					</div>

					<%
					if (paymentList == null || paymentList.isEmpty()) {
					%>
					<div class="pay-empty">
						<i class="ti ti-receipt-off" aria-hidden="true"></i>
						<p>No payment records found.</p>
					</div>
					<%
					} else {
					int ci = 0;
					for (PaymentSummary ps : paymentList) {
						String cardId = "phcard" + ci;
						String detId = "phdet" + ci;
						boolean first = (ci == 0);
						String dotColor = first ? "var(--teal)" : "var(--teal-d)";
						String metaLabel = first ? "Current cycle" : "Completed";
						String monthShort = ps.getCycleStart().getMonth().getDisplayName(java.time.format.TextStyle.SHORT,
						java.util.Locale.ENGLISH);
					%>
					<div class="pay-card" id="<%=cardId%>"
						onclick="togglePH('<%=detId%>','<%=cardId%>')">
						<div class="pay-card-row">
							<div class="pay-dot" style="background:<%=dotColor%>"></div>
							<div class="pay-info">
								<div class="pay-range">
									<%=String.format("%02d", ps.getCycleStart().getDayOfMonth())%>
									&ndash;
									<%=String.format("%02d", ps.getCycleEnd().getDayOfMonth())%>
									<%=monthShort%>
									/
									<%=ps.getCycleStart().getYear()%>
								</div>
								<div class="pay-meta"><%=metaLabel%></div>
							</div>
							<span class="pay-amt">&#8377;<%=String.format("%.2f", ps.getTotalAmount())%></span>
							<i class="ti ti-chevron-down pay-chev" id="chev<%=ci%>"
								aria-hidden="true"></i>
						</div>
						<div class="pay-detail" id="<%=detId%>">
							<div class="pay-detail-row">
								<span class="pay-detail-key"><i class="ti ti-droplet"
									aria-hidden="true"></i>Total Milk</span> <span class="pay-detail-val"><%=String.format("%.2f", ps.getTotalMilk())%>
									L</span>
							</div>
							<div class="pay-detail-row">
								<span class="pay-detail-key"><i class="ti ti-cash"
									aria-hidden="true"></i>Total Amount</span> <span
									class="pay-detail-val" style="color: var(--teal);">&#8377;<%=String.format("%.2f", ps.getTotalAmount())%></span>
							</div>
							<div class="pay-detail-row">
								<span class="pay-detail-key"><i class="ti ti-calendar"
									aria-hidden="true"></i>Period</span> <span class="pay-detail-val"><%=ps.getCycleStart()%>
									&rarr; <%=ps.getCycleEnd()%></span>
							</div>
							<
							<div class="pay-view-btn-row">
								<a class="pay-view-btn"
									href="FarmerPaymentHistoryServlet?cycleStart=<%=ps.getCycleStart()%>&cycleEnd=<%=ps.getCycleEnd()%>"
									onclick="event.stopPropagation()"> <i class="ti ti-eye"></i>
									View Details
								</a>
							</div>
						</div>
					</div>
					<%
					ci++;
					}
					}
					%>

				</div>
			</div>
			<!-- /payment -->

			<!-- ── CYCLE DETAIL ── -->
			<%
			isCycleDetailScreen = "cycleDetail".equals(request.getAttribute("currentView"));
			List<PaymentSummary> cycleEntries2 = (List<PaymentSummary>) request.getAttribute("cycleEntries");
			double cdTotalMilk = 0, cdTotalAmt = 0;
			if (cycleEntries2 != null) {
				for (PaymentSummary e : cycleEntries2) {
					cdTotalMilk += e.getTotalMilk();
					cdTotalAmt += e.getTotalAmount();
				}
			}
			%>
			<div class="screen <%=isCycleDetailScreen ? "active" : ""%>"
				id="screen-cycledetail">
				<div class="pay-screen">

					<!-- Header -->
					<div class="cycle-detail-header">
						<a class="cycle-back-btn" href="FarmerPaymentHistoryServlet">
							<i class="ti ti-arrow-left"></i> Back
						</a>
						<div>
							<div class="cycle-detail-title">Payment Details</div>
							<div class="cycle-detail-subtitle"><%=cycleStartAttr%>
								&rarr;
								<%=cycleEndAttr%></div>
						</div>
					</div>

					<!-- Cycle total summary bar -->
					<div class="cycle-total-bar">
						<span class="cycle-total-lbl">Cycle Total</span> <span
							class="cycle-total-val">&#8377;<%=String.format("%.2f", cdTotalAmt)%>
							<span
							style="font-size: 11px; color: var(--text2); font-weight: 500;">
								&nbsp;|&nbsp;<%=String.format("%.2f", cdTotalMilk)%> L
						</span>
						</span>
					</div>

					<!-- Entry cards -->
					<%
					if (cycleEntries2 == null || cycleEntries2.isEmpty()) {
					%>
					<div class="pay-empty">
						<i class="ti ti-receipt-off"></i>
						<p>No entries found for this cycle.</p>
					</div>
					<%
					} else {
					for (PaymentSummary e : cycleEntries2) {
						String shiftTime = "Morning".equalsIgnoreCase(e.getShift()) ? "06:00" : "18:00";
					%>
					<div class="entry-card">
						<div class="entry-card-grid">
							<div class="entry-field">
								<span class="entry-lbl">Date Time</span> <span class="entry-val"><%=e.getCollectionDate()%>
									<%=shiftTime%></span>
							</div>
							<div class="entry-field">
								<span class="entry-lbl">Shift – Cattle Type</span> <span
									class="entry-val"><%=e.getShift()%> – <%=e.getMilkType()%></span>
							</div>
							<div class="entry-field">
								<span class="entry-lbl">Quantity (Ltr)</span> <span
									class="entry-val"><%=e.getTotalMilk()%></span>
							</div>
							<div class="entry-field">
								<span class="entry-lbl">Fat(%) – Snf(%)</span> <span
									class="entry-val"><%=e.getFat()%> – <%=e.getSnf()%></span>
							</div>
							<div class="entry-field">
								<span class="entry-lbl">Rate Per Ltr</span> <span
									class="entry-val"><%=String.format("%.2f", e.getRatePerLtr())%></span>
							</div>
							<div class="entry-field">
								<span class="entry-lbl">Amount</span> <span
									class="entry-val entry-amount">&#8377;<%=String.format("%.2f", e.getTotalAmount())%></span>
							</div>
						</div>
					</div>
					<%
					}
					}
					%>

				</div>
			</div>
			<!-- /cycle detail -->

			<!-- ── PROFILE ── -->
			<div class="screen" id="screen-profile">
				<div class="profile-header">
					<div class="ph-av"><%=avatarChar%></div>
					<div class="ph-name"><%=farmerName%></div>
					<div class="ph-id"><%=farmerCode%></div>
				</div>
				<div class="profile-body">
					<div class="prof-section">
						<div class="prof-sec-title">Personal Details</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-user"
								aria-hidden="true"></i>Full Name</span> <span class="prof-val"><%=farmerName%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-phone"
								aria-hidden="true"></i>Mobile</span> <span class="prof-val"><%=mobile%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-id-badge"
								aria-hidden="true"></i>Farmer Code</span> <span class="prof-val"><%=farmerCode%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-map-pin"
								aria-hidden="true"></i>Address</span> <span class="prof-val"><%=address%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-calendar-plus"
								aria-hidden="true"></i>Joined</span> <span class="prof-val"><%=joinedDate%></span>
						</div>
					</div>
					<div class="prof-section">
						<div class="prof-sec-title">Bank Details</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-building-bank"
								aria-hidden="true"></i>Bank Name</span> <span class="prof-val"><%=bankName%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-credit-card"
								aria-hidden="true"></i>Account No</span> <span class="prof-val"><%=accountNo%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-hash"
								aria-hidden="true"></i>IFSC Code</span> <span class="prof-val"><%=ifscCode%></span>
						</div>
					</div>
					<div class="prof-section">
						<div class="prof-sec-title">MPP Details</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-building"
								aria-hidden="true"></i>MPP Code</span> <span class="prof-val"><%=mppCode%></span>
						</div>
						<div class="prof-row">
							<span class="prof-key"><i class="ti ti-checkup-list"
								aria-hidden="true"></i>Status</span> <span class="prof-val"
								style="color: var(--teal); font-weight: 700;"><%=mppStatus%></span>
						</div>
					</div>
				</div>
			</div>
			<!-- /profile -->

		</div>
		<!-- /content -->

		<!-- BOTTOM NAV -->
		<div class="bottom-nav">
			<button class="nav-btn <%=isPaymentView ? "" : "active"%>"
				id="nav-dashboard"
				onclick="window.location.href='FarmerDashboardServlet'">
				<i class="ti ti-home" aria-hidden="true"></i>Home
			</button>
			<button class="nav-btn <%=isPaymentView ? "active" : ""%>"
				id="nav-payment"
				onclick="window.location.href='FarmerPaymentHistoryServlet'">
				<i class="ti ti-cash" aria-hidden="true"></i>Payment
			</button>
			<button class="nav-btn" id="nav-coming"
				onclick="navTo('coming',null,'Features Coming Soon')">
				<i class="ti ti-package" aria-hidden="true"></i>Feeds
			</button>
			<button class="nav-btn" id="nav-coming2"
				onclick="navTo('coming',null,'Features Coming Soon')">
				<i class="ti ti-chart-bar" aria-hidden="true"></i>Report
			</button>
			<button class="nav-btn" id="nav-profile"
				onclick="navTo('profile',null,'My Profile')">
				<i class="ti ti-user-circle" aria-hidden="true"></i>Profile
			</button>
		</div>

	</div>
	<!-- /app -->

	<script>
function navTo(id, drawerItem, title) {
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
    document.getElementById('screen-' + id).classList.add('active');
    document.getElementById('page-title').textContent = title;
    document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
    const nb = document.getElementById('nav-' + id);
    if (nb) nb.classList.add('active');
    document.querySelectorAll('.dr-item').forEach(b => b.classList.remove('active'));
    if (drawerItem) drawerItem.classList.add('active');
    document.querySelector('.content').scrollTop = 0;
}
function openDrawer() {
    document.getElementById('drawer').classList.add('open');
    document.getElementById('overlay').classList.add('open');
}
function closeDrawer() {
    document.getElementById('drawer').classList.remove('open');
    document.getElementById('overlay').classList.remove('open');
}
function togglePH(detId, cardId) {
    var det  = document.getElementById(detId);
    var idx  = cardId.replace('phcard','');
    var chev = document.getElementById('chev' + idx);
    var isOpen = det.style.display === 'block';
    document.querySelectorAll('[id^="phdet"]').forEach(function(d){ d.style.display='none'; });
    document.querySelectorAll('[id^="chev"]').forEach(function(c){ c.style.transform=''; });
    if (!isOpen) {
        det.style.display = 'block';
        chev.style.transform = 'rotate(180deg)';
    }
}
</script>
</body>
</html>
