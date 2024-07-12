#!/bin/bash

set -e
mkdir -p /data/download /data/output

encoding="iso-8859-1"
dialect="excel-semicolon"

# Ocorrências e aeronaves - CENIPA
for table in aeronave ocorrencia ocorrencia_tipo; do
	table_name="cenipa_${table}"
	url="https://dedalo.sti.fab.mil.br/dadosabertos/${table}.csv"
	filename="/data/download/${table_name}.csv"
	sql_filename="sql/${table_name}.sql"
	output_filename="/data/output/${table_name}.csv"

	rm -rf "$filename"
	wget -O "$filename" "$url"

	echo "DROP TABLE IF EXISTS ${table_name}_orig" | psql --no-psqlrc "$DATABASE_URL"
	rows pgimport \
		--dialect="$dialect" \
		--input-encoding="$encoding" \
		--schema=":text:" \
		"$filename" \
		"$DATABASE_URL" \
		"${table_name}_orig"
	#cat "sql/functions.sql" | psql --no-psqlrc "$DATABASE_URL"
	#cat "sql/urlid.sql" | psql --no-psqlrc "$DATABASE_URL"
	#cat "$sql_filename" | psql --no-psqlrc "$DATABASE_URL"
	#rows pgexport "$DATABASE_URL" "$table_name" "$output_filename"
	# TODO: executar SQL para tratar cada tabela
	# TODO: exportar dados
done
