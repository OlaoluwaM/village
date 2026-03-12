-- Verify village:appschema on pg
BEGIN;

SELECT
  pg_catalog.has_schema_privilege('village', 'usage');

ROLLBACK;
