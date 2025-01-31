CREATE OR REPLACE FUNCTION clean_text(value TEXT) RETURNS TEXT AS $$
BEGIN
  RETURN CASE
    WHEN LOWER(value) NOT IN ('', 'null') THEN TRIM(value)
    ELSE NULL
  END;
END
$$ LANGUAGE 'plpgsql' IMMUTABLE;

CREATE OR REPLACE FUNCTION parse_int(value TEXT) RETURNS INT AS $$
BEGIN
  RETURN CASE
    WHEN TRIM(LOWER(value)) IN ('null', '******', '', 'xxxx') THEN NULL
    ELSE TRIM(value)::int
  END;
END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;

CREATE OR REPLACE FUNCTION parse_status_ca_cva(value TEXT) RETURNS TEXT AS $$
BEGIN
  RETURN CASE
    WHEN TRIM(LOWER(value)) IN ('null', '******', '') THEN NULL
    WHEN TRIM(LOWER(value)) IN ('abordo') THEN 'Abordo'
    WHEN TRIM(LOWER(value)) IN ('isenta', 'msenta', 'isento', 'dsenta') THEN 'Isenta'
    WHEN TRIM(value) ~ '^[0-9]+$' THEN NULL
    WHEN TRIM(value) = '' THEN NULL
    ELSE NULL
  END;
END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
