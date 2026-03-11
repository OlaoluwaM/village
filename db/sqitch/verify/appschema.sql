-- Verify village:appschema on pg
BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_namespace WHERE nspname = 'village'
  ) THEN
    RAISE EXCEPTION 'Schema "village" does not exist';
  END IF;

  IF NOT pg_catalog.has_schema_privilege('village', 'usage') THEN
    RAISE EXCEPTION 'Current user lacks USAGE privilege on schema "village"';
  END IF;
END;
$$;

ROLLBACK;
