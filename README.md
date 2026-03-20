# Claude Web UI

Веб-интерфейс для Claude (Anthropic) через LiteLLM + OpenWebUI. Работает в России через VPN.

## Что нужно установить

### 1. Python
Скачать с https://python.org (версия 3.10+), при установке отметить **Add Python to PATH**.

После установки в терминале:
```
pip install "litellm[proxy]"
```

### 2. Docker Desktop
Скачать с https://docker.com/products/docker-desktop и установить. После установки запустить и убедиться что в трее появился значок кита.

### 3. VPN
api.anthropic.com заблокирован в России — нужен VPN. Подойдёт любой: Windscale, ProtonVPN и др.

### 4. Anthropic API ключ
Зарегистрироваться на https://console.anthropic.com (нужен VPN и номер телефона не из РФ — можно купить на sms-activate.org).
Создать ключ: **API Keys → Create Key**.

---

## Установка

```bash
git clone https://github.com/KonstantinVCH/claude-web-ui.git
cd claude-web-ui
```

Скопировать `.env.example` в `.env`:
```bash
copy .env.example .env
```

Открыть `.env` и вставить свой API ключ:
```
ANTHROPIC_API_KEY=sk-ant-api03-...
```

---

## Запуск

Включить VPN, затем запустить:
```
start.bat
```

Через ~15 секунд автоматически откроется браузер на `http://localhost:3000`.

---

## Настройка OpenWebUI (только первый раз)

1. Создать аккаунт в OpenWebUI (любой email и пароль — это локально)
2. Нажать на аватар → **Settings** → **Connections**
3. В разделе **OpenAI API** нажать карандаш ✏️ и заполнить:
   - **URL:** `http://host.docker.internal:4000`
   - **Key:** `sk-1234`
4. Сохранить
5. Открыть новый чат → выбрать модель `anthropic/claude-sonnet-4-6`

---

## Остановка

```
stop.bat
```

---

## Как это работает

```
Браузер → OpenWebUI (Docker, порт 3000) → LiteLLM proxy (Python, порт 4000) → Anthropic API
```

- **OpenWebUI** — красивый веб-интерфейс, аналог ChatGPT
- **LiteLLM** — локальный прокси, конвертирует OpenAI-формат в Anthropic API (решает проблему с аутентификацией)

---

## Частые проблемы

**`start.bat` не запускается / ошибка Python**
→ Убедись что Python установлен и добавлен в PATH. Проверь: `python --version`

**`litellm` не найден**
→ Выполни: `pip install "litellm[proxy]"`

**OpenWebUI не открывается**
→ Docker Desktop должен быть запущен. Подожди 20-30 секунд и обнови страницу.

**Ошибка `Invalid API Key` в OpenWebUI**
→ Проверь что ключ правильно вставлен в `.env` без пробелов и переносов строк.

**Ошибка соединения с Anthropic**
→ Включи VPN перед запуском `start.bat`.
