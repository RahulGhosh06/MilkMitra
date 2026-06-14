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
<title>MilkMitra | Milk Collection</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
    --text:#0f1f3d;--muted:#6b7a99;
    --border:#e8edf6;--bg:#f4f7fe;--white:#fff;--radius:12px;
}
body{font-family:'DM Sans',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:flex-start;justify-content:center;padding:40px 20px;}
.wrap{width:100%;max-width:600px;}

/* Header */
.page-header{display:flex;align-items:center;gap:14px;margin-bottom:24px;}
.hd-avatar{width:48px;height:48px;border-radius:50%;background:var(--blue-lt);border:1px solid #bfdbfe;display:flex;align-items:center;justify-content:center;color:var(--blue);flex-shrink:0;}
.hd-avatar i{font-size:24px;}
.hd-title{font-size:20px;font-weight:700;color:var(--navy);margin:0;}
.hd-sub{font-size:13px;color:var(--muted);margin:0;}

/* Alerts */
.alert{padding:11px 15px;border-radius:10px;font-size:13px;margin-bottom:16px;display:flex;align-items:center;gap:9px;}
.alert-success{background:var(--green-lt);color:#166534;border:1px solid #bbf7d0;}
.alert-error{background:var(--red-lt);color:#991b1b;border:1px solid #fecaca;}
.alert i{font-size:17px;flex-shrink:0;}

/* Card */
.form-card{background:var(--white);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}

/* Section label */
.sec-lbl{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.7px;color:var(--muted);padding:10px 20px 8px;background:#f8fafd;border-bottom:1px solid var(--border);}

/* Field grid */
.fields{display:grid;grid-template-columns:1fr 1fr;}
.field{padding:14px 20px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);}
.field:nth-child(2n){border-right:none;}
.field.full{grid-column:1/-1;border-right:none;}
.field label{display:flex;align-items:center;gap:5px;font-size:11px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:.4px;margin-bottom:7px;}
.field label i{font-size:14px;}
.field input[type=text],
.field input[type=number]{width:100%;background:transparent;border:none;outline:none;font-size:15px;font-weight:600;color:var(--navy);padding:0;font-family:'DM Sans',sans-serif;}
.field input::placeholder{color:#c4cdd8;font-weight:400;}
.field input[type=number]{-moz-appearance:textfield;}
.field input[type=number]::-webkit-inner-spin-button,
.field input[type=number]::-webkit-outer-spin-button{-webkit-appearance:none;}

/* Computed rows */
.computed-row{display:flex;align-items:center;justify-content:space-between;padding:13px 20px;border-bottom:1px solid var(--border);}
.computed-row:last-child{border-bottom:none;}
.cr-label{font-size:13px;color:var(--muted);display:flex;align-items:center;gap:8px;}
.cr-label i{font-size:16px;}
.cr-val{font-size:14px;font-weight:700;color:var(--navy);}
.badge{display:inline-flex;align-items:center;gap:5px;padding:4px 11px;border-radius:20px;font-size:12px;font-weight:600;}
.badge-morning{background:var(--blue-lt);color:var(--blue);}
.badge-evening{background:var(--purple-lt);color:var(--purple);}
.badge-cow{background:var(--green-lt);color:var(--green);}
.badge-buffalo{background:var(--amber-lt);color:var(--amber);}
.badge i{font-size:13px;}

/* Submit */
.submit-area{padding:16px 20px;background:#f8fafd;border-top:1px solid var(--border);}
.btn-submit{width:100%;padding:13px;background:var(--navy);color:#fff;border:none;border-radius:10px;font-size:14px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:9px;transition:background .18s;}
.btn-submit:hover{background:#1e3a6b;}
.btn-submit i{font-size:18px;}
</style>
</head>
<body>
<div class="wrap">

    <!-- Header -->
    <div class="page-header">
        <div class="hd-avatar"><i class="ti ti-droplet"></i></div>
        <div>
            <p class="hd-title">Milk collection entry</p>
            <p class="hd-sub" id="shiftSubtitle">Loading...</p>
        </div>
    </div>

    <!-- Alerts from session -->
    <% if(successMsg != null){ %>
    <div class="alert alert-success"><i class="ti ti-circle-check"></i><%= successMsg %></div>
    <% } %>
    <% if(errorMsg != null){ %>
    <div class="alert alert-error"><i class="ti ti-alert-circle"></i><%= errorMsg %></div>
    <% } %>

    <form action="milkcollectionServlet" method="post">
        <div class="form-card">

            <!-- Farmer details -->
            <div class="sec-lbl">Farmer details</div>
            <div class="fields">
                <div class="field full">
    				<label><i class="ti ti-id"></i>Farmer code</label>
    				<input type="text" id="farmerCode" name="farmerCode" placeholder="Enter Farmer No (1-99)" oninput="loadFarmerName()" required>
				</div>

				<div class="field full" id="farmerNameRow" style="display:none;">
    				<label><i class="ti ti-user"></i>Farmer Name</label>
    				<input type="text" id="farmerName" readonly>
				</div>
            </div>

            <!-- Milk readings -->
            <div class="sec-lbl">Milk readings</div>
            <div class="fields">
                <div class="field">
                    <label><i class="ti ti-droplet-half"></i>Quantity (litres)</label>
                    <input type="number" step="0.01" id="quantity" name="quantity" placeholder="0.00" oninput="recalc()" required>
                </div>
                <div class="field">
                    <label><i class="ti ti-percentage"></i>FAT (%)</label>
                    <input type="number" step="0.01" id="fat" name="fat" placeholder="0.00" oninput="recalc()" required>
                </div>
                <div class="field">
                    <label><i class="ti ti-percentage"></i>SNF (%)</label>
                    <input type="number" step="0.01" name="snf" placeholder="0.00" required>
                </div>
                <div class="field">
                    <label><i class="ti ti-coin-rupee"></i>Amount (&#8377;)</label>
                    <input type="number" step="0.01" id="amount" name="amount" placeholder="0.00" oninput="recalc()" required>
                </div>
            </div>

            <!-- Computed values -->
            <div class="sec-lbl">Computed values</div>

            <div class="computed-row">
                <span class="cr-label"><i class="ti ti-sun"></i>Shift</span>
                <span class="badge badge-morning" id="shiftBadge"><i class="ti ti-sun"></i>Morning</span>
                <input type="hidden" id="shift" name="shift">
            </div>
            <div class="computed-row">
                <span class="cr-label"><i class="ti ti-cow"></i>Milk type</span>
                <span class="badge badge-cow" id="milkTypeBadge"><i class="ti ti-droplet"></i>Cow (C)</span>
                <input type="hidden" id="milkType" name="milkType">
            </div>
            <div class="computed-row">
                <span class="cr-label"><i class="ti ti-receipt"></i>Rate per litre</span>
                <span class="cr-val" id="rateDisplay">—</span>
                <input type="hidden" id="ratePerLtr" name="ratePerLtr">
            </div>

        </div>

        <div class="submit-area">
            <button type="submit" class="btn-submit">
                <i class="ti ti-device-floppy"></i>Save collection
            </button>
        </div>
    </form>

</div>

<script>
function loadFarmerName()
{
    let code =
        document.getElementById("farmerCode")
                .value.trim();

    if(code === "")
    {
        document.getElementById(
            "farmerNameRow"
        ).style.display = "none";

        return;
    }

    let farmerCode =
        "F" + code.padStart(3,'0');

    fetch(
        "FarmerLookUpServlet?farmerCode=" +
        farmerCode
    )
    .then(response => response.text())
    .then(data =>
    {
        if(data.trim() !== "")
        {
            document.getElementById(
                "farmerName"
            ).value = data;

            document.getElementById(
                "farmerNameRow"
            ).style.display = "block";
        }
        else
        {
            document.getElementById(
                "farmerNameRow"
            ).style.display = "none";
        }
    });
}
function recalc(){
    var fat = parseFloat(document.getElementById("fat").value)      || 0;
    var qty = parseFloat(document.getElementById("quantity").value) || 0;
    var amt = parseFloat(document.getElementById("amount").value)   || 0;

    // Milk type
    var milkType = fat >= 6 ? "B" : "C";
    document.getElementById("milkType").value = milkType;
    var mtBadge = document.getElementById("milkTypeBadge");
    if(milkType === "B"){
        mtBadge.innerHTML = '<i class="ti ti-droplet-filled"></i>Buffalo (B)';
        mtBadge.className = "badge badge-buffalo";
    } else {
        mtBadge.innerHTML = '<i class="ti ti-droplet"></i>Cow (C)';
        mtBadge.className = "badge badge-cow";
    }

    // Rate per litre
    var rate = qty > 0 ? (amt / qty) : 0;
    document.getElementById("ratePerLtr").value = rate.toFixed(2);
    document.getElementById("rateDisplay").textContent = qty > 0 ? "\u20B9" + rate.toFixed(2) : "\u2014";

    // Shift
    var h = new Date().getHours();
    var shift = h < 12 ? "MORNING" : "EVENING";
    document.getElementById("shift").value = shift;
    var sBadge = document.getElementById("shiftBadge");
    if(shift === "MORNING"){
        sBadge.innerHTML = '<i class="ti ti-sun"></i>Morning';
        sBadge.className = "badge badge-morning";
    } else {
        sBadge.innerHTML = '<i class="ti ti-moon"></i>Evening';
        sBadge.className = "badge badge-evening";
    }

    // Header subtitle
    var dateStr = new Date().toLocaleDateString("en-IN",{day:"2-digit",month:"short",year:"numeric"});
    document.getElementById("shiftSubtitle").textContent =
        (h < 12 ? "Morning" : "Evening") + " shift \u00B7 " + dateStr;
}
recalc();
</script>
</body>
</html>
