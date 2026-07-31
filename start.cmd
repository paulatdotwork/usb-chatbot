@echo off
setlocal
cd /d "%~dp0"
if not exist "models" mkdir models
start "" /b "bin\llama-server.exe" ^
  -m "models\gemma-4-E2B_q4_0-it.gguf" ^
  --host 127.0.0.1 --port 8080 ^
  -c 4096 --no-mmap -t 4 ^
  --chat-template-kwargs "{\"enable_thinking\":false}"
timeout /t 1 >nul
:wait
powershell -nop -c "try{(New-Object Net.Sockets.TcpClient('127.0.0.1',8080)).Close();exit 0}catch{exit 1}"
if errorlevel 1 (timeout /t 1 >nul & goto wait)
start "" http://127.0.0.1:8080
