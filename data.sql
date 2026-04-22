CREATE TYPE "gender" AS ENUM (
  'MALE',
  'FEMALE'
);

CREATE TYPE "member_occupation" AS ENUM (
  'JUNIOR',
  'SENIOR',
  'SECRETARY',
  'TREASURER',
  'VICE_PRESIDENT',
  'PRESIDENT'
);

CREATE TYPE "frequency" AS ENUM (
  'WEEKLY',
  'MONTHLY',
  'ANNUALLY',
  'PUNCTUALLY'
);

CREATE TYPE "activity_status" AS ENUM (
  'ACTIVE',
  'INACTIVE'
);

CREATE TYPE "payment_mode" AS ENUM (
  'CASH',
  'MOBILE_BANKING',
  'BANK_TRANSFER'
);

CREATE TYPE "mobile_banking_service" AS ENUM (
  'AIRTEL_MONEY',
  'MVOLA',
  'ORANGE_MONEY'
);

CREATE TYPE "bank_name" AS ENUM (
  'BRED',
  'MCB',
  'BMOI',
  'BOA',
  'BGFI',
  'AFG',
  'ACCES_BANQUE',
  'BAOBAB',
  'SIPEM'
);

CREATE TYPE "account_type" AS ENUM (
  'CASH',
  'MOBILE_MONEY',
  'BANK'
);

CREATE TYPE "mandat_entity_type" AS ENUM (
  'COLLECTIVITY',
  'FEDERATION'
);

CREATE TABLE "Ville" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "nom" varchar(100) UNIQUE NOT NULL
);

CREATE TABLE "SpecialiteAgricole" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "code" varchar(50) UNIQUE NOT NULL,
  "libelle" varchar(200) NOT NULL
);

CREATE TABLE "Federation" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "nom" varchar(200) NOT NULL DEFAULT 'Fédération des Collectivités Agricoles de Madagascar',
  "sigle" varchar(50),
  "date_creation" date DEFAULT (CURRENT_DATE),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "member" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "first_name" varchar(100) NOT NULL,
  "last_name" varchar(100) NOT NULL,
  "birth_date" date NOT NULL,
  "gender" gender NOT NULL,
  "address" text NOT NULL,
  "profession" varchar(200) NOT NULL,
  "phone_number" varchar(20) UNIQUE NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "occupation" member_occupation NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "collectivity" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "location" varchar(200) NOT NULL,
  "federation_approval" boolean DEFAULT false,
  "approval_date" date,
  "unique_number" varchar(50) UNIQUE,
  "unique_name" varchar(200) UNIQUE,
  "date_creation" date DEFAULT (CURRENT_DATE),
  "id_ville" uuid,
  "id_specialite" uuid,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "membership" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "member_id" uuid NOT NULL,
  "collectivity_id" uuid NOT NULL,
  "role_in_collectivity" member_occupation NOT NULL,
  "joined_at" date DEFAULT (CURRENT_DATE),
  "left_at" date,
  "is_active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "referees" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "candidate_id" uuid NOT NULL,
  "referee_id" uuid NOT NULL,
  "target_collectivity_id" uuid NOT NULL,
  "relationship_nature" varchar(50),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Mandat" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "entite_type" mandat_entity_type NOT NULL,
  "id_entite" uuid NOT NULL,
  "annee_debut" int NOT NULL,
  "duree_ans" int NOT NULL,
  "date_debut" date NOT NULL,
  "date_fin" date NOT NULL,
  "est_actif" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "MandatPoste" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "mandat_id" uuid NOT NULL,
  "member_id" uuid NOT NULL,
  "poste" member_occupation NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "collectivity_structure" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "collectivity_id" uuid NOT NULL,
  "mandat_year" int NOT NULL,
  "president_id" uuid NOT NULL,
  "vice_president_id" uuid NOT NULL,
  "treasurer_id" uuid NOT NULL,
  "secretary_id" uuid NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "financial_account" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "collectivity_id" uuid NOT NULL,
  "account_type" account_type NOT NULL,
  "holder_name" varchar(200),
  "amount" decimal(15,2) DEFAULT 0,
  "bank_name" bank_name,
  "bank_code" varchar(5),
  "bank_branch_code" varchar(5),
  "bank_account_number" varchar(11),
  "bank_account_key" varchar(2),
  "mobile_banking_service" mobile_banking_service,
  "mobile_number" varchar(20),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "membership_fee" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "collectivity_id" uuid NOT NULL,
  "label" varchar(200) NOT NULL,
  "amount" decimal(15,2) NOT NULL,
  "frequency" frequency NOT NULL,
  "eligible_from" date NOT NULL,
  "status" activity_status DEFAULT 'ACTIVE',
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "payment" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "member_id" uuid NOT NULL,
  "membership_fee_id" uuid,
  "amount" decimal(15,2) NOT NULL,
  "payment_mode" payment_mode NOT NULL,
  "account_credited_id" uuid NOT NULL,
  "creation_date" date DEFAULT (CURRENT_DATE),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "collectivity_transaction" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "collectivity_id" uuid NOT NULL,
  "member_debited_id" uuid NOT NULL,
  "amount" decimal(15,2) NOT NULL,
  "payment_mode" payment_mode NOT NULL,
  "account_credited_id" uuid NOT NULL,
  "creation_date" date DEFAULT (CURRENT_DATE),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Activite" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "titre" varchar(200) NOT NULL,
  "description" text,
  "type_activite" varchar(50) NOT NULL,
  "date_activite" date NOT NULL,
  "heure_debut" time,
  "heure_fin" time,
  "lieu" varchar(500),
  "est_obligatoire" boolean DEFAULT false,
  "public_cible" varchar(200),
  "collectivity_id" uuid,
  "federation_id" uuid,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Presence" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "activite_id" uuid NOT NULL,
  "member_id" uuid NOT NULL,
  "statut" varchar(20) NOT NULL,
  "motif_absence" text,
  "est_membre_externe" boolean DEFAULT false,
  "collectivite_origine_id" uuid,
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "financial_account_federation" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "federation_id" uuid NOT NULL,
  "account_type" account_type NOT NULL,
  "holder_name" varchar(200),
  "amount" decimal(15,2) DEFAULT 0,
  "bank_name" bank_name,
  "bank_code" varchar(5),
  "bank_branch_code" varchar(5),
  "bank_account_number" varchar(11),
  "bank_account_key" varchar(2),
  "mobile_banking_service" mobile_banking_service,
  "mobile_number" varchar(20),
  "created_at" timestamp DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE UNIQUE INDEX ON "membership" ("member_id", "collectivity_id");

