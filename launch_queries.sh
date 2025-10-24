#!/bin/bash

DB_HOST="localhost"
DB_USER="postgres"
DB_NAME="dm_project_cervo_capparelli"

OUTPUT_DIR="analysis_output"
mkdir -p $OUTPUT_DIR

SQL_DIR="sql_query"

for sql_file in "$SQL_DIR"/*.sql; do
    base_name=$(basename "$sql_file" .sql)      
    csv_file="${OUTPUT_DIR}/${base_name}.csv"    
    echo ">>> execute: $sql_file → $csv_file"
    /Library/PostgreSQL/18/bin/psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f "$sql_file" -o "$csv_file" --csv
done

echo "All queries in $SQL_DIR are exported in $OUTPUT_DIR"