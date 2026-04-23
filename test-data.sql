-- ============================================================
-- INSERTION DES DONNÉES DE TEST OFFICIELLES AVEC UUID VALIDES
-- ============================================================

-- 1. Nettoyage des tables (optionnel, à exécuter avec prudence)
-- TRUNCATE TABLE "collectivity_transaction", "payment", "membership_fee", "financial_account", "referees", "collectivity_structure", "membership", "member", "collectivity", "Federation", "SpecialiteAgricole", "Ville" CASCADE;

-- 2. Villes et spécialités
INSERT INTO "Ville" ("id", "nom") VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Ambatondrazaka'),
  ('22222222-2222-2222-2222-222222222222', 'Brickaville')
ON CONFLICT ("nom") DO NOTHING;

INSERT INTO "SpecialiteAgricole" ("id", "code", "libelle") VALUES 
  ('11111111-1111-1111-1111-111111111111', 'RIZ', 'Riziculture'),
  ('22222222-2222-2222-2222-222222222222', 'PISC', 'Pisciculture'),
  ('33333333-3333-3333-3333-333333333333', 'API', 'Apiculture')
ON CONFLICT ("code") DO NOTHING;

-- 3. Fédération
INSERT INTO "Federation" ("id", "nom", "sigle")
VALUES ('00000000-0000-0000-0000-000000000001', 'Fédération Nationale', 'FNM')
ON CONFLICT DO NOTHING;

-- 4. Collectivités (UUID fixes mais valides)
INSERT INTO "collectivity" ("id", "location", "federation_approval", "approval_date", "unique_number", "unique_name", "date_creation", "id_ville", "id_specialite")
VALUES 
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Ambatondrazaka Centre', true, '2026-01-01', '1', 'Mpanorina', '2026-01-01', '11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Ambatondrazaka Nord', true, '2026-01-01', '2', 'Dobo voalahany', '2026-01-01', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 'Brickaville', true, '2026-01-01', '3', 'Tantely mamy', '2026-01-01', '22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333');

