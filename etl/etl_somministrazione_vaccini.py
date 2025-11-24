import pandas as pd
from pathlib import Path

# Path
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data_raw"
CLEAN_DIR = BASE_DIR / "data_staging"

input_file = RAW_DIR / "somministrazioni-vaccini.csv"
output_file = CLEAN_DIR / "italian_vaccination_clean.csv"

# mapping age
def map_age_group(age):
    if pd.isna(age):
        return None
    age = str(age).strip()
    # 0-14 → 0-15
    if age in ['00-04','05-11','12-19','20-29']:
        return '00-29'
    # 30-49
    elif age in ['30-39','40-49']:
        return '30-49'
    # 50-69
    elif age in ['50-59','60-69']:
        return '50-69'
    # 70+
    elif age in ['70-79','80-89','90+']:
        return '70+'
    else:
        return None  
    
df = pd.read_csv(input_file)

# rename col
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

# region_code
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# date to YYYY-MM-DD
df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

#  age_group standard
df['age_group'] = df['age_range'].apply(map_age_group)

# num col, 0/null val
numerical_cols = ['males', 'females', 'first_dose', 'second_dose', 
                  'previous_infection', 'additional_booster_dose', 'second_booster']
df[numerical_cols] = df[numerical_cols].fillna(0).astype(int)

# filter
df = df[['date', 'supplier', 'region_code', 'age_group', 'males', 'females', 'first_dose', 'second_dose', 'additional_booster_dose', 'second_booster', 'db3']]

CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File cleaned! Saved in {output_file}")