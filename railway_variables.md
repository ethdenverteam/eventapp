# Railway Variables Update

## 🔧 Обновление переменных окружения в Railway

### 1. Откройте Railway Dashboard
- Перейдите на https://railway.app/dashboard
- Выберите проект `eventapp`

### 2. Добавьте новые переменные

#### В основном бэкенде (eventapp-production-0f47):
```
RESEND_API_KEY=re_h1BnyvkP_LFFCAv4vjwCLsp28Gn1f9ZZf
FRONTEND_URL=https://eventapp-frontend-mu.vercel.app
```

#### В Telegram боте (если создан):
```
TELEGRAM_BOT_TOKEN=your_bot_token_here
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.pseofvcvbekhgzyzqfre.supabase.co:5432/postgres
JWT_SECRET=your-secret-key-123
EVENTAPP_API_URL=https://eventapp-production-0f47.up.railway.app
FRONTEND_URL=https://eventapp-frontend-mu.vercel.app
MINI_APP_URL=https://eventapp-frontend-mu.vercel.app
PORT=3001
NODE_ENV=production
```

### 3. Перезапустите сервисы
- Нажмите "Redeploy" для каждого сервиса
- Дождитесь завершения деплоя

### 4. Проверьте логи
- Откройте логи каждого сервиса
- Убедитесь, что нет ошибок при запуске

## 🧪 Тестирование

### Проверьте регистрацию:
```bash
curl -X POST https://eventapp-production-0f47.up.railway.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Проверьте логин:
```bash
curl -X POST https://eventapp-production-0f47.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## 📋 Текущие переменные

### Основной бэкенд:
- ✅ DATABASE_URL
- ✅ JWT_SECRET
- ❌ RESEND_API_KEY (добавить)
- ❌ FRONTEND_URL (добавить)

### Telegram бот:
- ❌ TELEGRAM_BOT_TOKEN (добавить)
- ❌ DATABASE_URL (добавить)
- ❌ JWT_SECRET (добавить)
- ❌ EVENTAPP_API_URL (добавить)
- ❌ FRONTEND_URL (добавить)
- ❌ MINI_APP_URL (добавить)
- ❌ PORT (добавить)
- ❌ NODE_ENV (добавить)
