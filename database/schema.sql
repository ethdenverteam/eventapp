-- EventApp Database Schema
-- PostgreSQL

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
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

-- Insert default categories
INSERT INTO event_categories (name, description, icon, color) VALUES
('Technology', 'Technology and innovation events', 'laptop', '#3B82F6'),
('Business', 'Business and entrepreneurship events', 'briefcase', '#10B981'),
('Design', 'Design and creativity events', 'palette', '#F59E0B'),
('Art', 'Art and culture events', 'brush', '#EF4444'),
('Education', 'Educational and learning events', 'graduation-cap', '#8B5CF6'),
('Sports', 'Sports and fitness events', 'trophy', '#06B6D4'),
('Music', 'Music and entertainment events', 'music', '#EC4899'),
('Food', 'Food and culinary events', 'utensils', '#F97316');

-- Insert default tags
INSERT INTO event_tags (name) VALUES
('Workshop'),
('Conference'),
('Meetup'),
('Webinar'),
('Hackathon'),
('Networking'),
('Training'),
('Exhibition'),
('Concert'),
('Festival');

-- Create indexes for better performance
CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_created_by ON events(created_by);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_tickets_event_id ON tickets(event_id);
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_events_category ON events(category);

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

-- Insert demo user (password: demo123)
INSERT INTO users (name, email, password_hash, is_verified) VALUES
('Demo User', 'demo@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- Insert demo event
INSERT INTO events (title, description, date, time, location, max_participants, category, created_by) VALUES
('Tech Conference 2024', 'Annual technology conference featuring the latest innovations and industry leaders', '2024-12-15', '10:00:00', 'Tech Center, Main Hall', 100, 'Technology', 1);
