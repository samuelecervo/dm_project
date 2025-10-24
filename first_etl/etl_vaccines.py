import pandas as pd
from pathlib import Path

# Percorsi
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data-raw"
CLEAN_DIR = BASE_DIR / "data-clean"

input_file = RAW_DIR / "vaccines.csv"
output_file = CLEAN_DIR / "vaccines_clean.csv"

# Leggi CSV
df = pd.read_csv(input_file)

# Rinomina colonne in snake_case
df = df.rename(columns={
    'vaccinekey': 'vaccine_key',
    'vaccinename': 'vaccine_name',
    'supplier': 'supplier',
    'technology': 'technology'
})

# Rimuovi spazi bianchi e virgolette dai campi testuali
for col in ['vaccine_name', 'supplier', 'technology']:
    df[col] = df[col].astype(str).str.strip().str.replace('"', '')

# Salva CSV pulito
CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File pulito salvato in {output_file}")
