import pandas as pd
from pathlib import Path

# path
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data_raw"
CLEAN_DIR = BASE_DIR / "source_layer"
input_file = RAW_DIR / "popolazione_istat.csv"
output_file = CLEAN_DIR / "popolazione_istat_clean.csv"

# age group standardization
def map_age_range(age_range):
    if pd.isna(age_range):
        return None
    age_range = str(age_range).strip()
    if age_range in ['0-14','15-29']:
        return '00-29'
    elif age_range in ['30-49']:
        return '30-49'
    elif age_range in ['50-69']:
        return '50-69'
    elif age_range in ['70+']:
        return '70+'
    else:
        return None

df = pd.read_csv(input_file)

# col rename
df = df.rename(columns={
    'anno':'year',
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

# region code
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# age group standard
df['age_group'] = df['age_range'].apply(map_age_range)

# num cols and 0/null values
numerical_cols = ['male_count', 'female_count', 'total_count']
df[numerical_cols] = df[numerical_cols].fillna(0).astype(int)

# filtering
df = df[['year','region_code', 'region_name', 'age_group', 'male_count', 'female_count', 'total_count']]

CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File cleaned! Saved in {output_file}")

