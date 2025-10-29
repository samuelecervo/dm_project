import os
from getpass import getpass
import psycopg2
import pandas as pd
from glob import glob

# Database 
DB_HOST = "localhost"
DB_USER = "postgres"
DB_NAME = "dm_project_cervo_capparelli"
DB_PASSWORD = getpass(f"Password for {DB_USER}: ")

SQL_DIR = "sql_query"
OUTPUT_DIR = "analysis_output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

conn = psycopg2.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    dbname=DB_NAME
)
cur = conn.cursor()

# views.sql
views_file = os.path.join(SQL_DIR, "views.sql")
if os.path.exists(views_file):
    print(f"\nExecuting {views_file}")
    with open(views_file, "r") as f:
        sql_content = f.read()
    cur.execute(sql_content)
    conn.commit()
    print("Views created")

# other sql
sql_files = sorted(glob(os.path.join(SQL_DIR, "*.sql")))
for sql_file in sql_files:
    if os.path.basename(sql_file) == "views.sql":
        continue 
    base_name = os.path.splitext(os.path.basename(sql_file))[0]
    csv_file = os.path.join(OUTPUT_DIR, f"{base_name}.csv")

    print(f"\nExecute: {sql_file}")
    with open(sql_file, "r") as f:
        query = f.read()

    try:
        df = pd.read_sql_query(query, conn)
        df.to_csv(csv_file, index=False)
        print(f"Saved → {csv_file}")
    except Exception as e:
        print(f"Error in {sql_file}: {e}")

cur.close()
conn.close()
print("\nFinish")
