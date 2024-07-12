CREATE OR REPLACE FUNCTION clean_text(value TEXT) RETURNS TEXT AS $$
BEGIN
  RETURN CASE
    WHEN LOWER(value) NOT IN ('', 'null') THEN TRIM(value)
    ELSE NULL
  END;
END
$$ LANGUAGE 'plpgsql' IMMUTABLE;

CREATE OR REPLACE FUNCTION parse_date(date_str TEXT) RETURNS DATE AS $$
DECLARE
    parsed_date DATE;
BEGIN
  IF length(date_str) = 8 THEN -- Formato DDMMYYYY
      parsed_date := to_date(date_str, 'DDMMYYYY');
  ELSIF length(date_str) = 6 THEN -- Formato DDMMYY
    parsed_date := to_date(
      CASE
          WHEN substring(date_str, 5, 2)::int <= 50 THEN substring(date_str, 1, 4) || '20' || substring(date_str, 5, 2)
          ELSE substring(date_str, 1, 4) || '19' || substring(date_str, 5, 2)
      END,
      'DDMMYYYY'
    );
    ELSE -- Caso o formato não seja reconhecido, lança um erro
        RAISE EXCEPTION 'Formato de data não reconhecido: %', date_str;
    END IF;
    RETURN parsed_date;
END;
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
