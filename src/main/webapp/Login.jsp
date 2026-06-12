<%
response.setHeader("Cache-Control",
        "no-cache, no-store, must-revalidate");

response.setHeader("Pragma",
        "no-cache");

response.setDateHeader("Expires", 0);
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MilkMitra | Login</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box;}

body{
    min-height:100vh;
    display:flex;
    font-family:'DM Sans',sans-serif;
    background:#f0f4ff;
}

/* ─── LEFT PANEL ─── */
.panel-left{
    width:340px;
    min-height:100vh;
    background:linear-gradient(175deg,#0d1f45 0%,#0f2a6b 60%,#102f80 100%);
    display:flex;
    flex-direction:column;
    justify-content:center;
    padding:60px 40px;
    position:relative;
    overflow:hidden;
    flex-shrink:0;
}

.panel-left::before{
    content:'';
    position:absolute;
    width:420px;height:420px;
    background:radial-gradient(circle,rgba(37,99,235,0.3) 0%,transparent 70%);
    top:-120px;right:-120px;
    border-radius:50%;
}
.panel-left::after{
    content:'';
    position:absolute;
    width:280px;height:280px;
    background:radial-gradient(circle,rgba(37,99,235,0.18) 0%,transparent 70%);
    bottom:-60px;left:-60px;
    border-radius:50%;
}

/* brand */
.brand{position:relative;z-index:1;margin-bottom:10px;}
.brand h1{
    font-family:'DM Serif Display',serif;
    font-size:38px;
    color:#fff;
    letter-spacing:-0.3px;
    line-height:1;
}
.brand h1 span{color:#60a5fa;}
.brand p{
    margin-top:8px;
    color:#7ca0d4;
    font-size:14px;
    font-weight:300;
}

/* blue divider */
.left-divider{
    width:52px;height:2px;
    background:#2563eb;
    margin:28px 0;
    border-radius:2px;
    position:relative;z-index:1;
}

/* features */
.features{
    position:relative;z-index:1;
    display:flex;
    flex-direction:column;
    gap:14px;
}

.feat{
    display:flex;
    align-items:flex-start;
    gap:14px;
    padding:14px 16px;
    border-radius:12px;
    background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.1);
    opacity:0;
    animation:slideIn 0.5s ease forwards;
}
.feat:nth-child(1){animation-delay:0.15s;}
.feat:nth-child(2){animation-delay:0.3s;}
.feat:nth-child(3){animation-delay:0.45s;}

@keyframes slideIn{
    from{opacity:0;transform:translateX(-18px);}
    to{opacity:1;transform:translateX(0);}
}

.feat-icon{
    width:42px;height:42px;
    background:rgba(37,99,235,0.3);
    border:1px solid rgba(37,99,235,0.5);
    border-radius:10px;
    display:flex;align-items:center;justify-content:center;
    font-size:20px;
    flex-shrink:0;
}
.feat-text strong{
    display:block;
    color:#e2e8f0;
    font-size:14px;
    font-weight:600;
}
.feat-text span{
    color:#6b8fba;
    font-size:12px;
    line-height:1.5;
}

.left-footer{
    position:relative;z-index:1;
    margin-top:auto;
    padding-top:40px;
    font-size:12px;
    color:#2d4a70;
}

/* ─── RIGHT PANEL ─── */
.panel-right{
    flex:1;
    display:flex;
    align-items:center;
    justify-content:center;
    padding:48px 72px;
    background:#fff;
}

.login-box{
    width:100%;
    max-width:420px;
    opacity:0;
    animation:fadeUp 0.6s ease 0.1s forwards;
}

@keyframes fadeUp{
    from{opacity:0;transform:translateY(20px);}
    to{opacity:1;transform:translateY(0);}
}

.login-header{margin-bottom:36px;}
.login-header h2{
    font-family:'DM Serif Display',serif;
    font-size:34px;
    color:#0f1f3d;
    letter-spacing:-0.3px;
}
.login-header p{
    margin-top:9px;
    color:#6b7a99;
    font-size:14px;
}

/* error */
.error-box{
    display:flex;align-items:center;gap:10px;
    background:#fdf0ef;
    border:1px solid #f5c6c2;
    border-radius:8px;
    padding:12px 14px;
    margin-bottom:24px;
    font-size:13px;
    color:#c0392b;
}
.error-box::before{content:'⚠';flex-shrink:0;}

/* form */
.form-group{margin-bottom:22px;}
.form-group label{
    display:block;
    margin-bottom:7px;
    font-size:13px;
    font-weight:600;
    color:#0f1f3d;
}
.input-wrap{position:relative;}
.input-wrap .icon{
    position:absolute;
    left:14px;top:50%;
    transform:translateY(-50%);
    font-size:16px;
    opacity:0.32;
    pointer-events:none;
}
.form-group input{
    width:100%;
    padding:13px 14px 13px 44px;
    border:1.5px solid #dde3f0;
    border-radius:9px;
    font-size:14px;
    font-family:'DM Sans',sans-serif;
    color:#0f1f3d;
    background:#fafbff;
    transition:border-color .2s,box-shadow .2s,background .2s;
}
.form-group input::placeholder{color:#bbc4d8;}
.form-group input:focus{
    outline:none;
    border-color:#2563eb;
    background:#fff;
    box-shadow:0 0 0 4px rgba(37,99,235,0.1);
}
.toggle-pw{
    position:absolute;
    right:14px;top:50%;
    transform:translateY(-50%);
    cursor:pointer;
    font-size:16px;
    opacity:0.32;
    transition:opacity .2s;
    user-select:none;
}
.toggle-pw:hover{opacity:.7;}

/* button */
.login-btn{
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
    margin-top:4px;
    transition:background .2s,transform .15s,box-shadow .15s;
    box-shadow:0 4px 20px rgba(37,99,235,0.38);
}
.login-btn:hover{
    background:#1d4ed8;
    transform:translateY(-1px);
    box-shadow:0 8px 26px rgba(37,99,235,0.44);
}
.login-btn:active{transform:translateY(0);}

.right-footer{
    margin-top:40px;
    text-align:center;
    font-size:12px;
    color:#b0baca;
    border-top:1px solid #f0f2f8;
    padding-top:20px;
}

@media(max-width:720px){
    .panel-left{display:none;}
    .panel-right{padding:40px 28px;}
}
</style>
</head>
<body>

<!-- ═══ LEFT PANEL ═══ -->
<div class="panel-left">

    <div class="brand">
        <h1>Milk<span>Mitra</span></h1>
        <p>Dairy Management Platform</p>
    </div>

    <div class="left-divider"></div>

    <div class="features">
        <div class="feat">
            <div class="feat-icon">📊</div>
            <div class="feat-text">
                <strong>Real-time Dashboard</strong>
                <span>Track milk collection &amp; delivery</span>
            </div>
        </div>
        <div class="feat">
            <div class="feat-icon">👨‍🌾</div>
            <div class="feat-text">
                <strong>Farmer Management</strong>
                <span>Manage farmer records &amp; payments</span>
            </div>
        </div>
        <div class="feat">
            <div class="feat-icon">🔒</div>
            <div class="feat-text">
                <strong>Secure OTP Login</strong>
                <span>Two-factor authentication enabled</span>
            </div>
        </div>
    </div>

    <div class="left-footer">© 2026 MilkMitra. All Rights Reserved.</div>

</div>

<!-- ═══ RIGHT PANEL ═══ -->
<div class="panel-right">
    <div class="login-box">

        <div class="login-header">
            <h2>Welcome back</h2>
            <p>Sign in to your MilkMitra account</p>
        </div>

        <%
            String errorMsg = (String) session.getAttribute("errorMsg");
            String errorParam = request.getParameter("error");
            if (errorMsg == null && errorParam != null) {
                if      ("expired".equals(errorParam))     errorMsg = "OTP expired. Please login again.";
                else if ("maxattempts".equals(errorParam)) errorMsg = "Too many wrong attempts. Please login again.";
                else if ("invalid".equals(errorParam))     errorMsg = "Invalid username or password.";
                else if ("session".equals(errorParam))     errorMsg = "Session lost. Please login again.";
            }
            if (errorMsg != null) {
        %>
            <div class="error-box"><%= errorMsg %></div>
        <%
                session.removeAttribute("errorMsg");
            }
        %>

        <form action="Login" method="post">

            <div class="form-group">
                <label for="username">Username</label>
                <div class="input-wrap">
                    <span class="icon">👤</span>
                    <input type="text"
                           id="username"
                           name="username"
                           placeholder="Enter your username"
                           autocomplete="username"
                           required>
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrap">
                    <span class="icon">🔑</span>
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter your password"
                           autocomplete="current-password"
                           required>
                    <span class="toggle-pw" onclick="togglePw()" title="Show/hide">👁</span>
                </div>
            </div>

            <button type="submit" class="login-btn">Sign In →</button>

        </form>

        <div class="right-footer">© 2026 MilkMitra. All Rights Reserved.</div>

    </div>
</div>

<script>
function togglePw(){
    var p = document.getElementById('password');
    p.type = p.type === 'password' ? 'text' : 'password';
}
</script>
</body>
</html>
