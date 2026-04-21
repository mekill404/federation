-- 1. Table des membres
CREATE TABLE IF NOT EXISTS members (
    id VARCHAR(50) PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    status VARCHAR(50), -- Pour stocker l'Enum (JUNIOR, SENIOR, etc.)
    registration_fee_paid BOOLEAN DEFAULT FALSE,
    membership_dues_paid BOOLEAN DEFAULT FALSE
);

-- 2. Table de jointure pour le parrainage (Réflexivité B-2)
CREATE TABLE IF NOT EXISTS parrainages (
    filleul_id VARCHAR(50) REFERENCES members(id),
    parrain_id VARCHAR(50) REFERENCES members(id),
    PRIMARY KEY (filleul_id, parrain_id)
);

-- 3. Table des collectivités (Sujet A)
CREATE TABLE IF NOT EXISTS collectivities (
    id VARCHAR(50) PRIMARY KEY,
    unique_number VARCHAR(50) UNIQUE,
    unique_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    creation_date DATE,
    federation_approval BOOLEAN DEFAULT FALSE,
    president_id VARCHAR(50) REFERENCES members(id),
    vice_president_id VARCHAR(50) REFERENCES members(id),
    secretary_id VARCHAR(50) REFERENCES members(id),
    treasurer_id VARCHAR(50) REFERENCES members(id)
);

-- Insertion de deux membres qui serviront de parrains
INSERT INTO members (id, last_name, first_name, email, status, registration_fee_paid, membership_dues_paid)
VALUES 
('M-REF-01', 'RAKOTO', 'Jean', 'jean@email.com', 'SENIOR', true, true),
('M-REF-02', 'RABARY', 'Mamy', 'mamy@email.com', 'SENIOR', true, true);


-- Voir qui est parrainé par qui (Jointure réflexive)
SELECT 
    f.first_name AS Filleul, 
    p.first_name AS Parrain
FROM parrainages JOIN members f ON f.id = filleul_id
JOIN members p ON p.id = parrain_id;

-- Voir la collectivité avec les noms de son bureau
SELECT 
    c.unique_name AS Collectivite,
    m.last_name AS Nom_President,
    s.last_name AS Nom_Secretaire
FROM collectivities c
JOIN members m ON c.president_id = m.id
JOIN members s ON c.secretary_id = s.id;