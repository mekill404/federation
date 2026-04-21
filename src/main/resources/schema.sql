-- Create collectivity table
CREATE TABLE IF NOT EXISTS collectivity (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    creation_date DATE NOT NULL,
    federation_approval BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create collectivity_structure table
CREATE TABLE IF NOT EXISTS collectivity_structure (
    id SERIAL PRIMARY KEY,
    collectivity_id VARCHAR(50) NOT NULL,
    president_id VARCHAR(50) NOT NULL,
    vice_president_id VARCHAR(50) NOT NULL,
    treasurer_id VARCHAR(50) NOT NULL,
    secretary_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collectivity_id) REFERENCES collectivity(id) ON DELETE CASCADE,
    UNIQUE(collectivity_id)
);

-- Create member table
CREATE TABLE IF NOT EXISTS member (
    id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    profession VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registration_date DATE NOT NULL,
    collectivity_id VARCHAR(50) NOT NULL,
    registration_fee_paid BOOLEAN DEFAULT FALSE,
    membership_dues_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collectivity_id) REFERENCES collectivity(id) ON DELETE CASCADE
);

-- Create member_referees table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS member_referees (
    id SERIAL PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL,
    referee_id VARCHAR(50) NOT NULL,
    relationship_type VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    FOREIGN KEY (referee_id) REFERENCES member(id) ON DELETE CASCADE,
    UNIQUE(member_id, referee_id)
);

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_member_collectivity ON member(collectivity_id);
CREATE INDEX IF NOT EXISTS idx_member_email ON member(email);
CREATE INDEX IF NOT EXISTS idx_collectivity_structure ON collectivity_structure(collectivity_id);
