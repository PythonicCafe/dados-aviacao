DROP TABLE IF EXISTS anac_aeronave;
CREATE TABLE anac_aeronave AS
  SELECT
    CASE
      WHEN LENGTH(proprietario_documento) = 11 AND SUBSTRING(proprietario_documento FROM 4 FOR 6) ~ '^[0-9]{6}$'
        THEN person_uuid(proprietario_documento, proprietario)
      WHEN LENGTH(proprietario_documento) = 14
        THEN company_uuid(proprietario_documento)
      ELSE uuid_nil()
    END AS object_uuid,
    CASE
      WHEN LENGTH(proprietario_documento) = 11 THEN 'Pessoa física'
      WHEN LENGTH(proprietario_documento) = 14 THEN 'Pessoa jurídica'
      ELSE NULL
    END AS tipo_proprietario,
    *
  FROM (
    SELECT
      clean_text(marca) AS marca,
      clean_text(proprietario) AS proprietario,
      REPLACE(REGEXP_REPLACE(clean_text(cpf_cnpj), '[./-]', '', 'g'), 'X', '*') AS proprietario_documento,
      clean_text(outros_proprietarios) AS outros_proprietarios,
      clean_text(sg_uf) AS uf_proprietario,
      clean_text(nm_operador) AS operador,
      clean_text(outros_operadores) AS outros_operadores,
      clean_text(uf_operador) AS uf_operador,
      REPLACE(REGEXP_REPLACE(clean_text(cpf_cgc), '[./-]', '', 'g'), 'X', '*') AS operador_documento,
      parse_int(clean_text(nr_cert_matricula)) AS matricula,
      clean_text(nr_serie) AS numero_serie,
      clean_text(cd_categoria) AS cd_categoria, -- TODO: renomear?
      clean_text(cd_tipo) AS cd_tipo, -- TODO: renomear?
      clean_text(ds_modelo) AS modelo,
      clean_text(nm_fabricante) AS fabricante,
      clean_text(cd_cls) AS cd_cls, -- TODO: renomear?
      clean_text(cd_tipo_icao) AS tipo_icao,
      clean_text(nr_pmd) AS peso_max_decolagem,
      parse_int(clean_text(nr_tripulacao_min)) AS tripulacao_min,
      parse_int(clean_text(nr_passageiros_max)) AS passageiros_max,
      parse_int(clean_text(nr_assentos)) AS assentos,
      parse_int(clean_text(nr_ano_fabricacao)) AS ano_fabricacao,
      CASE
        WHEN clean_text(dt_validade_cva) ~ '^[0-9]+$' THEN to_date(clean_text(dt_validade_cva), 'DDMMYYYY')
        ELSE NULL
      END AS data_validade_cva,
      parse_status_ca_cva(dt_validade_cva) AS cva_status,
      CASE
        WHEN clean_text(dt_validade_ca) ~ '^[0-9]+$' THEN to_date(clean_text(dt_validade_ca), 'DDMMYYYY')
        ELSE NULL
      END AS data_validade_ca,
      parse_status_ca_cva(dt_validade_ca) AS ca_status,
      to_timestamp(clean_text(dt_canc), 'YYYY-MM-DD HH24:MI:SS.US') AS data_cancelamento,
      clean_text(ds_motivo_canc) AS motivo_cancelamento,
      clean_text(cd_interdicao) AS cd_interdicao, -- TODO: renomear?
      clean_text(cd_marca_nac1) AS cd_marca_nac1, -- TODO: renomear?
      clean_text(cd_marca_nac2) AS cd_marca_nac2, -- TODO: renomear?
      clean_text(cd_marca_nac3) AS cd_marca_nac3, -- TODO: renomear?
      clean_text(cd_marca_estrangeira) AS cd_marca_estrangeira, -- TODO: renomear?
      clean_text(ds_gravame) AS observacao,
      to_timestamp(clean_text(dt_matricula), 'YYYY-MM-DD HH24:MI:SS.US') AS data_matricula
    FROM anac_aeronave_orig
  ) AS t;
