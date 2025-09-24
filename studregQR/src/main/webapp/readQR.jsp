<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>QR Code Scanner</title>
    <script src="https://unpkg.com/html5-qrcode/html5-qrcode.min.js"></script>
    <style>
        #reader { width: 400px; margin: auto; }
        #result { margin: 20px; font-size: 18px; font-weight: bold; color: green; text-align: center; }
        #studentDetails { 
            margin: 20px auto; 
            width: 400px; 
            border: 1px solid #ccc; 
            padding: 15px; 
            border-radius: 8px; 
            background: #fff; 
            display:none; 
        }
        #printBtn { margin-top:15px; padding:8px 14px; background:#007bff; color:#fff; border:none; border-radius:6px; cursor:pointer; }
    </style>
</head>
<body>
    <h2 align="center">Scan Student QR Code</h2>
    <div id="reader"></div>
    <div id="result"></div>
    <div id="studentDetails"></div>

    <script>
        const html5QrCode = new Html5Qrcode("reader");

        function speak(text) {
            const msg = new SpeechSynthesisUtterance(text);
            msg.lang = "en-IN";   // Indian English voice
            window.speechSynthesis.speak(msg);
        }

        function onScanSuccess(decodedText) {
            document.getElementById("result").innerHTML = "✅ Scanned Data: " + decodedText;

            // Stop scanner
            html5QrCode.stop();

            // Extract RegNo from scanned text (assuming format: "RegNo: 100 | Name: ...")
            let regMatch = decodedText.match(/RegNo:\s*(\d+)/i);
            let regno = regMatch ? regMatch[1] : decodedText.trim();

            // Fetch student info from DB using only RegNo
            fetch("getStudent.jsp?regno=" + encodeURIComponent(regno))
                .then(res => res.text())
                .then(data => {
                    document.getElementById("studentDetails").innerHTML = data;
                    document.getElementById("studentDetails").style.display = "block";

                    // Audio readout
                    const plainText = document.getElementById("studentDetails").innerText;
                    speak("Welcome " + plainText+" Thank You!");
                })
                .catch(err => {
                    document.getElementById("studentDetails").innerHTML =
                        "<p style='color:red;'>Error fetching details</p>";
                    speak("Error fetching student details");
                });
        }
        // Start camera
        Html5Qrcode.getCameras().then(cameras => {
            if (cameras && cameras.length) {
                html5QrCode.start(
                    cameras[0].id,
                    { fps: 10, qrbox: 250 },
                    onScanSuccess
                );
            }
        }).catch(err => console.error("Camera error:", err));
    </script>
</body>
</html>