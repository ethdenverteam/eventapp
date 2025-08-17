const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Middleware для проверки JWT токена
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// Middleware для проверки роли администратора
const requireAdmin = (req, res, next) => {
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Admin access required' });
  }
  next();
};

// Middleware для проверки владельца ресурса
const requireOwnership = (resourceType) => {
  return async (req, res, next) => {
    try {
      const { Pool } = require('pg');
      const pool = new Pool({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
      });

      let query;
      let params;

      switch (resourceType) {
        case 'event':
          query = 'SELECT created_by FROM events WHERE id = $1';
          params = [req.params.id];
          break;
        case 'user':
          query = 'SELECT id FROM users WHERE id = $1';
          params = [req.params.id];
          break;
        default:
          return res.status(400).json({ error: 'Invalid resource type' });
      }

      const result = await pool.query(query, params);
      
      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Resource not found' });
      }

      const resource = result.rows[0];
      
      if (resourceType === 'event' && resource.created_by !== req.user.userId) {
        return res.status(403).json({ error: 'Not authorized to modify this resource' });
      }

      if (resourceType === 'user' && resource.id !== req.user.userId) {
        return res.status(403).json({ error: 'Not authorized to modify this resource' });
      }

      next();
    } catch (error) {
      console.error('Ownership check error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
};

module.exports = {
  authenticateToken,
  requireAdmin,
  requireOwnership
};
