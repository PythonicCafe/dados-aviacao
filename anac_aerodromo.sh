#!/bin/bash

set -e
mkdir -p /data/download /data/output


# Aeródromos públicos - ANAC
table_name="anac_aerodromo"
url="https://sistemas.anac.gov.br/dadosabertos/Aerodromos/Aer%C3%B3dromos%20P%C3%BAblicos/Lista%20de%20aer%C3%B3dromos%20p%C3%BAblicos/AerodromosPublicos.csv"
filename="/data/download/${table_name}.csv"
filename_fixed="/data/download/${table_name}-fixed.csv"
filename_fixed_2="/data/download/${table_name}-fixed-2.csv"
encoding="utf-8"
dialect="excel"
sql_filename="sql/${table_name}.sql"
output_filename="/data/output/${table_name}.csv"

rm -rf "$filename" "$filename_fixed" "$filename_fixed_2"
wget -O "$filename" "$url"
tail -n +2 "$filename" > "$filename_fixed"
rows csv-fix $filename_fixed $filename_fixed_2  # TODO: not working?! 494 vs 204 rows

echo "DROP TABLE IF EXISTS ${table_name}_orig" | psql --no-psqlrc "$DATABASE_URL"
rows pgimport \
	--dialect="$dialect" \
	--input-encoding="$encoding" \
	--schema=":text:" \
	"$filename_fixed_2" \
	"$DATABASE_URL" \
	"${table_name}_orig"
#cat "sql/functions.sql" | psql --no-psqlrc "$DATABASE_URL"
#cat "sql/urlid.sql" | psql --no-psqlrc "$DATABASE_URL"
#cat "$sql_filename" | psql --no-psqlrc "$DATABASE_URL"
#rows pgexport "$DATABASE_URL" "$table_name" "$output_filename"
# TODO: implementar SQL para tratar a tabela
# TODO: exportar dados
