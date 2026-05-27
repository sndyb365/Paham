<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PAHAM - Simple Prototype</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; padding: 20px; background: #f4f7f6; }
        .card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        .target { background: #e3f2fd; padding: 15px; border-radius: 8px; border-left: 5px solid #2196f3; margin-bottom: 20px; }
        .btn { width: 100%; padding: 12px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 16px; }
        .btn-start { background: #4caf50; color: white; }
        .btn-stop { background: #f44336; color: white; }
        .result-box { margin-top: 20px; border-top: 1px solid #ddd; padding-top: 20px; }
        .score-grid { display: grid; grid-template-cols: 1fr 1fr; gap: 10px; margin-top: 10px; }
        .score-item { background: #eee; padding: 10px; border-radius: 8px; text-align: center; }
        .score-value { font-size: 20px; font-weight: bold; color: #2196f3; }
    </style>
</head>
<body>

<div class="card">
    <h2>PAHAM Lab 🎙️</h2>
    <p>Bacalah kalimat di bawah ini:</p>
    <div class="target">
        <strong id="targetText">I love learning English with artificial intelligence</strong>
    </div>

    <button id="recordBtn" class="btn btn-start">Mulai Bicara</button>

    <div class="result-box">
        <p><strong>Hasil Suara Anda:</strong></p>
        <p id="transcriptText" style="font-style: italic; color: #666;">(Belum ada rekaman)</p>
        
        <div class="score-grid">
            <div class="score-item">
                <div>Accuracy</div>
                <div class="score-value" id="accScore">0%</div>
            </div>
            <div class="score-item">
                <div>Pronunciation</div>
                <div class="score-value" id="pronScore">0%</div>
            </div>
        </div>
    </div>
</div>

<script>
    const recordBtn = document.getElementById('recordBtn');
    const targetText = document.getElementById('targetText').innerText.toLowerCase();
    const transcriptText = document.getElementById('transcriptText');
    const accScore = document.getElementById('accScore');
    const pronScore = document.getElementById('pronScore');

    // Cek dukungan browser
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    
    if (!SpeechRecognition) {
        alert("Maaf, browser Anda tidak mendukung Web Speech API. Gunakan Chrome.");
    } else {
        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US'; // Set bahasa Inggris
        recognition.interimResults = false;

        recordBtn.addEventListener('click', () => {
            if (recordBtn.innerText === 'Mulai Bicara') {
                recognition.start();
                recordBtn.innerText = 'Mendengarkan...';
                recordBtn.className = 'btn btn-stop';
            }
        });

        recognition.onresult = (event) => {
            const result = event.results[0][0];
            const textResult = result.transcript.toLowerCase();
            const confidence = result.confidence;

            // Tampilkan teks hasil
            transcriptText.innerText = `"${textResult}"`;

            // Hitung Skor Simpel
            // 1. Accuracy: Cek apakah kata-katanya sama persis
            const accuracy = textResult === targetText ? 100 : calculateSimpleAccuracy(textResult, targetText);
            
            // 2. Pronunciation: Diambil dari confidence level API (0.0 - 1.0)
            const pronunciation = Math.round(confidence * 100);

            // Update UI
            accScore.innerText = accuracy + '%';
            pronScore.innerText = pronunciation + '%';
        };

        recognition.onend = () => {
            recordBtn.innerText = 'Mulai Bicara';
            recordBtn.className = 'btn btn-start';
        };

        // Fungsi logika skor sederhana (mencocokkan kata per kata)
        function calculateSimpleAccuracy(input, target) {
            const inputWords = input.split(' ');
            const targetWords = target.split(' ');
            let matches = 0;
            
            targetWords.forEach(word => {
                if (inputWords.includes(word)) matches++;
            });

            return Math.round((matches / targetWords.length) * 100);
        }
    }
</script>

</body>
</html>