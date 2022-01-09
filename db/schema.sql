CREATE DATABASE dating_app;

\c dating_app;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    email TEXT UNIQUE,
    password_digest TEXT, 
    user_avatar_url TEXT
);
CREATE TABLE moments (
    id SERIAL PRIMARY KEY,
    image_url TEXT, 
    user_text TEXT,
    like_account INTEGER,
    email TEXT
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    content VARCHAR(200)
);

