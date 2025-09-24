<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Student QR - Input Form</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            display: flex;
            background:#f7f7f7;
        }
        /* Sidebar */
        .sidebar {
            width: 220px;
            background: #2c3e50;
            color: #fff;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding-top: 20px;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #ecf0f1;
        }
        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: #ecf0f1;
            text-decoration: none;
            border-bottom: 1px solid #34495e;
        }
        .sidebar a:hover {
            background: #1abc9c;
        }

        /* Main content area */
        .content {
            margin-left: 220px;
            padding: 20px;
            flex: 1;
        }

        /* Form container */
        .container { 
            max-width: 600px; 
            margin: 20px auto; 
            background:#fff; 
            padding:20px; 
            border-radius:8px; 
            box-shadow:0 2px 6px rgba(0,0,0,0.1); 
        }
        .row { display:flex; gap:12px; }
        .col { flex:1; }
        label { display:block; margin-bottom:6px; font-weight:600; }
        input[type="text"], input[type="email"], select { 
            width:100%; 
            padding:8px 10px; 
            border:1px solid #ccc; 
            border-radius:4px; 
        }
        .actions { margin-top:16px; text-align:right; }
        button { 
            padding:10px 16px; 
            border:0; 
            background:#007bff; 
            color:#fff; 
            border-radius:6px; 
            cursor:pointer; 
        }
        button.secondary { background:#6c757d; margin-right:8px; }
        .note { font-size:0.9em; color:#666; margin-top:10px; }
        .error { color:#c00; font-size:.9em; display:none; margin-top:8px; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>📊 Dashboard</h2>
        <a href="home.jsp">🏠 Home</a>
        <a href="reg.jsp">📝 Register Student</a>
        <a href="viewStudent.jsp">👨‍🎓 View Students</a>
        <a href="readQR.jsp">📷 Scan QR</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="container">
            <h2>Student Details — Generate & Store QR</h2>

            <form id="studentForm" method="post" action="generateQR.jsp" accept-charset="UTF-8">
                <div style="margin-bottom:12px;">
                    <label for="regno">Registration No (regno) *</label>
                    <input type="text" id="regno" name="id" maxlength="20" required />
                </div>

                <div style="margin-bottom:12px;">
                    <label for="name">Student Name *</label>
                    <input type="text" id="name" name="n" maxlength="100" required />
                </div>

                <div class="row" style="margin-bottom:12px;">
                    <div class="col">
                        <label for="branch">Branch</label>
                        <select id="branch" name="branch">
                            <option value="">-- Select branch --</option>
                            <option value="CSE">CSE</option>
                            <option value="ECE">ECE</option>
                            <option value="ME">ME</option>
                            <option value="CE">CE</option>
                            <option value="EE">EE</option>
                            <option value="OTHER">OTHER</option>
                        </select>
                    </div>

                    <div class="col">
                        <label for="mobile">Mobile</label>
                        <input type="text" id="mobile" name="mobile" maxlength="30" 
                               pattern="^\+?[0-9\- ]{7,30}$" placeholder="+mobile" />
                    </div>
                </div>

                <div style="margin-bottom:12px;">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" maxlength="50" placeholder="student@example.com" />
                </div>

                <div class="error" id="err">Please fill required fields correctly.</div>

                <div class="actions">
                    <button type="button" class="secondary" onclick="clearForm()">Clear</button>
                    <button type="submit">Generate & Save QR</button>
                </div>

                <p class="note">
                    Fields marked * are required. On submit, the form posts to 
                    <code>generateQR.jsp</code> which should generate the QR image and insert 
                    data (regno, name, branch, mobile, email, qr_data, qr_image) into Oracle DB.
                </p>
            </form>
        </div>
    </div>

    <script>
        // client-side validation
        document.getElementById('studentForm').addEventListener('submit', function(e){
            var regno = document.getElementById('regno').value.trim();
            var name  = document.getElementById('name').value.trim();
            var mobile = document.getElementById('mobile').value.trim();
            var email = document.getElementById('email').value.trim();
            var err = document.getElementById('err');

            if (!regno || !name) {
                err.style.display = 'block';
                err.textContent = 'Registration number and name are required.';
                e.preventDefault();
                return;
            }
            if (mobile && !/^\+?[0-9\- ]{7,30}$/.test(mobile)) {
                err.style.display = 'block';
                err.textContent = 'Mobile number format is invalid.';
                e.preventDefault();
                return;
            }
            if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                err.style.display = 'block';
                err.textContent = 'Email format is invalid.';
                e.preventDefault();
                return;
            }
            err.style.display = 'none';
        });

        function clearForm(){
            document.getElementById('studentForm').reset();
            document.getElementById('err').style.display = 'none';
        }
    </script>
</body>
</html>