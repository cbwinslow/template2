/**
 * Express.js TypeScript Example Application
 * A modern Node.js web API showcasing best practices
 */

import express, { Request, Response, NextFunction } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import morgan from 'morgan';
import compression from 'compression';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { z } from 'zod';
import winston from 'winston';
import { RateLimiterMemory } from 'rate-limiter-flexible';

// Load environment variables
dotenv.config();

// Logger configuration
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'template2-nodejs-api' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ],
});

// Rate limiting
const rateLimiter = new RateLimiterMemory({
  keyPrefix: 'middleware',
  points: 100, // Number of requests
  duration: 60, // Per 60 seconds
});

// Zod schemas for validation
const UserSchema = z.object({
  id: z.number(),
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().min(1).max(150).optional(),
});

const UserCreateSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  age: z.number().min(1).max(150).optional(),
});

const AuthSchema = z.object({
  username: z.string().min(3).max(50),
  password: z.string().min(6).max(100),
});

// Types
type User = z.infer<typeof UserSchema>;
type UserCreate = z.infer<typeof UserCreateSchema>;
type AuthRequest = z.infer<typeof AuthSchema>;

interface AuthenticatedRequest extends Request {
  user?: { id: number; username: string };
}

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(morgan('combined', { stream: { write: (message) => logger.info(message.trim()) } }));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rate limiting middleware
const rateLimitMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await rateLimiter.consume(req.ip);
    next();
  } catch (rejRes) {
    res.status(429).json({ error: 'Rate limit exceeded' });
  }
};

app.use(rateLimitMiddleware);

// Authentication middleware
const authenticateToken = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, JWT_SECRET, (err: any, user: any) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// In-memory storage (replace with database in production)
let users: User[] = [
  { id: 1, name: 'Alice Johnson', email: 'alice@example.com', age: 30 },
  { id: 2, name: 'Bob Smith', email: 'bob@example.com', age: 25 },
];

// Mock user database for authentication
const authUsers = [
  { id: 1, username: 'admin', password: '$2a$10$8K1p/a0dURXAU7aHSzU.9OA2w2O3BqASDNr6vW5Ag6dHklhGIh6Ve' }, // password: admin123
];

// Routes
app.get('/', (req: Request, res: Response) => {
  logger.info('Root endpoint accessed');
  res.json({
    message: 'Welcome to Template2 Node.js Example API',
    docs: '/api-docs',
    health: '/health',
    version: '1.0.0'
  });
});

app.get('/health', (req: Request, res: Response) => {
  logger.info('Health check accessed');
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

// Authentication endpoints
app.post('/auth/login', async (req: Request, res: Response) => {
  try {
    const { username, password } = AuthSchema.parse(req.body);
    
    const user = authUsers.find(u => u.username === username);
    if (!user || !await bcrypt.compare(password, user.password)) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    logger.info(`User ${username} logged in successfully`);
    res.json({ token, user: { id: user.id, username: user.username } });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: error.errors });
    }
    logger.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User management endpoints
app.get('/users', (req: Request, res: Response) => {
  logger.info('Fetching all users');
  res.json(users);
});

app.get('/users/:id', (req: Request, res: Response) => {
  const id = parseInt(req.params.id);
  const user = users.find(u => u.id === id);
  
  if (!user) {
    logger.warn(`User with ID ${id} not found`);
    return res.status(404).json({ error: 'User not found' });
  }
  
  logger.info(`Fetching user with ID: ${id}`);
  res.json(user);
});

app.post('/users', (req: Request, res: Response) => {
  try {
    const userData = UserCreateSchema.parse(req.body);
    const newId = Math.max(...users.map(u => u.id)) + 1;
    const newUser: User = { id: newId, ...userData };
    
    users.push(newUser);
    logger.info(`Created new user: ${newUser.name}`);
    res.status(201).json(newUser);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: error.errors });
    }
    logger.error('Create user error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/users/:id', (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id);
    const userData = UserCreateSchema.parse(req.body);
    const userIndex = users.findIndex(u => u.id === id);
    
    if (userIndex === -1) {
      logger.warn(`User with ID ${id} not found for update`);
      return res.status(404).json({ error: 'User not found' });
    }
    
    const updatedUser: User = { id, ...userData };
    users[userIndex] = updatedUser;
    logger.info(`Updated user with ID: ${id}`);
    res.json(updatedUser);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: error.errors });
    }
    logger.error('Update user error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/users/:id', (req: Request, res: Response) => {
  const id = parseInt(req.params.id);
  const userIndex = users.findIndex(u => u.id === id);
  
  if (userIndex === -1) {
    logger.warn(`User with ID ${id} not found for deletion`);
    return res.status(404).json({ error: 'User not found' });
  }
  
  users.splice(userIndex, 1);
  logger.info(`Deleted user with ID: ${id}`);
  res.status(204).send();
});

// Protected route
app.get('/protected', authenticateToken, (req: AuthenticatedRequest, res: Response) => {
  logger.info(`Protected route accessed by user: ${req.user?.username}`);
  res.json({
    message: `Hello ${req.user?.username}, this is a protected route!`,
    user: req.user
  });
});

// Error handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  logger.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use('*', (req: Request, res: Response) => {
  logger.warn(`404 - Route not found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({ error: 'Route not found' });
});

// Start server
const server = app.listen(PORT, () => {
  logger.info(`🚀 Server running on port ${PORT}`);
  logger.info(`📚 Environment: ${process.env.NODE_ENV || 'development'}`);
  logger.info(`🏥 Health check: http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down gracefully');
  server.close(() => {
    logger.info('Process terminated');
    process.exit(0);
  });
});

export default app;