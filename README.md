# Claude Web UI

Веб-интерфейс для Claude (Anthropic) через LiteLLM + OpenWebUI. Работает в России через прокси/VPN.

## Требования

- Python 3.x + `pip install litellm[proxy]`
- Docker Desktop
- VPN или SOCKS5 прокси (api.anthropic.com заблокирован в РФ)

## Установка

1. Клонировать репозиторий
2. Скопировать `.env.example` в `.env` и вставить свой ключ:
   ```
   ANTHROPIC_API_KEY=sk-ant-api03-...
   ```

## Запуск

```
start.bat
```

Откроется браузер на `http://localhost:3000`

## Настройка OpenWebUI (только первый раз)

Settings → Connections → OpenAI API → редактировать:
- **URL:** `http://host.docker.internal:4000`
- **Key:** `sk-1234`
- **Model ID:** `anthropic/claude-sonnet-4-6`

## Остановка

```
stop.bat
```

## Как это работает

```
OpenWebUI (Docker :3000) → LiteLLM proxy (:4000) → Anthropic API
```

LiteLLM конвертирует OpenAI-формат в Anthropic API, решая проблему с заголовками аутентификации.

## Фикс для Windows

LiteLLM падает на Windows без `PYTHONUTF8=1` из-за Unicode в баннере (cp1251 не поддерживает). Уже включено в `start.bat`.
