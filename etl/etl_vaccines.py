import pandas as pd
from pathlib import Path

# path
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data_raw"
CLEAN_DIR = BASE_DIR / "data_staging"
input_file = RAW_DIR / "vaccines.csv"
output_file = CLEAN_DIR / "vaccines_clean.csv"

df = pd.read_csv(input_file)

# col rename
df = df.rename(columns={
    'vaccinekey': 'vaccine_key',
    'vaccinename': 'vaccine_name',
    'supplier': 'supplier',
    'technology': 'technology'
})

# filter
for col in ['vaccine_name', 'supplier', 'technology']:
    df[col] = df[col].astype(str).str.strip().str.replace('"', '')


CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File cleaned! Saved in {output_file}")

