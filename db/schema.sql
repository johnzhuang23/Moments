CREATE DATABASE moments_ruby;

\c moments_ruby

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    email TEXT UNIQUE,
    password_digest TEXT,
    user_avatar_url TEXT
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    image_url TEXT,
    content TEXT,
    user_id INTEGER,
    likes_count INTEGER,
    comments_count INTEGER
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    content VARCHAR(255),
    user_id INTEGER,
    post_id INTEGER,
    email TEXT,
    user_name TEXT
);

CREATE TABLE blacklist (
    id SERIAL PRIMARY KEY,
    user_id INTEGER, 
    user_id_blocked INTEGER
);

CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER, 
    email TEXT,
    post_id INTEGER 
);



