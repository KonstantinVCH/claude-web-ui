# OpenWebUI Connection Settings

После первого запуска настрой подключение к LiteLLM:

## Settings → Connections → OpenAI API

| Параметр | Значение |
|----------|----------|
| **URL** | `http://host.docker.internal:4000` |
| **API Key** | `sk-1234` |
| **Тип поставщика** | Open AI |
| **Тип API** | Chat Completions |
| **IDs Модели** | Оставить пустым (автоопределение) |

## Доступные модели

После сохранения настроек в селекторе моделей будут доступны:
- `anthropic/claude-sonnet-4-6` (рекомендуется)
- `anthropic/claude-opus-4-6` (более мощная, медленнее)
- `anthropic/claude-haiku-4-5` (быстрая, для простых задач)

## Постоянство настроек

Настройки сохраняются в Docker volume `claude-web-ui_open-webui-data` и не теряются при перезапуске контейнера.
