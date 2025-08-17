-- EventApp Database Migration Script
-- Безопасное обновление существующей базы данных
-- PostgreSQL

-- Enable UUID extension (если еще не включено)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- ОБНОВЛЕНИЕ ТАБЛИЦЫ USERS
-- ========================================

-- Добавляем новые колонки в таблицу users (если их нет)
DO $$ 
BEGIN
    -- Добавляем telegram_id если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'telegram_id') THEN
        ALTER TABLE users ADD COLUMN telegram_id BIGINT UNIQUE;
    END IF;
    
    -- Добавляем telegram_username если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'telegram_username') THEN
        ALTER TABLE users ADD COLUMN telegram_username VARCHAR(255);
    END IF;
    
    -- Добавляем telegram_connected если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'telegram_connected') THEN
        ALTER TABLE users ADD COLUMN telegram_connected BOOLEAN DEFAULT FALSE;
    END IF;
    
    -- Добавляем uuid если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'uuid') THEN
        ALTER TABLE users ADD COLUMN uuid UUID DEFAULT uuid_generate_v4() UNIQUE;
    END IF;
    
    -- Добавляем email_verified если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'email_verified') THEN
        ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
    END IF;
    
    -- Добавляем verification_token если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'verification_token') THEN
        ALTER TABLE users ADD COLUMN verification_token VARCHAR(255);
    END IF;
    
    -- Добавляем reset_token если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'reset_token') THEN
        ALTER TABLE users ADD COLUMN reset_token VARCHAR(255);
    END IF;
    
    -- Добавляем reset_token_expires если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'users' AND column_name = 'reset_token_expires') THEN
        ALTER TABLE users ADD COLUMN reset_token_expires TIMESTAMP;
    END IF;
END $$;

-- ========================================
-- ОБНОВЛЕНИЕ ТАБЛИЦЫ EVENTS
-- ========================================

-- Добавляем новые колонки в таблицу events (если их нет)
DO $$ 
BEGIN
    -- Добавляем uuid если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'uuid') THEN
        ALTER TABLE events ADD COLUMN uuid UUID DEFAULT uuid_generate_v4() UNIQUE;
    END IF;
    
    -- Добавляем short_description если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'short_description') THEN
        ALTER TABLE events ADD COLUMN short_description VARCHAR(500);
    END IF;
    
    -- Добавляем end_date если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'end_date') THEN
        ALTER TABLE events ADD COLUMN end_date DATE;
    END IF;
    
    -- Добавляем end_time если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'end_time') THEN
        ALTER TABLE events ADD COLUMN end_time TIME;
    END IF;
    
    -- Добавляем location_type если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'location_type') THEN
        ALTER TABLE events ADD COLUMN location_type VARCHAR(50) DEFAULT 'offline';
    END IF;
    
    -- Добавляем current_participants если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'current_participants') THEN
        ALTER TABLE events ADD COLUMN current_participants INTEGER DEFAULT 0;
    END IF;
    
    -- Добавляем currency если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'currency') THEN
        ALTER TABLE events ADD COLUMN currency VARCHAR(3) DEFAULT 'USD';
    END IF;
    
    -- Добавляем status если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'status') THEN
        ALTER TABLE events ADD COLUMN status VARCHAR(50) DEFAULT 'draft';
    END IF;
    
    -- Добавляем banner_url если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'banner_url') THEN
        ALTER TABLE events ADD COLUMN banner_url TEXT;
    END IF;
    
    -- Добавляем color_scheme если не существует
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'events' AND column_name = 'color_scheme') THEN
        ALTER TABLE events ADD COLUMN color_scheme VARCHAR(50);
    END IF;
END $$;

-- ========================================
-- СОЗДАНИЕ НОВЫХ ТАБЛИЦ
-- ========================================

-- Создаем таблицу event_categories если не существует
CREATE TABLE IF NOT EXISTS event_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    color VARCHAR(7),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу event_tags если не существует
CREATE TABLE IF NOT EXISTS event_tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу event_tags_relationship если не существует
CREATE TABLE IF NOT EXISTS event_tags_relationship (
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES event_tags(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, tag_id)
);

