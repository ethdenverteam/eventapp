-- EventApp Database Schema (Updated)
-- PostgreSQL

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (Updated)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    avatar_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_token VARCHAR(255),
    reset_token_expires TIMESTAMP,
    telegram_id BIGINT UNIQUE,
    telegram_username VARCHAR(255),
    telegram_connected BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Events table
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    date DATE NOT NULL,
    time TIME NOT NULL,
    end_date DATE,
    end_time TIME,
    location VARCHAR(255),
    location_type VARCHAR(50) DEFAULT 'offline', -- offline, online, hybrid
    max_participants INTEGER,
    current_participants INTEGER DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    category VARCHAR(100),
    format VARCHAR(50) DEFAULT 'offline', -- offline, online, hybrid
    status VARCHAR(50) DEFAULT 'draft', -- draft, published, cancelled, completed
    banner_url TEXT,
    color_scheme VARCHAR(50),
    created_by INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tickets table
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    uuid UUID DEFAULT uuid_generate_v4() UNIQUE,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    ticket_type VARCHAR(50) DEFAULT 'regular', -- regular, vip, early_bird
    price DECIMAL(10,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(50) DEFAULT 'active', -- active, cancelled, used, expired
    qr_code TEXT,
    purchase_date TIMESTAMP DEFAULT NOW(),
    used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Event categories table
CREATE TABLE event_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    color VARCHAR(7),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Event tags table
CREATE TABLE event_tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Event-tag relationships
CREATE TABLE event_tags_relationship (
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES event_tags(id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, tag_id)
);

-- Promo codes table
CREATE TABLE promo_codes (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20) DEFAULT 'percentage', -- percentage, fixed_amount
    discount_value DECIMAL(10,2) NOT NULL,
    max_uses INTEGER,
    current_uses INTEGER DEFAULT 0,
    valid_from TIMESTAMP DEFAULT NOW(),
    valid_until TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- User sessions table
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Event registrations table
CREATE TABLE event_registrations (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    registration_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'confirmed', -- confirmed, pending, cancelled
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Event feedback table
CREATE TABLE event_feedback (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- File uploads table
CREATE TABLE file_uploads (
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

-- User followers table (подписки на пользователей)
CREATE TABLE user_followers (
    id SERIAL PRIMARY KEY,
    follower_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

-- User favorites table (избранные события)
CREATE TABLE user_favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, event_id)
);

-- Telegram bot sessions table
CREATE TABLE telegram_sessions (
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

-- Insert default categories
INSERT INTO event_categories (name, description, icon, color) VALUES
('Технологии', 'Технологические и инновационные события', 'laptop', '#3B82F6'),
('Бизнес', 'Бизнес и предпринимательство', 'briefcase', '#10B981'),
('Дизайн', 'Дизайн и креативность', 'palette', '#F59E0B'),
('Искусство', 'Искусство и культура', 'brush', '#EF4444'),
('Образование', 'Образовательные события', 'graduation-cap', '#8B5CF6'),
('Спорт', 'Спорт и фитнес', 'trophy', '#06B6D4'),
('Музыка', 'Музыка и развлечения', 'music', '#EC4899'),
('Еда', 'Кулинарные события', 'utensils', '#F97316');

-- Insert default tags
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
('Фестиваль');

-- Create indexes for better performance
CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_created_by ON events(created_by);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_tickets_event_id ON tickets(event_id);
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_users_reset_token ON users(reset_token);
CREATE INDEX idx_users_verification_token ON users(verification_token);
CREATE INDEX idx_users_telegram_id ON users(telegram_id);
CREATE INDEX idx_user_followers_follower ON user_followers(follower_id);
CREATE INDEX idx_user_followers_following ON user_followers(following_id);
CREATE INDEX idx_user_favorites_user ON user_favorites(user_id);
CREATE INDEX idx_user_favorites_event ON user_favorites(event_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_telegram_sessions_updated_at BEFORE UPDATE ON telegram_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert demo user (password: demo123)
INSERT INTO users (name, email, password_hash, is_verified, email_verified) VALUES
('Демо Пользователь', 'demo@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE, TRUE);

-- Insert demo event
INSERT INTO events (title, description, date, time, location, max_participants, category, created_by) VALUES
('Технологическая конференция 2024', 'Ежегодная технологическая конференция с последними инновациями и лидерами отрасли', '2024-12-15', '10:00:00', 'Тех Центр, Главный зал', 100, 'Технологии', 1);

-- ========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================

-- Enable RLS on all tables
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

-- Users table policies
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow registration" ON users
    FOR INSERT WITH CHECK (true);

-- Events table policies
CREATE POLICY "Anyone can view published events" ON events
    FOR SELECT USING (status = 'published');

CREATE POLICY "Users can view their own events" ON events
    FOR SELECT USING (auth.uid() = created_by);

CREATE POLICY "Users can create events" ON events
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update their own events" ON events
    FOR UPDATE USING (auth.uid() = created_by);

CREATE POLICY "Users can delete their own events" ON events
    FOR DELETE USING (auth.uid() = created_by);

-- Tickets table policies
CREATE POLICY "Users can view their own tickets" ON tickets
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create tickets" ON tickets
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tickets" ON tickets
    FOR UPDATE USING (auth.uid() = user_id);

-- User sessions table policies
CREATE POLICY "Users can view their own sessions" ON user_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create sessions" ON user_sessions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own sessions" ON user_sessions
    FOR DELETE USING (auth.uid() = user_id);

-- Event registrations table policies
CREATE POLICY "Users can view their own registrations" ON event_registrations
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create registrations" ON event_registrations
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own registrations" ON event_registrations
    FOR UPDATE USING (auth.uid() = user_id);

-- Event feedback table policies
CREATE POLICY "Anyone can view feedback for published events" ON event_feedback
    FOR SELECT USING (EXISTS (
        SELECT 1 FROM events WHERE id = event_feedback.event_id AND status = 'published'
    ));

CREATE POLICY "Users can view their own feedback" ON event_feedback
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create feedback" ON event_feedback
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own feedback" ON event_feedback
    FOR UPDATE USING (auth.uid() = user_id);

-- File uploads table policies
CREATE POLICY "Users can view their own uploads" ON file_uploads
    FOR SELECT USING (auth.uid() = uploaded_by);

CREATE POLICY "Users can create uploads" ON file_uploads
    FOR INSERT WITH CHECK (auth.uid() = uploaded_by);

CREATE POLICY "Users can delete their own uploads" ON file_uploads
    FOR DELETE USING (auth.uid() = uploaded_by);

-- User followers table policies
CREATE POLICY "Users can view their own followers" ON user_followers
    FOR SELECT USING (auth.uid() = following_id);

CREATE POLICY "Users can view who they follow" ON user_followers
    FOR SELECT USING (auth.uid() = follower_id);

CREATE POLICY "Users can follow others" ON user_followers
    FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can unfollow others" ON user_followers
    FOR DELETE USING (auth.uid() = follower_id);

-- User favorites table policies
CREATE POLICY "Users can view their own favorites" ON user_favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add favorites" ON user_favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove favorites" ON user_favorites
    FOR DELETE USING (auth.uid() = user_id);

-- Telegram sessions table policies
CREATE POLICY "Users can view their own telegram sessions" ON telegram_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow telegram bot access" ON telegram_sessions
    FOR ALL USING (true);

-- Public read access for categories and tags
ALTER TABLE event_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view categories" ON event_categories
    FOR SELECT USING (true);

CREATE POLICY "Anyone can view tags" ON event_tags
    FOR SELECT USING (true);

-- Admin policies (for future use)
CREATE POLICY "Admins can view all data" ON users
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true
        )
    );

CREATE POLICY "Admins can view all events" ON events
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users WHERE id = auth.uid() AND is_admin = true
        )
    );
