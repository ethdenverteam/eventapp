# 🚀 EventApp - Веб-приложение для управления мероприятиями

Полнофункциональное веб-приложение для создания, организации и управления мероприятиями, построенное на современном стеке технологий.

## ✨ Возможности

- **🎯 Управление мероприятиями** - создание, редактирование, удаление событий
- **👥 Пользовательская система** - регистрация, авторизация, профили
- **🎫 Система билетов** - бесплатные и платные билеты
- **📱 Адаптивный дизайн** - работает на всех устройствах
- **🌙 Темная/светлая тема** - персонализация интерфейса
- **🔐 Безопасность** - JWT токены, хеширование паролей

## 🛠️ Технологии

### Frontend
- **Next.js 14** - React фреймворк с SSR
- **TypeScript** - типизированный JavaScript
- **Tailwind CSS** - utility-first CSS фреймворк
- **Framer Motion** - анимации и переходы
- **React Hook Form** - управление формами

### Backend
- **Node.js** - серверная среда выполнения
- **Express.js** - веб-фреймворк
- **JWT** - аутентификация
- **bcrypt** - хеширование паролей
- **CORS** - межсайтовые запросы

### База данных
- **PostgreSQL** - реляционная база данных
- **Supabase** - облачная платформа

## 🚀 Быстрый старт

### Локальная разработка

1. **Клонируйте репозиторий**
```bash
git clone https://github.com/yourusername/eventapp.git
cd eventapp
```

2. **Установите зависимости**
```bash
# Frontend
cd frontend
npm install

# Backend
cd ../backend
npm install
```

3. **Запустите приложение**
```bash
# Frontend (http://localhost:3000)
cd frontend
npm run dev

# Backend (http://localhost:5000)
cd ../backend
npm run dev
```

### Демо-доступ
- **Email:** `demo@example.com`
- **Пароль:** `demo123`

## 🌐 Деплой

### Frontend на Vercel
1. Создайте аккаунт на [vercel.com](https://vercel.com)
2. Подключите GitHub репозиторий
3. Укажите папку `frontend` как корневую
4. Деплой!

### Backend на Railway
1. Установите Railway CLI: `npm install -g @railway/cli`
2. Войдите в аккаунт: `railway login`
3. Деплой: `cd backend && railway up`

### База данных на Supabase
1. Создайте проект на [supabase.com](https://supabase.com)
2. Выполните SQL скрипты из `ДЕПЛОЙ_ИНСТРУКЦИЯ.md`
3. Подключите к backend через переменные окружения

## 📁 Структура проекта

```
eventapp/
├── frontend/          # Next.js приложение
│   ├── app/          # Страницы (App Router)
│   ├── components/   # React компоненты
│   ├── lib/          # Утилиты и конфигурация
│   └── public/       # Статические файлы
├── backend/           # Express.js API
│   ├── routes/       # API маршруты
│   ├── middleware/   # Промежуточное ПО
│   └── server.js     # Основной сервер
├── docs/             # Документация
└── scripts/          # Скрипты деплоя
```

## 🔧 Переменные окружения

### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=https://your-backend-url.com
```

### Backend (.env)
```env
PORT=5000
JWT_SECRET=your-super-secret-key
NODE_ENV=production
DATABASE_URL=postgresql://user:pass@host:5432/db
```

## 📱 API Endpoints

### Аутентификация
- `POST /api/auth/register` - регистрация пользователя
- `POST /api/auth/login` - вход в систему

### Пользователи
- `GET /api/user/profile` - профиль пользователя
- `PUT /api/user/profile` - обновление профиля

### Мероприятия
- `GET /api/events` - список всех мероприятий
- `POST /api/events` - создание мероприятия
- `PUT /api/events/:id` - обновление мероприятия
- `DELETE /api/events/:id` - удаление мероприятия

## 🧪 Тестирование

```bash
# Frontend тесты
cd frontend
npm run test

# Backend тесты
cd backend
npm run test
```

## 📊 Производительность

- **Lighthouse Score:** 95+ (Performance, Accessibility, Best Practices, SEO)
- **Core Web Vitals:** Все метрики в зеленой зоне
- **Bundle Size:** Оптимизирован с помощью Next.js

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции
3. Внесите изменения
4. Создайте Pull Request

## 📄 Лицензия

MIT License - см. файл [LICENSE](LICENSE)

## 🆘 Поддержка

- **Issues:** [GitHub Issues](https://github.com/yourusername/eventapp/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/eventapp/discussions)
- **Email:** support@eventapp.com

## 🙏 Благодарности

- [Next.js](https://nextjs.org/) - за отличный фреймворк
- [Tailwind CSS](https://tailwindcss.com/) - за utility-first CSS
- [Vercel](https://vercel.com/) - за бесплатный хостинг
- [Supabase](https://supabase.com/) - за базу данных

---

**Сделано с ❤️ для сообщества разработчиков**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/yourusername/eventapp)
[![Deploy to Railway](https://railway.app/button.svg)](https://railway.app/new)
