import pandas as pd
from pathlib import Path

# path
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data_raw"
CLEAN_DIR = BASE_DIR / "staging_layer"
input_file = RAW_DIR / "istat_regions.csv"
output_file = CLEAN_DIR / "istat_regions_clean.csv"

df = pd.read_csv(input_file)

# filter and rename
df = df[['codice', 'nome', 'abbreviazione']].rename(columns={
    'codice': 'region_code',
    'nome': 'region_name',
    'abbreviazione': 'region_abbr'
})

# region_code
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}")

CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File cleaned! Saved in {output_file}")
