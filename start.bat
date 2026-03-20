@echo off
echo Starting Claude Web UI...

:: Load API key from .env
for /f "tokens=1,2 delims==" %%a in (.env) do (
    if "%%a"=="ANTHROPIC_API_KEY" set ANTHROPIC_API_KEY=%%b
)

if "%ANTHROPIC_API_KEY%"=="" (
    echo ERROR: ANTHROPIC_API_KEY not set in .env file
    echo Copy .env.example to .env and fill in your API key
    pause
    exit /b 1
)

:: Start LiteLLM proxy
echo Starting LiteLLM proxy on port 4000...
start "LiteLLM" /min cmd /c "set PYTHONUTF8=1 && set ANTHROPIC_API_KEY=%ANTHROPIC_API_KEY% && litellm --model anthropic/claude-sonnet-4-6 --port 4000"

:: Start OpenWebUI
echo Starting OpenWebUI on port 3000...
docker compose up -d

:: Wait for services to start
timeout /t 12 /nobreak

:: Open browser
start http://localhost:3000

echo.
echo Claude Web UI is running at http://localhost:3000
echo.
echo OpenWebUI settings (first run only):
echo   Settings - Connections - OpenAI API:
echo     URL: http://host.docker.internal:4000
echo     Key: sk-1234
echo     Model ID: anthropic/claude-sonnet-4-6
