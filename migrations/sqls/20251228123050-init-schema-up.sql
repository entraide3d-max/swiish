-- Create organisations table
CREATE TABLE IF NOT EXISTS organisations (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  subscription_tier TEXT DEFAULT 'individual',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  organisation_id TEXT,
  role TEXT DEFAULT 'member',
  email_verified INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE SET NULL
);

-- Create organisation_settings table
CREATE TABLE IF NOT EXISTS organisation_settings (
  organisation_id TEXT NOT NULL,
  key TEXT NOT NULL,
  value TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (organisation_id, key),
  FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE
);

-- Create user_settings table
CREATE TABLE IF NOT EXISTS user_settings (
  user_id TEXT NOT NULL,
  key TEXT NOT NULL,
  value TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, key),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create invitations table
CREATE TABLE IF NOT EXISTS invitations (
  id TEXT PRIMARY KEY,
  organisation_id TEXT NOT NULL,
  email TEXT NOT NULL,
  token TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'member',
  invited_by TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  accepted_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE,
  FOREIGN KEY (invited_by) REFERENCES users(id) ON DELETE CASCADE
);

-- Create password_reset_tokens table
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at DATETIME NOT NULL,
  used_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create email_verification_tokens table
CREATE TABLE IF NOT EXISTS email_verification_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token TEXT UNIQUE NOT NULL,
  expires_at DATETIME NOT NULL,
  verified_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create cards table
CREATE TABLE IF NOT EXISTS cards (
  slug TEXT NOT NULL,
  user_id TEXT NOT NULL,
  short_code TEXT NOT NULL,
  data TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (slug, user_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create unique index on cards.short_code
CREATE UNIQUE INDEX IF NOT EXISTS idx_cards_short_code ON cards(short_code);
