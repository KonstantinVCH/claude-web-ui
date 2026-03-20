@echo off
echo Stopping Claude Web UI...
docker compose down
taskkill /f /fi "WINDOWTITLE eq LiteLLM" 2>nul
echo Done.
