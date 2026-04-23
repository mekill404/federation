-- ============================================================
-- SUPPRESSION DE L'ANCIENNE BASE (optionnel)
-- ============================================================
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- ============================================================
-- TYPES ENUM (inchangés)
-- ============================================================
CREATE TYPE gender AS ENUM ('MALE', 'FEMALE');
CREATE TYPE member_occupation AS ENUM ('JUNIOR', 'SENIOR', 'SECRETARY', 'TREASURER', 'VICE_PRESIDENT', 'PRESIDENT');
CREATE TYPE frequency AS ENUM ('WEEKLY', 'MONTHLY', 'ANNUALLY', 'PUNCTUALLY');
CREATE TYPE activity_status AS ENUM ('ACTIVE', 'INACTIVE');
CREATE TYPE payment_mode AS ENUM ('CASH', 'MOBILE_BANKING', 'BANK_TRANSFER');
CREATE TYPE mobile_banking_service AS ENUM ('AIRTEL_MONEY', 'MVOLA', 'ORANGE_MONEY');
CREATE TYPE bank_name AS ENUM ('BRED', 'MCB', 'BMOI', 'BOA', 'BGFI', 'AFG', 'ACCES_BANQUE', 'BAOBAB', 'SIPEM');
CREATE TYPE account_type AS ENUM ('CASH', 'MOBILE_MONEY', 'BANK');

-- ============================================================
-- TABLES AVEC ID DE TYPE VARCHAR
-- ============================================================

