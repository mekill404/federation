-- Insert sample data for testing
INSERT INTO collectivity (id, name, location, specialty, creation_date, federation_approval) 
VALUES 
    ('COLL001', 'Collectivité Agricole Antananarivo', 'Antananarivo', 'Riz', '2020-01-15', true),
    ('COLL002', 'Collectivité Agricole Antsirabe', 'Antsirabe', 'Maïs', '2020-06-20', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO member (id, first_name, last_name, birth_date, gender, address, profession, phone_number, email, registration_date, collectivity_id, registration_fee_paid, membership_dues_paid)
VALUES 
    ('M001', 'Jean', 'Dupont', '1980-05-15', 'MALE', '123 Rue de la Paix', 'Agriculteur', '+261341234567', 'jean.dupont@email.com', '2020-01-20', 'COLL001', true, true),
    ('M002', 'Marie', 'Martin', '1985-08-22', 'FEMALE', '456 Avenue de la République', 'Agricultrice', '+261342345678', 'marie.martin@email.com', '2020-02-10', 'COLL001', true, true),
    ('M003', 'Pierre', 'Bernard', '1975-03-10', 'MALE', '789 Rue du Commerce', 'Agriculteur', '+261343456789', 'pierre.bernard@email.com', '2020-03-15', 'COLL001', true, true),
    ('M004', 'Sophie', 'Laurent', '1990-11-05', 'FEMALE', '321 Route de l''Aéroport', 'Agricultrice', '+261344567890', 'sophie.laurent@email.com', '2020-04-01', 'COLL001', true, true),
    ('M005', 'Thomas', 'Lefevre', '1988-07-18', 'MALE', '654 Boulevard Principal', 'Agriculteur', '+261345678901', 'thomas.lefevre@email.com', '2020-05-12', 'COLL001', true, true),
    ('M006', 'Catherine', 'Richard', '1982-12-25', 'FEMALE', '987 Place de la Liberté', 'Agricultrice', '+261346789012', 'catherine.richard@email.com', '2020-06-10', 'COLL002', true, true),
    ('M007', 'Marc', 'Moreau', '1978-09-30', 'MALE', '147 Chemin Rural', 'Agriculteur', '+261347890123', 'marc.moreau@email.com', '2020-07-05', 'COLL002', true, true),
    ('M008', 'Anne', 'Robert', '1992-01-14', 'FEMALE', '258 Rue de l''Église', 'Agricultrice', '+261348901234', 'anne.robert@email.com', '2020-08-22', 'COLL002', true, true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO collectivity_structure (collectivity_id, president_id, vice_president_id, treasurer_id, secretary_id)
VALUES 
    ('COLL001', 'M001', 'M002', 'M003', 'M004'),
    ('COLL002', 'M006', 'M007', 'M008', 'M005')
ON CONFLICT (collectivity_id) DO NOTHING;
