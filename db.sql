-- Création de l'utilisateur avec son mot de passe
CREATE USER agri-db WITH PASSWORD '123456789.0';

-- Optionnel : Lui permettre de créer des bases de données
ALTER USER agri-db CREATEDB;

-- Création de la base de données
CREATE DATABASE agri-data OWNER agri-db;

-- Connexion à la base de données
\c agri-data

-- gestion des privilèges
-- Autoriser la connexion à la base de données
GRANT CONNECT ON DATABASE agri-data TO agri-db;
-- Autoriser l'utilisation du schéma public
GRANT USAGE ON SCHEMA public TO agri-db;
-- Autoriser la création de tables et autres objets dans le schéma public
GRANT CREATE ON SCHEMA public TO agri-db;
-- Accorder tous les privilèges sur les tables existantes
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO agri-db;
-- Accorder tous les privilèges sur toutes les séquences du schéma public pour l'auto incrementation des id
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO agri-db;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO agri-db;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO agri-db