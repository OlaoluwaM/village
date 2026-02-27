-- Deploy village:appschema to pg
BEGIN;

CREATE SCHEMA IF NOT EXISTS village;

COMMIT;
