-- Revert village:appschema from pg
BEGIN;

DROP SCHEMA IF EXISTS village CASCADE;

COMMIT;