CREATE TABLE Ville (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE SpecialiteAgricole (
    id VARCHAR(50) PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    libelle VARCHAR(200) NOT NULL
);

CREATE TABLE Federation (
    id VARCHAR(50) PRIMARY KEY,
    nom VARCHAR(200) NOT NULL DEFAULT 'Fédération des Collectivités Agricoles de Madagascar',
    sigle VARCHAR(50),
    date_creation DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE member (
    id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender gender NOT NULL,
    address TEXT NOT NULL,
    profession VARCHAR(200) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    occupation member_occupation NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE collectivity (
    id VARCHAR(50) PRIMARY KEY,
    location VARCHAR(200) NOT NULL,
    federation_approval BOOLEAN DEFAULT FALSE,
    approval_date DATE,
    unique_number VARCHAR(50) UNIQUE,
    unique_name VARCHAR(200) UNIQUE,
    date_creation DATE DEFAULT CURRENT_DATE,
    id_ville VARCHAR(50) REFERENCES Ville(id),
    id_specialite VARCHAR(50) REFERENCES SpecialiteAgricole(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE membership (
    id VARCHAR(50) PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL REFERENCES member(id),
    collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    role_in_collectivity member_occupation NOT NULL,
    joined_at DATE DEFAULT CURRENT_DATE,
    left_at DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(member_id, collectivity_id)
);

CREATE TABLE referees (
    id VARCHAR(50) PRIMARY KEY,
    candidate_id VARCHAR(50) NOT NULL REFERENCES member(id),
    referee_id VARCHAR(50) NOT NULL REFERENCES member(id),
    target_collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    relationship_nature VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(candidate_id, referee_id),
    CHECK (candidate_id <> referee_id)
);

CREATE TABLE collectivity_structure (
    id VARCHAR(50) PRIMARY KEY,
    collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    mandat_year INT NOT NULL,
    president_id VARCHAR(50) NOT NULL REFERENCES member(id),
    vice_president_id VARCHAR(50) NOT NULL REFERENCES member(id),
    treasurer_id VARCHAR(50) NOT NULL REFERENCES member(id),
    secretary_id VARCHAR(50) NOT NULL REFERENCES member(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(collectivity_id, mandat_year)
);

CREATE TABLE financial_account (
    id VARCHAR(50) PRIMARY KEY,
    collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    account_type account_type NOT NULL,
    holder_name VARCHAR(200),
    amount DECIMAL(15,2) DEFAULT 0,
    bank_name bank_name,
    bank_code VARCHAR(5),
    bank_branch_code VARCHAR(5),
    bank_account_number VARCHAR(11),
    bank_account_key VARCHAR(2),
    mobile_banking_service mobile_banking_service,
    mobile_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE membership_fee (
    id VARCHAR(50) PRIMARY KEY,
    collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    label VARCHAR(200) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    frequency frequency NOT NULL,
    eligible_from DATE NOT NULL,
    status activity_status DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payment (
    id VARCHAR(50) PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL REFERENCES member(id),
    membership_fee_id VARCHAR(50) REFERENCES membership_fee(id),
    amount DECIMAL(15,2) NOT NULL,
    payment_mode payment_mode NOT NULL,
    account_credited_id VARCHAR(50) NOT NULL REFERENCES financial_account(id),
    creation_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE collectivity_transaction (
    id VARCHAR(50) PRIMARY KEY,
    collectivity_id VARCHAR(50) NOT NULL REFERENCES collectivity(id),
    member_debited_id VARCHAR(50) NOT NULL REFERENCES member(id),
    amount DECIMAL(15,2) NOT NULL,
    payment_mode payment_mode NOT NULL,
    account_credited_id VARCHAR(50) NOT NULL REFERENCES financial_account(id),
    creation_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- INSERTION DES DONNÉES DE TEST (IDENTIFIANTS DU SUJET)
-- ============================================================

INSERT INTO Ville (id, nom) VALUES ('Ambatondrazaka', 'Ambatondrazaka'), ('Brickaville', 'Brickaville');
INSERT INTO SpecialiteAgricole (id, code, libelle) VALUES ('RIZ', 'RIZ', 'Riziculture'), ('PISC', 'PISC', 'Pisciculture'), ('API', 'API', 'Apiculture');
INSERT INTO Federation (id, nom, sigle) VALUES ('fed-1', 'Fédération Nationale', 'FNM');

INSERT INTO collectivity (id, location, federation_approval, approval_date, unique_number, unique_name, date_creation, id_ville, id_specialite) VALUES
('col-1', 'Ambatondrazaka Centre', true, '2026-01-01', '1', 'Mpanorina', '2026-01-01', 'Ambatondrazaka', 'RIZ'),
('col-2', 'Ambatondrazaka Nord', true, '2026-01-01', '2', 'Dobo voalahany', '2026-01-01', 'Ambatondrazaka', 'PISC'),
('col-3', 'Brickaville', true, '2026-01-01', '3', 'Tantely mamy', '2026-01-01', 'Brickaville', 'API');

-- Membres col-1
INSERT INTO member (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email, occupation, created_at) VALUES
('C1-M1', 'Nom membre 1', 'Prénom membre 1', '1980-02-01', 'MALE', 'Lot II V M Ambato.', 'Riziculteur', '0341234567', 'member.1@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
('C1-M2', 'Nom membre 2', 'Prénom membre 2', '1982-03-05', 'MALE', 'Lot II F Ambato.', 'Agriculteur', '0321234567', 'member.2@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
('C1-M3', 'Nom membre 3', 'Prénom membre 3', '1992-03-10', 'MALE', 'Lot II J Ambato.', 'Collecteur', '0331234567', 'member.3@fed-agrimg', 'SECRETARY', '2024-01-01'),
('C1-M4', 'Nom membre 4', 'Prénom membre 4', '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.', 'Distributeur', '0381234567', 'member.4@fed-agri.mg', 'TREASURER', '2024-01-01'),
('C1-M5', 'Nom membre 5', 'Prénom membre 5', '1999-08-21', 'MALE', 'Lot UV 80 Ambato.', 'Riziculteur', '0373434567', 'member.5@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C1-M6', 'Nom membre 6', 'Prénom membre 6', '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.', 'Riziculteur', '0372234567', 'member.6@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C1-M7', 'Nom membre 7', 'Prénom membre 7', '1998-01-31', 'MALE', 'Lot UV 7 Ambato.', 'Riziculteur', '0374234567', 'member.7@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C1-M8', 'Nom membre 8', 'Prénom membre 8', '1975-08-20', 'MALE', 'Lot UV 8 Ambato.', 'Riziculteur', '0370234567', 'member.8@fed-agri.mg', 'SENIOR', '2024-01-01');

-- Membres col-2 (certains identiques à col-1 dans le sujet, on garde les mêmes IDs avec préfixe différent ou on les duplique ? 
-- Le sujet indique "C2-M1 ou C1-M1" ; pour simplifier, on crée des enregistrements distincts avec IDs C2-M1...)
INSERT INTO member (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email, occupation, created_at) VALUES
('C2-M1', 'Nom membre 1', 'Prénom membre 1', '1980-02-01', 'MALE', 'Lot II V M Ambato.', 'Riziculteur', '0341234567', 'member.1@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C2-M2', 'Nom membre 2', 'Prénom membre 2', '1982-03-05', 'MALE', 'Lot II F Ambato.', 'Agriculteur', '0321234567', 'member.2@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C2-M3', 'Nom membre 3', 'Prénom membre 3', '1992-03-10', 'MALE', 'Lot II J Ambato.', 'Collecteur', '0331234567', 'member.3@fed-agrimg', 'SENIOR', '2024-01-01'),
('C2-M4', 'Nom membre 4', 'Prénom membre 4', '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.', 'Distributeur', '0381234567', 'member.4@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C2-M5', 'Nom membre 5', 'Prénom membre 5', '1999-08-21', 'MALE', 'Lot UV 80 Ambato.', 'Riziculteur', '0373434567', 'member.5@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
('C2-M6', 'Nom membre 6', 'Prénom membre 6', '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.', 'Riziculteur', '0372234567', 'member.6@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
('C2-M7', 'Nom membre 7', 'Prénom membre 7', '1998-01-31', 'MALE', 'Lot UV 7 Ambato.', 'Riziculteur', '0374234567', 'member.7@fed-agri.mg', 'SECRETARY', '2024-01-01'),
('C2-M8', 'Nom membre 8', 'Prénom membre 8', '1975-08-20', 'MALE', 'Lot UV 8 Ambato.', 'Riziculteur', '0370234567', 'member.8@fed-agri.mg', 'TREASURER', '2024-01-01');

-- Membres col-3
INSERT INTO member (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email, occupation, created_at) VALUES
('C3-M1', 'Nom membre 9', 'Prénom membre 9', '1988-01-02', 'MALE', 'Lot 33 J Antsirabe', 'Apiculteur', '034034567', 'member.9@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
('C3-M2', 'Nom membre 10', 'Prénom membre 10', '1982-03-05', 'MALE', 'Lot 2 J Antsirabe', 'Agriculteur', '0338634567', 'member.10@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
('C3-M3', 'Nom membre 11', 'Prénom membre 11', '1992-03-12', 'MALE', 'Lot 8 KM Antsirabe', 'Collecteur', '0338234567', 'member.11@fed-agrimg', 'SECRETARY', '2024-01-01'),
('C3-M4', 'Nom membre 12', 'Prénom membre 12', '1988-05-10', 'FEMALE', 'Lot A K 50 Antsirabe', 'Distributeur', '0382334567', 'member.12@fed-agri.mg', 'TREASURER', '2024-01-01'),
('C3-M5', 'Nom membre 13', 'Prénom membre 13', '1999-08-11', 'MALE', 'Lot UV 80 Antsirabe.', 'Apiculteur', '0373365567', 'member.13@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C3-M6', 'Nom membre 14', 'Prénom membre 14', '1998-08-09', 'FEMALE', 'Lot UV 6 Antsirabe.', 'Apiculteur', '0378234567', 'member.14@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C3-M7', 'Nom membre 15', 'Prénom membre 15', '1998-01-13', 'MALE', 'Lot UV 7 Antsirabe', 'Apiculteur', '0374914567', 'member.15@fed-agri.mg', 'SENIOR', '2024-01-01'),
('C3-M8', 'Nom membre 16', 'Prénom membre 16', '1975-08-02', 'MALE', 'Lot UV 8 Antsirabe', 'Apiculteur', '0370634567', 'member.16@fed-agri.mg', 'SENIOR', '2024-01-01');

-- Adhésions (membership)
INSERT INTO membership (id, member_id, collectivity_id, role_in_collectivity, joined_at) VALUES
-- col-1
('ms11', 'C1-M1', 'col-1', 'PRESIDENT', '2026-01-01'),
('ms12', 'C1-M2', 'col-1', 'VICE_PRESIDENT', '2026-01-01'),
('ms13', 'C1-M3', 'col-1', 'SECRETARY', '2026-01-01'),
('ms14', 'C1-M4', 'col-1', 'TREASURER', '2026-01-01'),
('ms15', 'C1-M5', 'col-1', 'SENIOR', '2026-01-01'),
('ms16', 'C1-M6', 'col-1', 'SENIOR', '2026-01-01'),
('ms17', 'C1-M7', 'col-1', 'SENIOR', '2026-01-01'),
('ms18', 'C1-M8', 'col-1', 'SENIOR', '2026-01-01'),
-- col-2
('ms21', 'C2-M1', 'col-2', 'SENIOR', '2026-01-01'),
('ms22', 'C2-M2', 'col-2', 'SENIOR', '2026-01-01'),
('ms23', 'C2-M3', 'col-2', 'SENIOR', '2026-01-01'),
('ms24', 'C2-M4', 'col-2', 'SENIOR', '2026-01-01'),
('ms25', 'C2-M5', 'col-2', 'PRESIDENT', '2026-01-01'),
('ms26', 'C2-M6', 'col-2', 'VICE_PRESIDENT', '2026-01-01'),
('ms27', 'C2-M7', 'col-2', 'SECRETARY', '2026-01-01'),
('ms28', 'C2-M8', 'col-2', 'TREASURER', '2026-01-01'),
-- col-3
('ms31', 'C3-M1', 'col-3', 'PRESIDENT', '2026-01-01'),
('ms32', 'C3-M2', 'col-3', 'VICE_PRESIDENT', '2026-01-01'),
('ms33', 'C3-M3', 'col-3', 'SECRETARY', '2026-01-01'),
('ms34', 'C3-M4', 'col-3', 'TREASURER', '2026-01-01'),
('ms35', 'C3-M5', 'col-3', 'SENIOR', '2026-01-01'),
('ms36', 'C3-M6', 'col-3', 'SENIOR', '2026-01-01'),
('ms37', 'C3-M7', 'col-3', 'SENIOR', '2026-01-01'),
('ms38', 'C3-M8', 'col-3', 'SENIOR', '2026-01-01');

-- Structures des bureaux
INSERT INTO collectivity_structure (id, collectivity_id, mandat_year, president_id, vice_president_id, treasurer_id, secretary_id, start_date, end_date) VALUES
('struct1', 'col-1', 2026, 'C1-M1', 'C1-M2', 'C1-M4', 'C1-M3', '2026-01-01', '2026-12-31'),
('struct2', 'col-2', 2026, 'C2-M5', 'C2-M6', 'C2-M8', 'C2-M7', '2026-01-01', '2026-12-31'),
('struct3', 'col-3', 2026, 'C3-M1', 'C3-M2', 'C3-M4', 'C3-M3', '2026-01-01', '2026-12-31');

-- Comptes financiers
INSERT INTO financial_account (id, collectivity_id, account_type, holder_name, amount, mobile_banking_service, mobile_number) VALUES
('C1-A-CASH', 'col-1', 'CASH', NULL, 0, NULL, NULL),
('C1-A-MOBILE-1', 'col-1', 'MOBILE_MONEY', 'Mpanorina', 0, 'ORANGE_MONEY', '0370489612'),
('C2-A-CASH', 'col-2', 'CASH', NULL, 0, NULL, NULL),
('C2-A-MOBILE-1', 'col-2', 'MOBILE_MONEY', 'Dobo voalohany', 0, 'ORANGE_MONEY', '0320489612'),
('C3-A-CASH', 'col-3', 'CASH', NULL, 0, NULL, NULL);

-- Cotisations
INSERT INTO membership_fee (id, collectivity_id, label, amount, frequency, eligible_from, status) VALUES
('cot-1', 'col-1', 'Cotisation annuelle', 100000, 'ANNUALLY', '2026-01-01', 'ACTIVE'),
('cot-2', 'col-2', 'Cotisation annuelle', 100000, 'ANNUALLY', '2026-01-01', 'ACTIVE'),
('cot-3', 'col-3', 'Cotisation annuelle', 50000, 'ANNUALLY', '2026-01-01', 'ACTIVE');

-- Paiements col-1
INSERT INTO payment (id, member_id, membership_fee_id, amount, payment_mode, account_credited_id, creation_date) VALUES
('pay1', 'C1-M1', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay2', 'C1-M2', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay3', 'C1-M3', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay4', 'C1-M4', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay5', 'C1-M5', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay6', 'C1-M6', 'cot-1', 100000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay7', 'C1-M7', 'cot-1', 60000, 'CASH', 'C1-A-CASH', '2026-01-01'),
('pay8', 'C1-M8', 'cot-1', 90000, 'CASH', 'C1-A-CASH', '2026-01-01'),
-- col-2
('pay21', 'C2-M1', 'cot-2', 60000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay22', 'C2-M2', 'cot-2', 90000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay23', 'C2-M3', 'cot-2', 100000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay24', 'C2-M4', 'cot-2', 100000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay25', 'C2-M5', 'cot-2', 100000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay26', 'C2-M6', 'cot-2', 100000, 'CASH', 'C2-A-CASH', '2026-01-01'),
('pay27', 'C2-M7', 'cot-2', 40000, 'MOBILE_BANKING', 'C2-A-MOBILE-1', '2026-01-01'),
('pay28', 'C2-M8', 'cot-2', 60000, 'MOBILE_BANKING', 'C2-A-MOBILE-1', '2026-01-01');

-- Transactions (générées automatiquement à partir des paiements)
INSERT INTO collectivity_transaction (id, collectivity_id, member_debited_id, amount, payment_mode, account_credited_id, creation_date)
SELECT
    'trans-' || p.id,
    SUBSTRING(p.id FROM 4 FOR 1) || 'ol-' || SUBSTRING(p.id FROM 5 FOR 1), -- approximation pour obtenir col-1, col-2...
    p.member_id,
    p.amount,
    p.payment_mode,
    p.account_credited_id,
    p.creation_date
FROM payment p;

-- Mise à jour des soldes (montants cumulés)
UPDATE financial_account SET amount = 750000 WHERE id = 'C1-A-CASH';
UPDATE financial_account SET amount = 650000 WHERE id = 'C2-A-CASH';
UPDATE financial_account SET amount = 100000 WHERE id = 'C2-A-MOBILE-1';