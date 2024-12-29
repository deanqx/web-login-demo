CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sessions (
    id SERIAL PRIMARY KEY,
    session_key VARCHAR(44) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    owner SERIAL REFERENCES users(id) ON DELETE CASCADE
);