CREATE UNIQUE INDEX ON "referees" ("candidate_id", "referee_id");

CREATE UNIQUE INDEX ON "MandatPoste" ("mandat_id", "poste");

CREATE UNIQUE INDEX ON "collectivity_structure" ("collectivity_id", "mandat_year");

CREATE UNIQUE INDEX ON "Presence" ("activite_id", "member_id");

COMMENT ON TABLE "member" IS 'occupation = poste global ; peut différer du rôle dans une collectivité';

COMMENT ON TABLE "collectivity" IS 'unique_number et unique_name peuvent être NULL avant attribution';

COMMENT ON TABLE "membership" IS 'Un membre peut changer de collectivité ou démissionner';

COMMENT ON TABLE "referees" IS 'CHECK (candidate_id <> referee_id) ; le parrain doit être MEMBRE_CONFIRME (SENIOR) et avoir >90j d''ancienneté';

COMMENT ON TABLE "Mandat" IS 'Un mandat est défini pour une entité sur une période. Les postes spécifiques sont attribués via MandatPoste.';

COMMENT ON TABLE "MandatPoste" IS 'Limite métier : un membre ne peut occuper le même poste spécifique plus de 2 mandats (total, toute collectivité confondue)';

COMMENT ON TABLE "collectivity_structure" IS 'Table temporaire en attendant l''implémentation complète des mandats';

COMMENT ON TABLE "financial_account" IS 'Contraintes CHECK : les champs bancaires ne sont remplis que pour account_type=''BANK'', idem pour mobile';

COMMENT ON TABLE "collectivity_transaction" IS 'Générée automatiquement à chaque paiement (traçabilité comptable)';

COMMENT ON TABLE "Activite" IS 'Une activité appartient soit à une collectivité, soit à la fédération';

COMMENT ON TABLE "financial_account_federation" IS 'Mêmes règles que pour les comptes des collectivités';

ALTER TABLE "collectivity" ADD FOREIGN KEY ("id_ville") REFERENCES "Ville" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity" ADD FOREIGN KEY ("id_specialite") REFERENCES "SpecialiteAgricole" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "membership" ADD FOREIGN KEY ("member_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "membership" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "referees" ADD FOREIGN KEY ("candidate_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "referees" ADD FOREIGN KEY ("referee_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "referees" ADD FOREIGN KEY ("target_collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "MandatPoste" ADD FOREIGN KEY ("mandat_id") REFERENCES "Mandat" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "MandatPoste" ADD FOREIGN KEY ("member_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_structure" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_structure" ADD FOREIGN KEY ("president_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_structure" ADD FOREIGN KEY ("vice_president_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_structure" ADD FOREIGN KEY ("treasurer_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_structure" ADD FOREIGN KEY ("secretary_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "financial_account" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "membership_fee" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "payment" ADD FOREIGN KEY ("member_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "payment" ADD FOREIGN KEY ("membership_fee_id") REFERENCES "membership_fee" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "payment" ADD FOREIGN KEY ("account_credited_id") REFERENCES "financial_account" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_transaction" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_transaction" ADD FOREIGN KEY ("member_debited_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "collectivity_transaction" ADD FOREIGN KEY ("account_credited_id") REFERENCES "financial_account" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "Activite" ADD FOREIGN KEY ("collectivity_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "Activite" ADD FOREIGN KEY ("federation_id") REFERENCES "Federation" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "Presence" ADD FOREIGN KEY ("activite_id") REFERENCES "Activite" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "Presence" ADD FOREIGN KEY ("member_id") REFERENCES "member" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "Presence" ADD FOREIGN KEY ("collectivite_origine_id") REFERENCES "collectivity" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "financial_account_federation" ADD FOREIGN KEY ("federation_id") REFERENCES "Federation" ("id") DEFERRABLE INITIALLY IMMEDIATE;