-- Создаем таблицу promo_codes если не существует
CREATE TABLE IF NOT EXISTS promo_codes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20) DEFAULT 'percentage',
    discount_value DECIMAL(10,2) NOT NULL,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0,
    valid_from TIMESTAMP DEFAULT NOW(),
    valid_until TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу user_sessions если не существует
CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу event_registrations если не существует
CREATE TABLE IF NOT EXISTS event_registrations (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    registration_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'confirmed',
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу event_feedback если не существует
CREATE TABLE IF NOT EXISTS event_feedback (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу file_uploads если не существует
CREATE TABLE IF NOT EXISTS file_uploads (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    url TEXT NOT NULL,
    uploaded_by INTEGER REFERENCES users(id),
    event_id INTEGER REFERENCES events(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Создаем таблицу user_followers если не существует
CREATE TABLE IF NOT EXISTS user_followers (
    id SERIAL PRIMARY KEY,
    follower_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

-- Создаем таблицу user_favorites если не существует
CREATE TABLE IF NOT EXISTS user_favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, event_id)
);

-- Создаем таблицу telegram_sessions если не существует
CREATE TABLE IF NOT EXISTS telegram_sessions (
    id SERIAL PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    user_id INTEGER REFERENCES users(id),
    chat_id BIGINT,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    language_code VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- ========================================
-- ДОБАВЛЕНИЕ ДАННЫХ
-- ========================================

-- Добавляем категории (только если их нет)
INSERT INTO event_categories (name, description, icon, color) VALUES
('Технологии', 'Технологические и инновационные события', 'laptop', '#3B82F6'),
('Бизнес', 'Бизнес и предпринимательство', 'briefcase', '#10B981'),
('Дизайн', 'Дизайн и креативность', 'palette', '#F59E0B'),
('Искусство', 'Искусство и культура', 'brush', '#EF4444'),
('Образование', 'Образовательные события', 'graduation-cap', '#8B5CF6'),
('Спорт', 'Спорт и фитнес', 'trophy', '#06B6D4'),
('Музыка', 'Музыка и развлечения', 'music', '#EC4899'),
('Еда', 'Кулинарные события', 'utensils', '#F97316')
ON CONFLICT (name) DO NOTHING;

-- Добавляем теги (только если их нет)
INSERT INTO event_tags (name) VALUES
('Воркшоп'),
('Конференция'),
('Встреча'),
('Вебинар'),
('Хакатон'),
('Нетворкинг'),
('Тренинг'),
('Выставка'),
('Концерт'),
('Фестиваль')
ON CONFLICT (name) DO NOTHING;

-- ========================================
-- СОЗДАНИЕ ИНДЕКСОВ
-- ========================================

-- Создаем индексы (только если их нет)
DO $$ 
BEGIN
    -- Индексы для events
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_events_date') THEN
        CREATE INDEX idx_events_date ON events(date);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_events_created_by') THEN
        CREATE INDEX idx_events_created_by ON events(created_by);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_events_status') THEN
        CREATE INDEX idx_events_status ON events(status);
    END IF;
    
    -- Индексы для tickets
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tickets_event_id') THEN
        CREATE INDEX idx_tickets_event_id ON tickets(event_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_tickets_user_id') THEN
        CREATE INDEX idx_tickets_user_id ON tickets(user_id);
    END IF;
    
    -- Индексы для users
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_email') THEN
        CREATE INDEX idx_users_email ON users(email);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_telegram_id') THEN
        CREATE INDEX idx_users_telegram_id ON users(telegram_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_reset_token') THEN
        CREATE INDEX idx_users_reset_token ON users(reset_token);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_users_verification_token') THEN
        CREATE INDEX idx_users_verification_token ON users(verification_token);
    END IF;
    
    -- Индексы для social features
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_followers_follower') THEN
        CREATE INDEX idx_user_followers_follower ON user_followers(follower_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_followers_following') THEN
        CREATE INDEX idx_user_followers_following ON user_followers(following_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_favorites_user') THEN
        CREATE INDEX idx_user_favorites_user ON user_favorites(user_id);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_user_favorites_event') THEN
        CREATE INDEX idx_user_favorites_event ON user_favorites(event_id);
    END IF;
END $$;

-- ========================================
-- СОЗДАНИЕ ТРИГГЕРОВ
-- ========================================

-- Создаем функцию обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Создаем триггеры (только если их нет)
DO $$ 
BEGIN
    -- Триггер для users
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_users_updated_at') THEN
        CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    -- Триггер для events
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_events_updated_at') THEN
        CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
    
    -- Триггер для telegram_sessions
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'update_telegram_sessions_updated_at') THEN
        CREATE TRIGGER update_telegram_sessions_updated_at BEFORE UPDATE ON telegram_sessions
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END $$;

-- ========================================
-- ROW LEVEL SECURITY (RLS)
-- ========================================

-- Включаем RLS на всех таблицах
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE tickets ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE file_uploads ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE telegram_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_tags ENABLE ROW LEVEL SECURITY;

-- Создаем политики безопасности (только если их нет)
DO $$ 
BEGIN
    -- Политики для users
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Users can view their own profile') THEN
        CREATE POLICY "Users can view their own profile" ON users
            FOR SELECT USING (auth.uid()::text = uuid::text);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Users can update their own profile') THEN
        CREATE POLICY "Users can update their own profile" ON users
            FOR UPDATE USING (auth.uid()::text = uuid::text);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Allow registration') THEN
        CREATE POLICY "Allow registration" ON users
            FOR INSERT WITH CHECK (true);
    END IF;
    
    -- Политики для events
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Anyone can view published events') THEN
        CREATE POLICY "Anyone can view published events" ON events
            FOR SELECT USING (status = 'published');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Users can view their own events') THEN
        CREATE POLICY "Users can view their own events" ON events
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = events.created_by
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Users can create events') THEN
        CREATE POLICY "Users can create events" ON events
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = events.created_by
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Users can update their own events') THEN
        CREATE POLICY "Users can update their own events" ON events
            FOR UPDATE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = events.created_by
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Users can delete their own events') THEN
        CREATE POLICY "Users can delete their own events" ON events
            FOR DELETE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = events.created_by
            ));
    END IF;
    
    -- Политики для tickets
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'tickets' AND policyname = 'Users can view their own tickets') THEN
        CREATE POLICY "Users can view their own tickets" ON tickets
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = tickets.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'tickets' AND policyname = 'Users can create tickets') THEN
        CREATE POLICY "Users can create tickets" ON tickets
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = tickets.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'tickets' AND policyname = 'Users can update their own tickets') THEN
        CREATE POLICY "Users can update their own tickets" ON tickets
            FOR UPDATE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = tickets.user_id
            ));
    END IF;
    
    -- Политики для user_sessions
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_sessions' AND policyname = 'Users can view their own sessions') THEN
        CREATE POLICY "Users can view their own sessions" ON user_sessions
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_sessions.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_sessions' AND policyname = 'Users can create sessions') THEN
        CREATE POLICY "Users can create sessions" ON user_sessions
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_sessions.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_sessions' AND policyname = 'Users can delete their own sessions') THEN
        CREATE POLICY "Users can delete their own sessions" ON user_sessions
            FOR DELETE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_sessions.user_id
            ));
    END IF;
    
    -- Политики для event_registrations
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_registrations' AND policyname = 'Users can view their own registrations') THEN
        CREATE POLICY "Users can view their own registrations" ON event_registrations
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_registrations.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_registrations' AND policyname = 'Users can create registrations') THEN
        CREATE POLICY "Users can create registrations" ON event_registrations
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_registrations.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_registrations' AND policyname = 'Users can update their own registrations') THEN
        CREATE POLICY "Users can update their own registrations" ON event_registrations
            FOR UPDATE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_registrations.user_id
            ));
    END IF;
    
    -- Политики для event_feedback
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_feedback' AND policyname = 'Anyone can view feedback for published events') THEN
        CREATE POLICY "Anyone can view feedback for published events" ON event_feedback
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM events WHERE id = event_feedback.event_id AND status = 'published'
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_feedback' AND policyname = 'Users can view their own feedback') THEN
        CREATE POLICY "Users can view their own feedback" ON event_feedback
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_feedback.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_feedback' AND policyname = 'Users can create feedback') THEN
        CREATE POLICY "Users can create feedback" ON event_feedback
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_feedback.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_feedback' AND policyname = 'Users can update their own feedback') THEN
        CREATE POLICY "Users can update their own feedback" ON event_feedback
            FOR UPDATE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = event_feedback.user_id
            ));
    END IF;
    
    -- Политики для file_uploads
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'file_uploads' AND policyname = 'Users can view their own uploads') THEN
        CREATE POLICY "Users can view their own uploads" ON file_uploads
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = file_uploads.uploaded_by
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'file_uploads' AND policyname = 'Users can create uploads') THEN
        CREATE POLICY "Users can create uploads" ON file_uploads
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = file_uploads.uploaded_by
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'file_uploads' AND policyname = 'Users can delete their own uploads') THEN
        CREATE POLICY "Users can delete their own uploads" ON file_uploads
            FOR DELETE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = file_uploads.uploaded_by
            ));
    END IF;
    
    -- Политики для user_followers
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_followers' AND policyname = 'Users can view their own followers') THEN
        CREATE POLICY "Users can view their own followers" ON user_followers
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_followers.following_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_followers' AND policyname = 'Users can view who they follow') THEN
        CREATE POLICY "Users can view who they follow" ON user_followers
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_followers.follower_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_followers' AND policyname = 'Users can follow others') THEN
        CREATE POLICY "Users can follow others" ON user_followers
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_followers.follower_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_followers' AND policyname = 'Users can unfollow others') THEN
        CREATE POLICY "Users can unfollow others" ON user_followers
            FOR DELETE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_followers.follower_id
            ));
    END IF;
    
    -- Политики для user_favorites
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_favorites' AND policyname = 'Users can view their own favorites') THEN
        CREATE POLICY "Users can view their own favorites" ON user_favorites
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_favorites.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_favorites' AND policyname = 'Users can add favorites') THEN
        CREATE POLICY "Users can add favorites" ON user_favorites
            FOR INSERT WITH CHECK (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_favorites.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_favorites' AND policyname = 'Users can remove favorites') THEN
        CREATE POLICY "Users can remove favorites" ON user_favorites
            FOR DELETE USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = user_favorites.user_id
            ));
    END IF;
    
    -- Политики для telegram_sessions
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'telegram_sessions' AND policyname = 'Users can view their own telegram sessions') THEN
        CREATE POLICY "Users can view their own telegram sessions" ON telegram_sessions
            FOR SELECT USING (EXISTS (
                SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND users.id = telegram_sessions.user_id
            ));
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'telegram_sessions' AND policyname = 'Allow telegram bot access') THEN
        CREATE POLICY "Allow telegram bot access" ON telegram_sessions
            FOR ALL USING (true);
    END IF;
    
    -- Политики для категорий и тегов
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_categories' AND policyname = 'Anyone can view categories') THEN
        CREATE POLICY "Anyone can view categories" ON event_categories
            FOR SELECT USING (true);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'event_tags' AND policyname = 'Anyone can view tags') THEN
        CREATE POLICY "Anyone can view tags" ON event_tags
            FOR SELECT USING (true);
    END IF;
    
    -- Админские политики
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'users' AND policyname = 'Admins can view all data') THEN
        CREATE POLICY "Admins can view all data" ON users
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND is_admin = true
                )
            );
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'events' AND policyname = 'Admins can view all events') THEN
        CREATE POLICY "Admins can view all events" ON events
            FOR ALL USING (
                EXISTS (
                    SELECT 1 FROM users WHERE users.uuid::text = auth.uid()::text AND is_admin = true
                )
            );
    END IF;
END $$;

-- Обновляем существующих пользователей
UPDATE users SET email_verified = TRUE WHERE email_verified IS NULL;

-- Обновляем существующие события
UPDATE events SET status = 'published' WHERE status IS NULL;

SELECT 'Migration completed successfully!' as status;
