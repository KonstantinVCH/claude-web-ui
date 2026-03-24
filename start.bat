@echo off
echo Starting Claude Web UI...
echo.

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

:: Check if Docker is running
docker ps >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

:: Check if open-webui container exists and is running
echo Checking Docker containers...
docker ps -a --filter "name=open-webui" --format "{{.Names}} {{.Status}}" | findstr "open-webui" >nul 2>&1
if errorlevel 1 (
    echo No existing container found. Creating new one...
    docker compose up -d
) else (
    for /f "tokens=2*" %%a in ('docker ps -a --filter "name=open-webui" --format "{{.Status}}"') do (
        echo Found container: %%a %%b
        echo %%a | findstr /i "Up" >nul
        if errorlevel 1 (
            echo Container is stopped. Starting...
            docker start open-webui
        ) else (
            echo Container is already running
        )
    )
)

:: Start LiteLLM proxy
echo.
echo Starting LiteLLM proxy on port 4000...
start "LiteLLM" /min cmd /c "set PYTHONUTF8=1 && set ANTHROPIC_API_KEY=%ANTHROPIC_API_KEY% && set NO_PROXY=api.anthropic.com,localhost,127.0.0.1 && set no_proxy=api.anthropic.com,localhost,127.0.0.1 && litellm --model anthropic/claude-sonnet-4-6 --port 4000"

:: Wait for containers to be healthy
echo.
echo Waiting for services to start...
set /a counter=0
:wait_loop
ping 127.0.0.1 -n 3 >nul
set /a counter+=1
docker ps --filter "name=open-webui" --filter "health=healthy" --format "{{.Names}}" | findstr "open-webui" >nul 2>&1
if errorlevel 1 (
    if %counter% LSS 15 (
        echo Waiting... (%counter%/15^)
        goto wait_loop
    ) else (
        echo WARNING: Container did not become healthy in 30 seconds
    )
) else (
    echo Container is healthy!
)

:: Open browser
echo.
echo Opening browser...
start http://localhost:3000

echo.
echo ========================================
echo Claude Web UI is running!
echo ========================================
echo OpenWebUI: http://localhost:3000
echo LiteLLM: http://localhost:4000
echo.
echo First run setup (Settings - Connections - OpenAI API):
echo   URL: http://host.docker.internal:4000
echo   Key: sk-1234
echo   Model: anthropic/claude-sonnet-4-6
echo ========================================
