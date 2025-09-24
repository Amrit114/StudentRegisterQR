<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            margin: 0;
        }
        .login-box {
            width: 400px;
            margin: 100px auto;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            overflow: hidden;
        }
        /* Dark menu-style header */
        .login-header {
            background: #343a40; /* same as menu bar */
            color: #fff;
            text-align: center;
            padding: 15px;
            font-size: 20px;
            font-weight: bold;
        }
        .login-body {
            padding: 25px;
        }
        h3 {
            text-align: center;
            margin-bottom: 15px;
            color: #343a40; /* consistent with dark theme */
        }
        input[type=text], input[type=password] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #343a40;  /* dark theme button */
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
            transition: 0.3s;
        }
        button:hover { background: #007bff; } /* hover blue accent */

        .extra-links {
            text-align: center;
            margin-top: 12px;
            font-size: 14px;
        }
        .extra-links a {
            color: #007bff;
            text-decoration: none;
        }
        .extra-links a:hover {
            text-decoration: underline;
        }

        .error {
            color: #c00;
            text-align: center;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <!-- Dark header bar -->
        <div class="login-header">📋 Student Details with QR Code</div>

        <div class="login-body">
            <h3>User Login</h3>
            <form method="post" action="loginaction.jsp">
                <input type="text" name="username" placeholder="Enter Username" required>
                <input type="password" name="password" placeholder="Enter Password" required>
                <button type="submit">Login</button>
            </form>

            <div class="extra-links">
                <p>Don’t have an account? <a href="register.jsp">Register here</a></p>
            </div>
        </div>
    </div>
</body>
</html>