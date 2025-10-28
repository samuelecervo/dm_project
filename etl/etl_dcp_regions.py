import pandas as pd
from pathlib import Path

# path
BASE_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = BASE_DIR / "data_raw"
CLEAN_DIR = BASE_DIR / "source_layer"
input_file = RAW_DIR / "dcp_regions.csv"
output_file = CLEAN_DIR / "dcp_regions_clean.csv"
df = pd.read_csv(input_file)

# column rename
df = df.rename(columns={
    'data': 'date',
    'stato': 'country_code',
    'codice_regione': 'region_code',
    'denominazione_regione': 'region_name',
    'lat': 'latitude',
    'long': 'longitude',
    'ricoverati_con_sintomi': 'hospitalized',
    'terapia_intensiva': 'intensive_care',
    'totale_ospedalizzati': 'total_hospitalized',
    'isolamento_domiciliare': 'home_isolation',
    'totale_positivi': 'total_positive',
    'variazione_totale_positivi': 'variation_total_positive',
    'nuovi_positivi': 'new_positives',
    'dimessi_guariti': 'recovered',
    'deceduti': 'deceased',
    'casi_da_sospetto_diagnostico': 'suspected_cases',
    'casi_da_screening': 'screening_cases',
    'totale_casi': 'total_cases',
    'tamponi': 'swabs',
    'casi_testati': 'tested_cases',
    'ingressi_terapia_intensiva': 'intensive_care_admissions',
    'totale_positivi_test_molecolare': 'positive_molecular_test',
    'totale_positivi_test_antigenico_rapido': 'positive_rapid_antigen_test',
    'tamponi_test_molecolare': 'molecular_swabs',
    'tamponi_test_antigenico_rapido': 'rapid_antigen_swabs',
    'codice_nuts_1': 'nuts_1_code',
    'codice_nuts_2': 'nuts_2_code',
    'note': 'notes',
    'note_test': 'test_notes',
    'note_casi': 'case_notes'
})

# date to YYYY-MM-DD
df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

# region code uniform
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# num colomns
numerical_cols = [
    'hospitalized', 'intensive_care', 'total_hospitalized', 'home_isolation',
    'total_positive', 'variation_total_positive', 'new_positives', 'recovered', 'deceased',
    'suspected_cases', 'screening_cases', 'total_cases', 'swabs', 'tested_cases',
    'intensive_care_admissions', 'positive_molecular_test', 'positive_rapid_antigen_test',
    'molecular_swabs', 'rapid_antigen_swabs'
]

for col in numerical_cols:
    if col in df.columns:
        df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0).astype(int)

# filtering
df = df[['date', 'region_code', 'hospitalized', 'new_positives', 'deceased', 'swabs']]

CLEAN_DIR.mkdir(exist_ok=True)
df.to_csv(output_file, index=False)

print(f"File cleaned! Saved in {output_file}")
