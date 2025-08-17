# 🔧 Настройка Git для EventApp

## 📋 Предварительные требования

Перед началом деплоя необходимо настроить Git и создать GitHub репозиторий.

## 🚀 Шаг 1: Настройка Git

### 1.1 Настройка пользователя
```bash
# Установите ваше имя и email
git config --global user.name "Ваше Имя"
git config --global user.email "ваш.email@example.com"

# Пример:
git config --global user.name "Ibragim"
git config --global user.email "ibragim@example.com"
```

### 1.2 Проверка настроек
```bash
# Проверить текущие настройки
git config --list

# Проверить конкретные настройки
git config user.name
git config user.email
```

## 🌐 Шаг 2: Создание GitHub репозитория

### 2.1 Создание репозитория
1. **Перейдите на [github.com](https://github.com)**
2. **Войдите в аккаунт**
3. **Нажмите "+" → "New repository"**
4. **Заполните форму:**
   - **Repository name:** `eventapp` (или любое другое имя)
   - **Description:** `EventApp - Веб-приложение для управления мероприятиями`
   - **Visibility:** Public (или Private, если хотите)
   - **Initialize with:** НЕ ставьте галочки
5. **Нажмите "Create repository"**

### 2.2 Получение URL репозитория
После создания репозитория скопируйте URL. Он будет выглядеть так:
```
https://github.com/yourusername/eventapp.git
```

## 🔗 Шаг 3: Подключение локального репозитория

### 3.1 Добавление удаленного репозитория
```bash
# Добавить удаленный репозиторий
git remote add origin https://github.com/yourusername/eventapp.git

# Проверить удаленные репозитории
git remote -v
```

### 3.2 Первый коммит и пуш
```bash
# Добавить все файлы
git add .

# Создать первый коммит
git commit -m "Initial commit: EventApp with frontend, backend, and deployment scripts"

# Отправить в GitHub
git push -u origin main
```

## ✅ Проверка настройки

После выполнения всех шагов у вас должно быть:
- ✅ Git настроен с вашим именем и email
- ✅ GitHub репозиторий создан
- ✅ Локальный репозиторий подключен к GitHub
- ✅ Код загружен в GitHub

## 🚀 Следующие шаги

После настройки Git и создания GitHub репозитория:

1. **Деплой Frontend на Vercel**
2. **Деплой Backend на Railway**
3. **Создание базы данных на Supabase**

## 🆘 Если что-то пошло не так

### Проблема: "Authentication failed"
```bash
# Создайте Personal Access Token на GitHub:
# 1. GitHub → Settings → Developer settings → Personal access tokens
# 2. Generate new token → Select scopes: repo, workflow
# 3. Скопируйте токен и используйте его как пароль
```

### Проблема: "Repository not found"
```bash
# Проверьте URL репозитория:
git remote -v

# Если URL неверный, измените его:
git remote set-url origin https://github.com/yourusername/eventapp.git
```

### Проблема: "Permission denied"
```bash
# Убедитесь, что у вас есть права на запись в репозиторий
# Проверьте, что вы являетесь владельцем или collaborator
```

---

## 🎯 Готово к деплою!

После выполнения всех шагов вы сможете:
1. Запустить скрипт деплоя: `scripts/deploy.bat`
2. Следовать инструкциям по деплою
3. Развернуть EventApp на бесплатных хостингах

**Удачи с деплоем! 🚀**
