import pandas as pd
from pathlib import Path

# Percorsi
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data-raw"
CLEAN_DIR = BASE_DIR / "data-clean"

input_file = RAW_DIR / "somministrazioni-vaccini.csv"
output_file = CLEAN_DIR / "italian_vaccination_clean.csv"

# Funzione per mappare range di età in gruppi standard
def map_age_range(age_range):
    if pd.isna(age_range):
        return None
    age_range = str(age_range).strip()
    if age_range in ['0-15']:
        return '0-15'
    elif age_range in ['16-19', '20-29']:
        return '16-29'
    elif age_range in ['30-39', '40-49']:
        return '30-49'
    elif age_range in ['50-59', '60-69']:
        return '50-69'
    elif age_range in ['70-79', '80-89', '90+']:
        return '70+'
    else:
        return 'Other'

# Leggi CSV
df = pd.read_csv(input_file)

# Rinomina colonne in inglese
df = df.rename(columns={
    'data': 'date',
    'forn': 'supplier',
    'area': 'region_abbr',
    'eta': 'age_range',
    'm': 'males',
    'f': 'females',
    'd1': 'first_dose',
    'd2': 'second_dose',
    'dpi': 'previous_infection',
    'db1': 'additional_booster_dose',
    'db2': 'second_booster',
    'db3': 'db3',
    'N1': 'nuts_1_code',
    'N2': 'nuts_2_code',
    'ISTAT': 'region_code',
    'reg': 'region_name'
})

# Codici regione a due cifre
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# Date in formato YYYY-MM-DD
df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

# Colonna age_group standardizzata
df['age_group'] = df['age_range'].apply(map_age_range)

# Numerici: convertiamo a int e riempiamo NaN con 0
numerical_cols = ['males', 'females', 'first_dose', 'second_dose', 
                  'previous_infection', 'additional_booster_dose', 'second_booster']
df[numerical_cols] = df[numerical_cols].fillna(0).astype(int)

df = df[['date', 'region_code', 'age_group', 'males', 'females', 'first_dose', 'second_dose', 'additional_booster_dose', 'second_booster', 'db3']]

# Salva CSV pulito
CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File pulito salvato in {output_file}")
