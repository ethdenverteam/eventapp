# 🔧 Решение проблемы с Railway

## ❌ Проблема:
```
✖ No start command was found
```

## ✅ Решение:

### **Вариант 1: Настройка через веб-интерфейс (Рекомендуется)**

1. **В Railway Dashboard:**
   - Перейдите в ваш проект
   - Нажмите на вкладку "Settings"
   - Найдите раздел "Service Configuration"

2. **Установите Root Directory:**
   - Найдите поле "Root Directory"
   - Введите: `backend`
   - Сохраните изменения

3. **Добавьте переменные окружения:**
   - Перейдите в "Variables"
   - Добавьте:
     - `PORT`: `5000`
     - `JWT_SECRET`: `your-secret-key-123`
     - `NODE_ENV`: `production`

4. **Перезапустите деплой:**
   - Нажмите "Deploy" или "Redeploy"

### **Вариант 2: Использование railway.json**

1. **Файл `railway.json` уже создан в корне проекта**
2. **Загрузите его в GitHub:**
   - Добавьте файл `railway.json` в ваш репозиторий
   - Сделайте коммит
   - Railway автоматически подхватит конфигурацию

### **Вариант 3: Ручная настройка команды**

1. **В Railway Dashboard:**
   - Перейдите в "Settings"
   - Найдите "Start Command"
   - Введите: `cd backend && npm start`

---

## 🔍 Проверка:

После настройки Railway должен:
- ✅ Найти папку `backend`
- ✅ Установить зависимости из `backend/package.json`
- ✅ Запустить команду `npm start`
- ✅ Запустить сервер на порту 5000

---

## 🆘 Если проблема остается:

1. **Проверьте структуру файлов:**
   ```
   eventapp/
   ├── backend/
   │   ├── package.json ✅
   │   ├── server.js ✅
   │   └── ...
   ├── frontend/
   └── railway.json ✅
   ```

2. **Проверьте содержимое `backend/package.json`:**
   ```json
   {
     "scripts": {
       "start": "node server.js" ✅
     }
   }
   ```

3. **Проверьте, что `backend/server.js` существует**

---

## 🎯 Результат:

После успешного деплоя вы получите:
- 🔧 **Backend URL:** https://your-app.railway.app
- ✅ **API работает:** https://your-app.railway.app/api/health

**Удачи с настройкой Railway! 🚀**
