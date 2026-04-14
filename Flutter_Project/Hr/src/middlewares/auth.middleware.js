/**
 * Placeholder auth middleware - extend with JWT/session as needed
 */
const authMiddleware = (req, res, next) => {
  // Add token/session validation here
  // const token = req.headers.authorization?.replace('Bearer ', '');
  // if (!token) return res.status(401).json({ message: 'Unauthorized' });
  next();
};

const optionalAuth = (req, res, next) => {
  next();
};

module.exports = {
  authMiddleware,
  optionalAuth,
};
