import os

class Config:
    ENV = os.getenv("APP_ENV", "development")
    DB_USER = os.getenv("DB_USER", "user")
    DB_PASS = os.getenv("DB_PASS", "password")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", 5432)