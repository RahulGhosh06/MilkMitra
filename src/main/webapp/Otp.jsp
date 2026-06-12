<%@ page import="com.milkmitra.model.User" %>

<%
response.setHeader("Cache-Control",
        "no-cache, no-store, must-revalidate");

response.setHeader("Pragma",
        "no-cache");

response.setDateHeader("Expires", 0);

String otp =
        (String) session.getAttribute("otp");

User tempUser =
        (User) session.getAttribute("tempUser");

if(otp == null || tempUser == null)
{
    response.sendRedirect("Login.jsp");
    return;
}
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | OTP Verification</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}

body{
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    font-family:'DM Sans',sans-serif;
    background:linear-gradient(135deg,#0d1f45 0%,#102f80 100%);
}

.card{
    width:100%;
    max-width:420px;
    background:#fff;
    border-radius:20px;
    box-shadow:0 24px 64px rgba(10,20,60,0.35);
    padding:48px 44px 40px;
    opacity:0;
    animation:fadeUp 0.55s ease forwards;
}

@keyframes fadeUp{
    from{opacity:0;transform:translateY(24px);}
    to{opacity:1;transform:translateY(0);}
}

/* top icon */
.otp-icon{
    width:68px;height:68px;
    background:#eff6ff;
    border-radius:50%;
    display:flex;align-items:center;justify-content:center;
    font-size:30px;
    margin:0 auto 24px;
    border:2px solid #bfdbfe;
}

.card-header{text-align:center;margin-bottom:28px;}
.card-header h2{
    font-family:'DM Serif Display',serif;
    font-size:28px;
    color:#0f1f3d;
    letter-spacing:-0.2px;
}
.card-header p{
    margin-top:8px;
    color:#6b7a99;
    font-size:14px;
    line-height:1.6;
}
.card-header p strong{color:#0f1f3d;}

/* error */
.error-box{
    display:flex;align-items:center;gap:10px;
    background:#fdf0ef;
    border:1px solid #f5c6c2;
    border-radius:8px;
    padding:11px 14px;
    margin-bottom:22px;
    font-size:13px;
    color:#c0392b;
}
.error-box::before{content:'⚠';flex-shrink:0;}

/* timer */
.timer-wrap{
    text-align:center;
    margin-bottom:20px;
    font-size:13px;
    color:#6b7a99;
}
.timer-wrap span{
    font-weight:600;
    color:#2563eb;
}

/* OTP input row */
.otp-inputs{
    display:flex;
    gap:10px;
    justify-content:center;
    margin-bottom:24px;
}
.otp-inputs input{
    width:52px;height:58px;
    text-align:center;
    font-size:22px;
    font-weight:600;
    font-family:'DM Sans',sans-serif;
    color:#0f1f3d;
    border:1.5px solid #dde3f0;
    border-radius:10px;
    background:#fafbff;
    transition:border-color .2s,box-shadow .2s;
    outline:none;
}
.otp-inputs input:focus{
    border-color:#2563eb;
    box-shadow:0 0 0 4px rgba(37,99,235,0.12);
    background:#fff;
}

/* hidden real input for form submit */
#otpHidden{display:none;}

/* verify button */
.btn-verify{
    width:100%;
    padding:14px;
    background:#2563eb;
    border:none;
    color:#fff;
    font-size:15px;
    font-weight:600;
    font-family:'DM Sans',sans-serif;
    border-radius:9px;
    cursor:pointer;
    letter-spacing:.3px;
    box-shadow:0 4px 20px rgba(37,99,235,0.38);
    transition:background .2s,transform .15s,box-shadow .15s;
    margin-bottom:12px;
}
.btn-verify:hover{
    background:#1d4ed8;
    transform:translateY(-1px);
    box-shadow:0 8px 26px rgba(37,99,235,0.44);
}
.btn-verify:active{transform:translateY(0);}

/* resend */
.btn-resend{
    width:100%;
    padding:12px;
    background:transparent;
    border:1.5px solid #dde3f0;
    color:#6b7a99;
    font-size:14px;
    font-weight:500;
    font-family:'DM Sans',sans-serif;
    border-radius:9px;
    cursor:pointer;
    transition:border-color .2s,color .2s,background .2s;
}
.btn-resend:hover{
    border-color:#2563eb;
    color:#2563eb;
    background:#eff6ff;
}

.card-footer{
    margin-top:28px;
    text-align:center;
    font-size:12px;
    color:#b0baca;
    border-top:1px solid #f0f2f8;
    padding-top:18px;
}
</style>
</head>
<body>

<div class="card">

    <div class="otp-icon">🔐</div>

    <div class="card-header">
        <h2>OTP Verification</h2>
        <p>We sent a 6-digit code to your registered email.<br>
        <strong>Enter the code below to continue.</strong></p>
    </div>

    <%
        String errorMsg = (String) session.getAttribute("otpError");
        if (errorMsg != null) {
    %>
        <div class="error-box"><%= errorMsg %></div>
    <%
            session.removeAttribute("otpError");
        }
    %>

    <!-- countdown timer -->
    <div class="timer-wrap">
        Code expires in <span id="timer">05:00</span>
    </div>

    <!-- Verify form -->
    <form action="VerifyOTP" method="post" id="verifyForm">
        <input type="hidden" name="otp" id="otpHidden">

        <div class="otp-inputs">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
            <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]">
        </div>

        <button type="submit" class="btn-verify">Verify OTP</button>
    </form>

    <!-- Resend form -->
    <form action="ResendOTP" method="post">
        <button type="submit" class="btn-resend">↺ &nbsp;Resend OTP</button>
    </form>

    <div class="card-footer">© 2026 MilkMitra. All Rights Reserved.</div>

</div>

<script>
// ── OTP digit box auto-advance ──
var digits = document.querySelectorAll('.otp-digit');

digits.forEach(function(el, i) {
    el.addEventListener('input', function() {
        this.value = this.value.replace(/[^0-9]/g, '');
        if (this.value && i < digits.length - 1) {
            digits[i + 1].focus();
        }
        syncHidden();
    });
    el.addEventListener('keydown', function(e) {
        if (e.key === 'Backspace' && !this.value && i > 0) {
            digits[i - 1].focus();
        }
    });
    // allow paste across all boxes
    el.addEventListener('paste', function(e) {
        e.preventDefault();
        var pasted = (e.clipboardData || window.clipboardData)
                        .getData('text').replace(/[^0-9]/g, '').slice(0, 6);
        pasted.split('').forEach(function(ch, idx) {
            if (digits[idx]) digits[idx].value = ch;
        });
        var next = Math.min(pasted.length, digits.length - 1);
        digits[next].focus();
        syncHidden();
    });
});

function syncHidden() {
    var val = '';
    digits.forEach(function(d) { val += d.value; });
    document.getElementById('otpHidden').value = val;
}

// collect OTP before submit
document.getElementById('verifyForm').addEventListener('submit', function() {
    syncHidden();
});

// ── Countdown timer (5 min) ──
var seconds = 300;
var timerEl = document.getElementById('timer');
var tick = setInterval(function() {
    seconds--;
    if (seconds <= 0) {
        clearInterval(tick);
        timerEl.textContent = '00:00';
        timerEl.style.color = '#c0392b';
        return;
    }
    var m = Math.floor(seconds / 60);
    var s = seconds % 60;
    timerEl.textContent = (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    if (seconds <= 60) timerEl.style.color = '#c0392b';
}, 1000);

// auto-focus first box
digits[0].focus();
</script>
</body>
</html>