-- 5. Membres avec UUID valides
-- Les membres de col-1 (C1-M1 à C1-M8)
INSERT INTO "member" ("id", "first_name", "last_name", "birth_date", "gender", "address", "profession", "phone_number", "email", "occupation", "created_at")
VALUES
  ('c1a11111-1111-1111-1111-111111111111', 'Nom membre 1', 'Prénom membre 1', '1980-02-01', 'MALE', 'Lot II V M Ambato.', 'Riziculteur', '0341234567', 'member.1@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
  ('c1b22222-2222-2222-2222-222222222222', 'Nom membre 2', 'Prénom membre 2', '1982-03-05', 'MALE', 'Lot II F Ambato.', 'Agriculteur', '0321234567', 'member.2@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
  ('c1c33333-3333-3333-3333-333333333333', 'Nom membre 3', 'Prénom membre 3', '1992-03-10', 'MALE', 'Lot II J Ambato.', 'Collecteur', '0331234567', 'member.3@fed-agrimg', 'SECRETARY', '2024-01-01'),
  ('c1d44444-4444-4444-4444-444444444444', 'Nom membre 4', 'Prénom membre 4', '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.', 'Distributeur', '0381234567', 'member.4@fed-agri.mg', 'TREASURER', '2024-01-01'),
  ('c1e55555-5555-5555-5555-555555555555', 'Nom membre 5', 'Prénom membre 5', '1999-08-21', 'MALE', 'Lot UV 80 Ambato.', 'Riziculteur', '0373434567', 'member.5@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c1f66666-6666-6666-6666-666666666666', 'Nom membre 6', 'Prénom membre 6', '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.', 'Riziculteur', '0372234567', 'member.6@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c1e77777-7777-7777-7777-777777777777', 'Nom membre 7', 'Prénom membre 7', '1998-01-31', 'MALE', 'Lot UV 7 Ambato.', 'Riziculteur', '0374234567', 'member.7@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c1f88888-8888-8888-8888-888888888888', 'Nom membre 8', 'Prénom membre 8', '1975-08-20', 'MALE', 'Lot UV 8 Ambato.', 'Riziculteur', '0370234567', 'member.8@fed-agri.mg', 'SENIOR', '2024-01-01');

-- Membres de col-2
INSERT INTO "member" ("id", "first_name", "last_name", "birth_date", "gender", "address", "profession", "phone_number", "email", "occupation", "created_at")
VALUES
  ('c2a11111-1111-1111-1111-111111111111', 'Nom membre 1', 'Prénom membre 1', '1980-02-01', 'MALE', 'Lot II V M Ambato.', 'Riziculteur', '0341234567', 'member.1@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c2b22222-2222-2222-2222-222222222222', 'Nom membre 2', 'Prénom membre 2', '1982-03-05', 'MALE', 'Lot II F Ambato.', 'Agriculteur', '0321234567', 'member.2@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c2c33333-3333-3333-3333-333333333333', 'Nom membre 3', 'Prénom membre 3', '1992-03-10', 'MALE', 'Lot II J Ambato.', 'Collecteur', '0331234567', 'member.3@fed-agrimg', 'SENIOR', '2024-01-01'),
  ('c2d44444-4444-4444-4444-444444444444', 'Nom membre 4', 'Prénom membre 4', '1988-05-22', 'FEMALE', 'Lot A K 50 Ambato.', 'Distributeur', '0381234567', 'member.4@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c2e55555-5555-5555-5555-555555555555', 'Nom membre 5', 'Prénom membre 5', '1999-08-21', 'MALE', 'Lot UV 80 Ambato.', 'Riziculteur', '0373434567', 'member.5@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
  ('c2f66666-6666-6666-6666-666666666666', 'Nom membre 6', 'Prénom membre 6', '1998-08-22', 'FEMALE', 'Lot UV 6 Ambato.', 'Riziculteur', '0372234567', 'member.6@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
  ('c2e77777-7777-7777-7777-777777777777', 'Nom membre 7', 'Prénom membre 7', '1998-01-31', 'MALE', 'Lot UV 7 Ambato.', 'Riziculteur', '0374234567', 'member.7@fed-agri.mg', 'SECRETARY', '2024-01-01'),
  ('c2f88888-8888-8888-8888-888888888888', 'Nom membre 8', 'Prénom membre 8', '1975-08-20', 'MALE', 'Lot UV 8 Ambato.', 'Riziculteur', '0370234567', 'member.8@fed-agri.mg', 'TREASURER', '2024-01-01');

-- Membres de col-3
INSERT INTO "member" ("id", "first_name", "last_name", "birth_date", "gender", "address", "profession", "phone_number", "email", "occupation", "created_at")
VALUES
  ('c3a11111-1111-1111-1111-111111111111', 'Nom membre 9', 'Prénom membre 9', '1988-01-02', 'MALE', 'Lot 33 J Antsirabe', 'Apiculteur', '034034567', 'member.9@fed-agri.mg', 'PRESIDENT', '2024-01-01'),
  ('c3b22222-2222-2222-2222-222222222222', 'Nom membre 10', 'Prénom membre 10', '1982-03-05', 'MALE', 'Lot 2 J Antsirabe', 'Agriculteur', '0338634567', 'member.10@fed-agri.mg', 'VICE_PRESIDENT', '2024-01-01'),
  ('c3c33333-3333-3333-3333-333333333333', 'Nom membre 11', 'Prénom membre 11', '1992-03-12', 'MALE', 'Lot 8 KM Antsirabe', 'Collecteur', '0338234567', 'member.11@fed-agrimg', 'SECRETARY', '2024-01-01'),
  ('c3d44444-4444-4444-4444-444444444444', 'Nom membre 12', 'Prénom membre 12', '1988-05-10', 'FEMALE', 'Lot A K 50 Antsirabe', 'Distributeur', '0382334567', 'member.12@fed-agri.mg', 'TREASURER', '2024-01-01'),
  ('c3e55555-5555-5555-5555-555555555555', 'Nom membre 13', 'Prénom membre 13', '1999-08-11', 'MALE', 'Lot UV 80 Antsirabe.', 'Apiculteur', '0373365567', 'member.13@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c3f66666-6666-6666-6666-666666666666', 'Nom membre 14', 'Prénom membre 14', '1998-08-09', 'FEMALE', 'Lot UV 6 Antsirabe.', 'Apiculteur', '0378234567', 'member.14@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c3e77777-7777-7777-7777-777777777777', 'Nom membre 15', 'Prénom membre 15', '1998-01-13', 'MALE', 'Lot UV 7 Antsirabe', 'Apiculteur', '0374914567', 'member.15@fed-agri.mg', 'SENIOR', '2024-01-01'),
  ('c3f88888-8888-8888-8888-888888888888', 'Nom membre 16', 'Prénom membre 16', '1975-08-02', 'MALE', 'Lot UV 8 Antsirabe', 'Apiculteur', '0370634567', 'member.16@fed-agri.mg', 'SENIOR', '2024-01-01');

-- 6. Adhésions des membres aux collectivités
INSERT INTO "membership" ("member_id", "collectivity_id", "role_in_collectivity", "joined_at")
VALUES
  -- col-1
  ('c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'PRESIDENT', '2026-01-01'),
  ('c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VICE_PRESIDENT', '2026-01-01'),
  ('c1c33333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SECRETARY', '2026-01-01'),
  ('c1d44444-4444-4444-4444-444444444444', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'TREASURER', '2026-01-01'),
  ('c1e55555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('c1f66666-6666-6666-6666-666666666666', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('c1e77777-7777-7777-7777-777777777777', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('c1f88888-8888-8888-8888-888888888888', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  -- col-2
  ('c2a11111-1111-1111-1111-111111111111', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'SENIOR', '2026-01-01'),
  ('c2b22222-2222-2222-2222-222222222222', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'SENIOR', '2026-01-01'),
  ('c2c33333-3333-3333-3333-333333333333', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'SENIOR', '2026-01-01'),
  ('c2d44444-4444-4444-4444-444444444444', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'SENIOR', '2026-01-01'),
  ('c2e55555-5555-5555-5555-555555555555', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'PRESIDENT', '2026-01-01'),
  ('c2f66666-6666-6666-6666-666666666666', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'VICE_PRESIDENT', '2026-01-01'),
  ('c2e77777-7777-7777-7777-777777777777', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'SECRETARY', '2026-01-01'),
  ('c2f88888-8888-8888-8888-888888888888', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'TREASURER', '2026-01-01'),
  -- col-3
  ('c3a11111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'PRESIDENT', '2026-01-01'),
  ('c3b22222-2222-2222-2222-222222222222', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'VICE_PRESIDENT', '2026-01-01'),
  ('c3c33333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'SECRETARY', '2026-01-01'),
  ('c3d44444-4444-4444-4444-444444444444', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'TREASURER', '2026-01-01'),
  ('c3e55555-5555-5555-5555-555555555555', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'SENIOR', '2026-01-01'),
  ('c3f66666-6666-6666-6666-666666666666', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'SENIOR', '2026-01-01'),
  ('c3e77777-7777-7777-7777-777777777777', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'SENIOR', '2026-01-01'),
  ('c3f88888-8888-8888-8888-888888888888', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'SENIOR', '2026-01-01');

-- 7. Structures du bureau
INSERT INTO "collectivity_structure" ("collectivity_id", "mandat_year", "president_id", "vice_president_id", "treasurer_id", "secretary_id", "start_date", "end_date")
VALUES
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 2026, 'c1a11111-1111-1111-1111-111111111111', 'c1b22222-2222-2222-2222-222222222222', 'c1d44444-4444-4444-4444-444444444444', 'c1c33333-3333-3333-3333-333333333333', '2026-01-01', '2026-12-31'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 2026, 'c2e55555-5555-5555-5555-555555555555', 'c2f66666-6666-6666-6666-666666666666', 'c2f88888-8888-8888-8888-888888888888', 'c2e77777-7777-7777-7777-777777777777', '2026-01-01', '2026-12-31'),
  ('dddddddd-dddd-dddd-dddd-dddddddddddd', 2026, 'c3a11111-1111-1111-1111-111111111111', 'c3b22222-2222-2222-2222-222222222222', 'c3d44444-4444-4444-4444-444444444444', 'c3c33333-3333-3333-3333-333333333333', '2026-01-01', '2026-12-31');

-- 8. Parrainages (exemples selon le sujet)
INSERT INTO "referees" ("candidate_id", "referee_id", "target_collectivity_id", "relationship_nature")
VALUES
  ('c1c33333-3333-3333-3333-333333333333', 'c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1c33333-3333-3333-3333-333333333333', 'c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1d44444-4444-4444-4444-444444444444', 'c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1d44444-4444-4444-4444-444444444444', 'c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1e55555-5555-5555-5555-555555555555', 'c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1e55555-5555-5555-5555-555555555555', 'c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1f66666-6666-6666-6666-666666666666', 'c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1f66666-6666-6666-6666-666666666666', 'c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1e77777-7777-7777-7777-777777777777', 'c1a11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1e77777-7777-7777-7777-777777777777', 'c1b22222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1f88888-8888-8888-8888-888888888888', 'c1f66666-6666-6666-6666-666666666666', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue'),
  ('c1f88888-8888-8888-8888-888888888888', 'c1e77777-7777-7777-7777-777777777777', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'collègue');

-- 9. Comptes financiers (UUID valides)
INSERT INTO "financial_account" ("id", "collectivity_id", "account_type", "holder_name", "amount", "mobile_banking_service", "mobile_number")
VALUES
  ('c1ca5h11-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'CASH', NULL, 0, NULL, NULL),
  ('c1m0b111-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'MOBILE_MONEY', 'Mpanorina', 0, 'ORANGE_MONEY', '0370489612'),
  ('c2ca5h22-3333-3333-3333-333333333333', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'CASH', NULL, 0, NULL, NULL),
  ('c2m0b222-4444-4444-4444-444444444444', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'MOBILE_MONEY', 'Dobo voalohany', 0, 'ORANGE_MONEY', '0320489612'),
  ('c3ca5h33-5555-5555-5555-555555555555', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'CASH', NULL, 0, NULL, NULL);

-- 10. Cotisations (UUID valides)
INSERT INTO "membership_fee" ("id", "collectivity_id", "label", "amount", "frequency", "eligible_from", "status")
VALUES
  ('c0t11111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Cotisation annuelle', 100000, 'ANNUALLY', '2026-01-01', 'ACTIVE'),
  ('c0t22222-2222-2222-2222-222222222222', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Cotisation annuelle', 100000, 'ANNUALLY', '2026-01-01', 'ACTIVE'),
  ('c0t33333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Cotisation annuelle', 50000, 'ANNUALLY', '2026-01-01', 'ACTIVE');

-- 11. Paiements (UUID générés automatiquement avec gen_random_uuid())
INSERT INTO "payment" ("id", "member_id", "membership_fee_id", "amount", "payment_mode", "account_credited_id", "creation_date")
VALUES
  (gen_random_uuid(), 'c1a11111-1111-1111-1111-111111111111', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1b22222-2222-2222-2222-222222222222', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1c33333-3333-3333-3333-333333333333', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1d44444-4444-4444-4444-444444444444', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1e55555-5555-5555-5555-555555555555', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1f66666-6666-6666-6666-666666666666', 'c0t11111-1111-1111-1111-111111111111', 100000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1e77777-7777-7777-7777-777777777777', 'c0t11111-1111-1111-1111-111111111111', 60000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  (gen_random_uuid(), 'c1f88888-8888-8888-8888-888888888888', 'c0t11111-1111-1111-1111-111111111111', 90000, 'CASH', 'c1ca5h11-1111-1111-1111-111111111111', '2026-01-01'),
  -- col-2
  (gen_random_uuid(), 'c2a11111-1111-1111-1111-111111111111', 'c0t22222-2222-2222-2222-222222222222', 60000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2b22222-2222-2222-2222-222222222222', 'c0t22222-2222-2222-2222-222222222222', 90000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2c33333-3333-3333-3333-333333333333', 'c0t22222-2222-2222-2222-222222222222', 100000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2d44444-4444-4444-4444-444444444444', 'c0t22222-2222-2222-2222-222222222222', 100000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2e55555-5555-5555-5555-555555555555', 'c0t22222-2222-2222-2222-222222222222', 100000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2f66666-6666-6666-6666-666666666666', 'c0t22222-2222-2222-2222-222222222222', 100000, 'CASH', 'c2ca5h22-3333-3333-3333-333333333333', '2026-01-01'),
  (gen_random_uuid(), 'c2e77777-7777-7777-7777-777777777777', 'c0t22222-2222-2222-2222-222222222222', 40000, 'MOBILE_BANKING', 'c2m0b222-4444-4444-4444-444444444444', '2026-01-01'),
  (gen_random_uuid(), 'c2f88888-8888-8888-8888-888888888888', 'c0t22222-2222-2222-2222-222222222222', 60000, 'MOBILE_BANKING', 'c2m0b222-4444-4444-4444-444444444444', '2026-01-01');

-- 12. Transactions (générées)
INSERT INTO "collectivity_transaction" ("id", "collectivity_id", "member_debited_id", "amount", "payment_mode", "account_credited_id", "creation_date")
SELECT gen_random_uuid(), collectivity_id, member_id, amount, payment_mode, account_credited_id, creation_date
FROM payment p
JOIN "membership" ms ON p.member_id = ms.member_id
WHERE ms.left_at IS NULL;

-- Mise à jour des soldes (calcul manuel pour correspondre aux totaux)
UPDATE "financial_account" SET "amount" = 750000 WHERE "id" = 'c1ca5h11-1111-1111-1111-111111111111';
UPDATE "financial_account" SET "amount" = 650000 WHERE "id" = 'c2ca5h22-3333-3333-3333-333333333333';
UPDATE "financial_account" SET "amount" = 100000 WHERE "id" = 'c2m0b222-4444-4444-4444-444444444444';