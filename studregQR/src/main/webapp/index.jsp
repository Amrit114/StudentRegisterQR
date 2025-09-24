<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Data QR Management - Home</title>
    <style>
        body {
            margin:0;
            padding:0;
            font-family: Arial, sans-serif;
            background: linear-gradient(120deg, #007bff, #6c63ff);
            color: #fff;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background: #fff;
            color: #333;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            text-align: center;
            width: 420px;
        }
        h1 { margin-bottom: 20px; color: #007bff; }
        p { margin-bottom: 25px; font-size: 14px; color: #555; }
        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background: #007bff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            color: #fff;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover { background: #0056b3; }
        .btn.secondary { background: #6c757d; }
        .btn.secondary:hover { background: #565e64; }
        .section-title {
            font-size: 18px;
            margin-top: 20px;
            margin-bottom: 10px;
            color: #444;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Student Data & QR Management</h1>
        <p>Choose your role to continue:</p>

        <div>
            <div class="section-title">👨‍🎓 Student</div>
            <form action="login.jsp" method="get">
                <button type="submit" class="btn">🔑 Student Login</button>
            </form>
            <form action="register.jsp" method="get">
                <button type="submit" class="btn secondary">📝 Register</button>
            </form>
        </div>

        <div>
            <div class="section-title">🛡 Admin</div>
            <form action="login.jsp" method="get">
                <button type="submit" class="btn">🔑 Admin Login</button>
            </form>
        </div>
    </div>
</body>
</html>