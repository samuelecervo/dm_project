import pandas as pd
from pathlib import Path

# Percorsi
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data-raw"
CLEAN_DIR = BASE_DIR / "data-clean"

input_file = RAW_DIR / "popolazione_istat.csv"
output_file = CLEAN_DIR / "popolazione_istat_clean.csv"

# Funzione per mappare i range di età in gruppi standard
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
    'codice_regione': 'region_code',
    'codice_nuts_1': 'nuts_1_code',
    'descrizione_nuts_1': 'nuts_1_desc',
    'codice_nuts_2': 'nuts_2_code',
    'denominazione_regione': 'region_name',
    'sigla_regione': 'region_abbr',
    'latitudine_regione': 'latitude',
    'longitudine_regione': 'longitude',
    'range_eta': 'age_range',
    'totale_genere_maschile': 'male_count',
    'totale_genere_femminile': 'female_count',
    'totale_generale': 'total_count'
})

# Codici regione a due cifre
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# Colonna age_group standardizzata
df['age_group'] = df['age_range'].apply(map_age_range)

# Numerici: convertiamo a int e riempiamo NaN con 0
numerical_cols = ['male_count', 'female_count', 'total_count']
df[numerical_cols] = df[numerical_cols].fillna(0).astype(int)

df = df[['date', 'region_code', 'hospedalized', 'new_positive', 'deceased', 'swabs']]

# Salva CSV pulito
CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"pFile pulito salvato in {output_file}")
