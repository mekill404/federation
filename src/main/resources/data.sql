-- =====================================================
-- SCRIPT DE CRÉATION DE BASE DE DONNÉES (PostgreSQL)
-- Aligné sur la spécification OpenAPI v0.0.1
-- Agricultural Federation API
-- =====================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. TYPES ENUM (selon la spécification)
-- =====================================================

DROP TYPE IF EXISTS gender CASCADE;
CREATE TYPE gender AS ENUM ('MALE', 'FEMALE');

DROP TYPE IF EXISTS member_occupation CASCADE;
CREATE TYPE member_occupation AS ENUM (
    'JUNIOR',
    'SENIOR',
    'SECRETARY',
    'TREASURER',
    'VICE_PRESIDENT',
    'PRESIDENT'
);

-- =====================================================
-- 2. TABLE MEMBRE
-- =====================================================

CREATE TABLE member (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- MemberInformation (spec)
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender gender NOT NULL,
    address TEXT NOT NULL,
    profession VARCHAR(200) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,  -- spec dit int mais préférer string pour flexibilité
    email VARCHAR(255) NOT NULL UNIQUE,
    occupation member_occupation NOT NULL,
    
    -- Métadonnées
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index
CREATE INDEX idx_member_name ON member(last_name, first_name);
CREATE INDEX idx_member_email ON member(email);

-- =====================================================
-- 3. TABLE COLLECTIVITÉ
-- =====================================================

CREATE TABLE collectivity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- CreateCollectivity fields
    location VARCHAR(200) NOT NULL,
    federation_approval BOOLEAN NOT NULL DEFAULT FALSE,
    approval_date DATE,
    approval_reference VARCHAR(100),
    
    -- Métadonnées
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. STRUCTURE DE LA COLLECTIVITÉ (bureau)
-- =====================================================

CREATE TABLE collectivity_structure (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collectivity_id UUID NOT NULL REFERENCES collectivity(id) ON DELETE CASCADE,
    mandat_year INT NOT NULL,  -- année du mandat
    
    president_id UUID NOT NULL REFERENCES member(id),
    vice_president_id UUID NOT NULL REFERENCES member(id),
    treasurer_id UUID NOT NULL REFERENCES member(id),
    secretary_id UUID NOT NULL REFERENCES member(id),
    
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_collectivity_mandat UNIQUE(collectivity_id, mandat_year),
    CONSTRAINT check_dates CHECK (end_date > start_date)
);

-- =====================================================
-- 5. ADHÉSION D'UN MEMBRE À UNE COLLECTIVITÉ
-- =====================================================

CREATE TABLE membership (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES member(id),
    collectivity_id UUID NOT NULL REFERENCES collectivity(id),
    
    -- rôle dans cette collectivité (peut différer de l'occupation générale)
    role_in_collectivity member_occupation NOT NULL,
    
    joined_at DATE NOT NULL DEFAULT CURRENT_DATE,
    left_at DATE,
    is_active BOOLEAN DEFAULT TRUE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_active_membership UNIQUE(member_id, collectivity_id)
);

-- =====================================================
-- 6. PARRAINAGE (Referees)
-- =====================================================

CREATE TABLE referees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    candidate_id UUID NOT NULL REFERENCES member(id),
    referee_id UUID NOT NULL REFERENCES member(id),
    target_collectivity_id UUID NOT NULL REFERENCES collectivity(id),
    
    relationship_nature VARCHAR(50),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_referee_per_candidate UNIQUE(candidate_id, referee_id),
    CONSTRAINT cannot_referee_self CHECK (candidate_id != referee_id)
);

-- =====================================================
-- 7. PAIEMENTS (pour validation registrationFeePaid / membershipDuesPaid)
-- =====================================================

CREATE TYPE payment_status AS ENUM ('PENDING', 'PAID', 'FAILED');
CREATE TYPE payment_type AS ENUM ('REGISTRATION_FEE', 'MEMBERSHIP_DUES');

CREATE TABLE payment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES member(id),
    collectivity_id UUID NOT NULL REFERENCES collectivity(id),
    
    payment_type payment_type NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    transaction_reference VARCHAR(100),
    
    status payment_status DEFAULT 'PENDING',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contrainte : un membre ne peut payer les frais d'adhésion qu'une fois par collectivité
CREATE UNIQUE INDEX unique_registration_fee_per_member_collectivity 
ON payment(member_id, collectivity_id) 
WHERE payment_type = 'REGISTRATION_FEE';

-- =====================================================
-- 8. VUES UTILES POUR L'API
-- =====================================================

-- Vue pour obtenir un membre complet avec ses parrains
CREATE VIEW member_with_referees AS
SELECT 
    m.id,
    m.first_name,
    m.last_name,
    m.birth_date,
    m.gender,
    m.address,
    m.profession,
    m.phone_number,
    m.email,
    m.occupation,
    json_agg(
        json_build_object(
            'id', r.referee_id,
            'first_name', rm.first_name,
            'last_name', rm.last_name
        )
    ) FILTER (WHERE r.referee_id IS NOT NULL) AS referees
FROM member m
LEFT JOIN referees r ON m.id = r.candidate_id
LEFT JOIN member rm ON r.referee_id = rm.id
GROUP BY m.id;

-- =====================================================
-- 9. FONCTIONS DE VALIDATION (règles métier B-2)
-- =====================================================

-- Vérifier que le candidat a au moins 2 parrains et que la majorité est de la collectivité cible
CREATE OR REPLACE FUNCTION check_referee_rule(
    p_candidate_id UUID,
    p_target_collectivity_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
    total_referees INT;
    internal_referees INT;
BEGIN
    SELECT COUNT(*) INTO total_referees
    FROM referees
    WHERE candidate_id = p_candidate_id;
    
    IF total_referees < 2 THEN
        RETURN FALSE;
    END IF;
    
    SELECT COUNT(*) INTO internal_referees
    FROM referees r
    JOIN membership m ON r.referee_id = m.member_id
    WHERE r.candidate_id = p_candidate_id
      AND m.collectivity_id = p_target_collectivity_id
      AND m.is_active = TRUE;
    
    RETURN internal_referees >= (total_referees - internal_referees);
END;

-- =====================================================
-- 10. TRIGGERS
-- =====================================================

-- Mise à jour automatique de updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;

CREATE TRIGGER trg_member_updated_at
    BEFORE UPDATE ON member
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_collectivity_updated_at
    BEFORE UPDATE ON collectivity
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_membership_updated_at
    BEFORE UPDATE ON membership
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 11. DONNÉES DE TEST (optionnel)
-- =====================================================

-- Quelques membres pour tests
INSERT INTO member (first_name, last_name, birth_date, gender, address, profession, phone_number, email, occupation)
VALUES
('Jean', 'Rakoto', '1980-05-15', 'MALE', 'Lot 123 Ankadifotsy', 'Agriculteur', '0341234567', 'jean.rakoto@email.mg', 'SENIOR'),
('Marie', 'Rabe', '1985-08-22', 'FEMALE', 'Lot 456 Ambohimanarina', 'Éleveuse', '0339876543', 'marie.rabe@email.mg', 'SENIOR'),
('Paul', 'Razafy', '1975-03-10', 'MALE', 'Lot 789 Andravoahangy', 'Exportateur', '0324567890', 'paul.razafy@email.mg', 'PRESIDENT'),
('Claire', 'Rasoanaivo', '1990-11-05', 'FEMALE', 'Lot 321 Ivandry', 'Technicien agricole', '0345678901', 'claire.rasoanaivo@email.mg', 'JUNIOR'),
('Michel', 'Randria', '1982-07-30', 'MALE', 'Lot 654 Analamahitsy', 'Vétérinaire', '0336789012', 'michel.randria@email.mg', 'TREASURER');

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================