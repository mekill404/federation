-- ============================================================
-- INSERTION DES DONNÉES MINIMALES POUR LES TESTS
-- À exécuter après data.sql
-- ============================================================

-- 1. Ville et spécialité agricole
INSERT INTO "Ville" ("nom") VALUES ('Antananarivo');
INSERT INTO "SpecialiteAgricole" ("code", "libelle") VALUES ('RIZ', 'Riziculture');

-- 2. Fédération (obligatoire pour approbation)
INSERT INTO "Federation" ("id", "nom", "sigle")
VALUES ('00000000-0000-0000-0000-000000000001', 'Fédération Nationale', 'FNM');

-- 3. Membres de test (10 membres avec des dates d'adhésion échelonnées)
-- Les 5 premiers ont une ancienneté ≥ 6 mois (créés le 2024-01-01)
-- Les 5 suivants sont plus récents
INSERT INTO "member" ("id", "first_name", "last_name", "birth_date", "gender", "address", "profession", "phone_number", "email", "occupation", "created_at")
VALUES
  -- 5 membres anciens (≥ 6 mois)
  ('11111111-1111-1111-1111-111111111111', 'Jean', 'Rakoto', '1980-05-15', 'MALE', 'Lot 123', 'Agriculteur', '0341111111', 'jean@test.mg', 'PRESIDENT', '2024-01-01'),
  ('22222222-2222-2222-2222-222222222222', 'Marie', 'Rabe', '1985-08-22', 'FEMALE', 'Lot 456', 'Éleveuse', '0342222222', 'marie@test.mg', 'SENIOR', '2024-01-15'),
  ('33333333-3333-3333-3333-333333333333', 'Paul', 'Razafy', '1975-03-10', 'MALE', 'Lot 789', 'Exportateur', '0343333333', 'paul@test.mg', 'SENIOR', '2024-02-01'),
  ('44444444-4444-4444-4444-444444444444', 'Lucie', 'Rasoanaivo', '1990-11-05', 'FEMALE', 'Lot 321', 'Technicien', '0344444444', 'lucie@test.mg', 'SENIOR', '2024-02-10'),
  ('55555555-5555-5555-5555-555555555555', 'Michel', 'Randria', '1982-07-30', 'MALE', 'Lot 654', 'Vétérinaire', '0345555555', 'michel@test.mg', 'SENIOR', '2024-03-01'),
  -- 5 membres récents (< 6 mois) ou date plus récente
  ('66666666-6666-6666-6666-666666666666', 'Chantal', 'Rakotomalala', '1988-12-12', 'FEMALE', 'Lot 111', 'Commerçante', '0346666666', 'chantal@test.mg', 'JUNIOR', '2024-09-01'),
  ('77777777-7777-7777-7777-777777777777', 'Andry', 'Rajaonarimampianina', '1970-06-06', 'MALE', 'Lot 222', 'Entrepreneur', '0347777777', 'andry@test.mg', 'VICE_PRESIDENT', '2024-09-15'),
  ('88888888-8888-8888-8888-888888888888', 'Miora', 'Randrianasolo', '1995-09-17', 'FEMALE', 'Lot 333', 'Ingénieure', '0348888888', 'miora@test.mg', 'SENIOR', '2024-10-01'),
  ('99999999-9999-9999-9999-999999999999', 'Hery', 'Rasolofonirina', '1983-04-25', 'MALE', 'Lot 444', 'Consultant', '0349999999', 'hery@test.mg', 'TREASURER', '2024-10-10'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Nirina', 'Rakotondrabe', '1992-02-28', 'FEMALE', 'Lot 555', 'Formatrice', '0340000000', 'nirina@test.mg', 'SECRETARY', '2024-11-01');

-- 4. Collectivité de test (approuvée par la fédération, sans numéro/nom unique pour l'instant)
INSERT INTO "collectivity" ("id", "location", "federation_approval", "approval_date", "id_ville", "id_specialite")
VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  'Antananarivo Centre',
  true,
  CURRENT_DATE,
  (SELECT id FROM "Ville" WHERE nom = 'Antananarivo'),
  (SELECT id FROM "SpecialiteAgricole" WHERE code = 'RIZ')
);

-- 5. Structure du bureau pour la collectivité (mandat en cours)
INSERT INTO "collectivity_structure" ("collectivity_id", "mandat_year", "president_id", "vice_president_id", "treasurer_id", "secretary_id", "start_date", "end_date")
VALUES (
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  2026,
  '11111111-1111-1111-1111-111111111111',  -- Jean (PRESIDENT)
  '77777777-7777-7777-7777-777777777777',  -- Andry (VICE_PRESIDENT)
  '99999999-9999-9999-9999-999999999999',  -- Hery (TREASURER)
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',  -- Nirina (SECRETARY)
  '2026-01-01',
  '2026-12-31'
);

-- 6. Adhésion des 10 membres à la collectivité (rôle JUNIOR par défaut, sauf ceux du bureau qui ont déjà un rôle spécifique)
INSERT INTO "membership" ("member_id", "collectivity_id", "role_in_collectivity", "joined_at")
VALUES
  -- Bureau avec leurs rôles spécifiques
  ('11111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'PRESIDENT', '2026-01-01'),
  ('77777777-7777-7777-7777-777777777777', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'VICE_PRESIDENT', '2026-01-01'),
  ('99999999-9999-9999-9999-999999999999', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'TREASURER', '2026-01-01'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SECRETARY', '2026-01-01'),
  -- Autres membres en tant que JUNIOR ou SENIOR
  ('22222222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('33333333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('44444444-4444-4444-4444-444444444444', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('55555555-5555-5555-5555-555555555555', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01'),
  ('66666666-6666-6666-6666-666666666666', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'JUNIOR', '2026-01-01'),
  ('88888888-8888-8888-8888-888888888888', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'SENIOR', '2026-01-01');

-- 7. Comptes financiers pour la collectivité (une caisse et un compte mobile money)
INSERT INTO "financial_account" ("id", "collectivity_id", "account_type", "holder_name", "amount")
VALUES 
  ('cccccccc-cccc-cccc-cccc-cccccccccc01', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'CASH', 'Caisse principale', 0.00);

INSERT INTO "financial_account" ("id", "collectivity_id", "account_type", "holder_name", "amount", "mobile_banking_service", "mobile_number")
VALUES 
  ('cccccccc-cccc-cccc-cccc-cccccccccc02', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'MOBILE_MONEY', 'Trésorier', 0.00, 'ORANGE_MONEY', '0341234567');

-- 8. Cotisations définies par la collectivité (une annuelle obligatoire)
INSERT INTO "membership_fee" ("id", "collectivity_id", "label", "amount", "frequency", "eligible_from", "status")
VALUES (
  'dddddddd-dddd-dddd-dddd-dddddddddddd',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  'Cotisation annuelle 2026',
  200000.00,
  'ANNUALLY',
  '2026-01-01',
  'ACTIVE'
);